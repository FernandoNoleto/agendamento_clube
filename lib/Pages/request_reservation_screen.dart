
import 'package:agendamento_clube/Controllers/request_reservation_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;




class RequestReservationScreen extends StatefulWidget {
  const RequestReservationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RequestReservationScreenState();
  }
}

class _RequestReservationScreenState extends State<RequestReservationScreen> {
  RequestReservationController requestReservationController = RequestReservationController();
  late TextEditingController nameController = TextEditingController();

  late DateTimeRange dateRangeSelected;
  List<DateTimeRange> oneMonthDaysList = [];

  DateTime dateOnly(DateTime date) {
    return DateUtils.dateOnly(date);
  }
  String dateFormat(DateTime dateTime){
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  int randomColor(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0).value;
  }


  @override
  void initState() {
    oneMonthDaysList = requestReservationController.oneMonthDaysList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Reserva do Clube"),
        centerTitle: true,
        foregroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //BOTAO DROPDOWN
                FutureBuilder<List<DateTime>>(
                  future: RequestReservationController().retrieveReservationsList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    else{
                      try {
                        // List<DateTime> reservedDaysList = snapshot.data;
                        // List<DateTime> availableDaysList = [];
                        // for (var date in oneMonthDaysList) {
                        //   if (!reservedDaysList.contains(dateOnly(date))){
                        //     availableDaysList.add(dateOnly(date));
                        //   }
                        // }
                        //RETORNO DO DROPDOWN
                        return DropdownButton<DateTimeRange>(
                          value: oneMonthDaysList.first,
                          icon: const Icon(Icons.arrow_downward),
                          onChanged: (DateTimeRange? value) {
                            setState(() {
                              dateRangeSelected = value!;
                            });
                          },
                          hint: const Text('Selecione uma data disponveis'),
                          autofocus: true,
                          items: oneMonthDaysList.map<DropdownMenuItem<DateTimeRange>>((DateTimeRange date) {
                            return DropdownMenuItem<DateTimeRange>(
                              value: DateUtils.datesOnly(date),
                              child: Text(DateUtils.datesOnly(date).toString()),
                            );
                          }).toList(),
                        );
                      }
                      catch (error) {
                        debugPrint('$error');
                        return Text('$error');
                      }
                    }
                  },
                ),
                //NOME INPUTBOX
                SizedBox(
                  height: 50,
                  width: 250,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Digite seu nome',
                    ),
                  ),
                ),
                //BOTAO DE SOLICITAR RESERVA
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text != ""){
                      RequestReservationController().addNewReservation(nameController.text, dateRangeSelected, randomColor(), 0);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Solicitar Reserva!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
