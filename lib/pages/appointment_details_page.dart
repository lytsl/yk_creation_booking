import 'package:flutter/material.dart';
import 'package:yk_creation_booking/data/appointment_model.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final AppointmentData appointmentData;

  const AppointmentDetailsPage({Key? key, required this.appointmentData})
      : super(key: key);

  @override
  _AppointmentDetailsPageState createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
