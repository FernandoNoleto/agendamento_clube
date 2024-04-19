import 'dart:convert';

import 'package:agendamento_clube/Controllers/reservation_control_controller.dart';
import 'package:agendamento_clube/Models/reservation.dart';
import 'package:agendamento_clube/Providers/firebase_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

class RequestReservationController {

  void addNewReservation(String name, DateTimeRange date, int color, status) async {
    debugPrint("Tentando criar reserva!");
    Reservation reservation = Reservation(name: name, date: date, color: color, status: status);
    String nameReservation = reservation.name;
    debugPrint('$reservation');
    debugPrint(nameReservation);

    final reservationReference = FirebaseProvider().connection('/Reservations/$nameReservation');
    debugPrint('${reservation.toJson()}');
    try{
      await reservationReference.update(reservation.toJson());
      debugPrint('Reserva criada!');
    }
    catch(error){
      if (kDebugMode) {
        print(error);
      }
    }
  }

  //RECUPERA RESERVAS FEITAS
  Future<DatabaseEvent> retrieveReservations() async{
    final ref = FirebaseDatabase.instance.ref();
    final event = await ref.child('/Reservations').once();

    return event;
  }

  Future<List<DateTime>> retrieveReservationsList() async{
    final ref = FirebaseDatabase.instance.ref();
    final event = await ref.child('/Reservations').once();
    
    final Map<String, dynamic> map = json.decode(jsonEncode(event.snapshot.value));
    List<DateTime> datasReservadas = [];
    map.forEach((key, value) {
      final nextDate = Map<String, dynamic>.from(value);
      var data = DateTime.parse(nextDate['date']);
      datasReservadas.add(data);
    });

    return datasReservadas;
  }

  // List<DateTime> retrieveListReservations() {
  //   DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   List<DateTime> availableDaysList = [];
  //   for (int i = 0; i < 30; i++) {
  //     availableDaysList.add(DateUtils.dateOnly(DateTime(today.year, today.month, today.day + i)));
  //   }
  //
  //   List<DateTime> datasReservadas = [];
  //   retrieveReservations().then((snapshot){
  //     final Map<String, dynamic> map = json.decode(jsonEncode(snapshot.snapshot.value));
  //     debugPrint('------map-----');
  //     debugPrint('$map');
  //     map.forEach((key, value) {
  //       final nextDate = Map<String, dynamic>.from(value);
  //       var data = DateTime.parse(nextDate['date']);
  //       datasReservadas.add(data);
  //     });
  //     debugPrint('------datasReservadas-----');
  //     debugPrint('$datasReservadas');
  //   });
  //
  //   debugPrint('------value-----');
  //   for (var value in availableDaysList) {
  //     debugPrint('$value');
  //   }
  //
  //   return datasReservadas;
  // }

  //RECUPERA LISTA DE DIAS DISPONIVEIS PARA RESERVA

  Future<List<DateTime>> retrieveAvailableRangeDaysList() async {
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List <DateTime>availableDaysList = [];
    for (int i = 0; i < 30; i++) {
      availableDaysList.add(DateUtils.dateOnly(DateTime(today.year, today.month, today.day + i)));
    }

    DatabaseEvent event = await retrieveReservations();
    final Map<String, dynamic> map = json.decode(jsonEncode(event.snapshot.value));
    debugPrint('$map');
    List datasReservadas = [];
    map.forEach((key, value) {
      final nextDate = Map<String, dynamic>.from(value);
      var data = DateTime.parse(nextDate['date']);
      datasReservadas.add(data);

    });
    debugPrint('$datasReservadas');


    for (var value in availableDaysList) {
      debugPrint('$value');
    }

    return availableDaysList;
  }

  // List<DateTime> oneMonthDaysList() {
  //   DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //   List <DateTime> oneMonthDaysList = [];
  //   for (int i = 0; i < 30; i++) {
  //     oneMonthDaysList.add(DateUtils.dateOnly(DateTime(today.year, today.month, today.day + i)));
  //   }
  //
  //
  //
  //   return oneMonthDaysList;
  // }

  // PEGA LISTA DE RANGE DE DATAS DISPONIVEIS DENTRO DE 1 MES
  List<DateTimeRange> oneMonthDaysList(){
    List<DateTimeRange> oneMonthDaysList = [];
    oneMonthDaysList.addAll(_getWeekdayRanges());
    oneMonthDaysList.addAll(_getWeekendRanges());
    return oneMonthDaysList;
  }

  List<DateTimeRange> _getWeekendRanges() {
    List<DateTimeRange> weekendRanges = [];
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    DateTime tempDate = firstDayOfMonth;

    while (tempDate.isBefore(lastDayOfMonth)) {
      if (tempDate.weekday == DateTime.saturday) {
        DateTimeRange range = DateTimeRange(
          start:tempDate,
          end:tempDate.add(const Duration(days: 1)),
        );
        weekendRanges.add(DateUtils.datesOnly(range));
        tempDate = tempDate.add(const Duration(days: 7)); // Avança para o próximo sábado
      } else {
        tempDate = tempDate.add(const Duration(days: 1)); // Avança para o próximo dia
      }
    }

    return weekendRanges;
  }

  List<DateTimeRange> _getWeekdayRanges() {
    List<DateTimeRange> weekdayRanges = [];
    DateTime currentDate = DateTime.now();
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    DateTime tempDate = firstDayOfMonth;

    while (tempDate.isBefore(lastDayOfMonth)) {
      if (tempDate.weekday == DateTime.monday) {
        tempDate = tempDate.add(const Duration(days: 1)); // Avança para a próxima terça-feira
      } else if (tempDate.weekday >= DateTime.tuesday && tempDate.weekday <= DateTime.friday) {
        DateTimeRange range = DateTimeRange(
          start:DateUtils.dateOnly(tempDate),
          end:DateUtils.dateOnly(tempDate.add(const Duration(days: 3))),
        );
        weekdayRanges.add(DateUtils.datesOnly(range));
        tempDate = tempDate.add(const Duration(days: 7)); // Avança para o próximo sábado
      } else {
        tempDate = tempDate.add(const Duration(days: 1)); // Avança para o próximo dia
      }
    }

    return weekdayRanges;
  }


}

