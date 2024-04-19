import 'package:agendamento_clube/Pages/request_reservation_screen.dart';
import 'package:agendamento_clube/Pages/reservation_control_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de Reserva do Clube"),
        centerTitle: true,
        foregroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //RESERVAR CLUBE
                SizedBox(
                  width: 200,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RequestReservationScreen(),
                        ),
                      );
                    },
                    child: const Text('Reservar Clube'),
                  ),
                ),
                const SizedBox(height: 100,),
                //CONTROLE DA RESERVA
                SizedBox(
                  width: 200,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReservationControlScreen(),
                        ),
                      );
                    },
                    child: const Text('Controle de Reservas'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
