import 'dart:convert';

import 'package:agendamento_clube/Controllers/request_reservation_controller.dart';
import 'package:agendamento_clube/Controllers/reservation_control_controller.dart';
import 'package:agendamento_clube/Models/reservation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class ReservationControlScreen extends StatefulWidget {
  const ReservationControlScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ReservationControlScreenState();
  }
}

class _ReservationControlScreenState extends State<ReservationControlScreen> {
  final RequestReservationController requestReservationController = RequestReservationController();
  final List<NeatCleanCalendarEvent> reservationList = [];

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    // _handleNewDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle De Reservas'),
      ),
      body: FutureBuilder(
        future: requestReservationController.retrieveReservations(),
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          else{
            try{
              reservationList.clear();
              //MAPEIA RESERVATION
              final Map<String,dynamic> myReservations = Map<String,dynamic>.from(jsonDecode(jsonEncode((snapshot.data!).snapshot.value)));
              myReservations.forEach((key, value) {
                final nextReservation = Map<String, dynamic>.from(value);
                Reservation reservation = Reservation(
                  name: nextReservation['name'],
                  // date: DateTime.parse(nextReservation['date']),
                  date: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                  color: nextReservation['color'],
                  status: nextReservation['status'],
                );
                reservationList.add(ReservationControlController().reservationFactory(reservation.name, reservation.color, reservation.date));
              });
              //RENDERIZA CALENDARIO
              return GridView.count(
                  crossAxisCount: 1,
                  children: [
                Calendar(
                  hideTodayIcon: true,
                  startOnMonday: true,
                  weekDays: const ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'],
                  eventsList: reservationList,
                  isExpandable: false,
                  eventDoneColor: Colors.deepPurple,
                  selectedColor: Colors.black38,
                  selectedTodayColor: Colors.green,
                  todayColor: Colors.teal,
                  eventColor: null,
                  locale: 'pt_BR',
                  allDayEventText: 'Dia Todo',
                  multiDayEndText: 'Multi Dias',
                  isExpanded: true,
                  expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                  onEventSelected: (value) {
                    print('Event selected ${value.summary}');
                  },
                  onEventLongPressed: (value) {
                    print('Event long pressed ${value.summary}');
                  },
                  onDateSelected: (value) {
                    print('Date selected $value');
                  },
                  onRangeSelected: (value) {
                    print('Range selected ${value.from} - ${value.to}');
                  },
                  dayOfWeekStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
                  showEvents: true,
                ),
              ]);
            }
            catch(error){
              debugPrint("$error");
              return const Text('Não há dados');
            }
          }
        },
      ),
    );
  }
}
