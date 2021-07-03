import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/functions.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_model.dart';
import 'package:yk_creation_booking/util/gender.dart';
import 'package:yk_creation_booking/widgets/card_with_side.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final AppointmentData appointmentData;
  final String gender;

  const AppointmentDetailsPage({Key? key, required this.appointmentData,required this.gender})
      : super(key: key);

  @override
  _AppointmentDetailsPageState createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            //color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: CardWithSide(
            color: primaryColor,
            iconColor: Colors.white,
            height: (5 *
                Fun.textHeight(14, context) +
                4 * 4 +
                8 * 7),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text('Appointment Details',
                      style: bold14),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'Booked with: ',
                        style: bold14,
                      ),
                      Text(
                        widget.appointmentData.stylist,
                        style: black14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'Date: ',
                        style: bold14,
                      ),
                      Text(
                        '${formatDate(widget.appointmentData.date, [
                          D,
                          ' ',
                          dd,
                          '/',
                          mm,
                          '/',
                          yy
                        ])} ' +
                            widget
                                .appointmentData.slot,
                        style: black14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'Bookings for: ',
                        style: bold14,
                      ),
                      Text(
                        '${(widget.gender == Gender.male) ? 'Male' : 'Female'}',
                        style: black14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(primaryColor1),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8.0),
                            ))),
                    onPressed: () {},
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
