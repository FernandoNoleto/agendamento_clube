import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';

class ReservationControlController {

  NeatCleanCalendarEvent reservationFactory(String name, int color, DateTimeRange date){
    return NeatCleanCalendarEvent(
      name,
      description: name,
      startTime: date.start,
      endTime: date.end,
      color: Color(color),
      isAllDay: true,
    );
  }
}