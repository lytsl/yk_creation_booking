import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_data.dart';
import 'package:yk_creation_booking/pages/otp_page.dart';
import 'package:yk_creation_booking/widgets/circular_button.dart';

class ConfirmationPage extends StatefulWidget {
  final int gender, location;
  final String person, time;
  final DateTime date;

  const ConfirmationPage(
      {Key? key,
      required this.location,
      required this.gender,
      required this.person,
      required this.time,
      required this.date})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  int? selectedLocation;

  void navigateToOTPPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OTPPage(
              appointmentData: AppointmentData(
                  location: selectedLocation,
                  date: widget.date,
                  time: widget.time,
                  gender: widget.gender,
                  person: widget.person),
            )));
  }

  @override
  void initState() {
    this.selectedLocation = widget.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirmation',
          style: bold16,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: primaryColor1)),
                  leading: Icon(Icons.access_time),
                  title: Text(widget.time +
                      ' ' +
                      widget.date.day.toString() +
                      '-' +
                      widget.date.month.toString()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: primaryColor1)),
                  leading: Icon(Icons.account_circle),
                  title: Text(widget.person),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: primaryColor1)),
                  leading: Icon(Icons.location_on),
                  title: Text(
                      'Location ${(this.selectedLocation == -1) ? 'Unselected' : this.selectedLocation}'),
                ),
              ),
              AnimationLimiter(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      int loc = this.selectedLocation!;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            //location card
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.all(8.0),
                              elevation: 4,
                              child: ExpansionTile(
                                collapsedBackgroundColor:
                                    (index == this.selectedLocation)
                                        ? (primaryColor2)
                                        : primaryColor3,
                                backgroundColor:
                                    (index == this.selectedLocation)
                                        ? (primaryColor2)
                                        : primaryColor3,
                                leading: Icon(Icons.location_on),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location title $index',
                                      style: bold16,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 8),
                                      child: Text(
                                        'Location Details $index\nlocation details...$index',
                                        style: blueGrey14,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          child: Text(
                                              '    ${index == this.selectedLocation ? 'Unselect' : 'Select'}    '),
                                          onPressed: () {
                                            setState(() {
                                              if (index ==
                                                  this.selectedLocation)
                                                this.selectedLocation = -1;
                                              else
                                                this.selectedLocation = index;
                                              print(selectedLocation);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularButton(
                        text: 'Confirm',
                        backColor: primaryColor,
                        onButtonTap: () => navigateToOTPPage()),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
