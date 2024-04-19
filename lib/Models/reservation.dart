import 'package:flutter/material.dart';

class Reservation {
  final String name; // Nome da pessoa que reservou
  final DateTimeRange date; // Data da reserva
  final int color; // Cor da reserva
  /// 0 - em analise
  /// 1 - confirmado
  final int status; // Status da reserva

  Reservation({
    required this.name,
    required this.date,
    required this.color,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      name: json['name'] ?? "",
      date: json['date'] ?? "",
      color: json['color'] ?? 0,
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'date': date,
    'color': color,
    'status': status,
  };

  @override
  toString(){
    return 'name: $name,' ' date: $date,' ' color: $color' ' status: ${whichStatus(status)}';
  }

  String whichStatus(status){
    if (status == 0) {
      return 'em analise';
    } else if (status == 1) {
      return 'confirmado';
    } else {
      return 'status desconhecido';
    }
  }
}