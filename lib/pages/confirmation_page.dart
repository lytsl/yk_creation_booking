import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_model.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/data/salon_location_model.dart';
import 'package:yk_creation_booking/data/salon_service_model.dart';
import 'package:yk_creation_booking/pages/appointment_details_page.dart';
import 'package:yk_creation_booking/widgets/circular_button.dart';

class ConfirmationPage extends StatefulWidget {
  final String location;
  final int locationIndex;
  final String gender;
  final String person, time;
  final DateTime date;
  final List<SalonLocation> locationList;
  final SalonService service;
  final Profile profile;

  const ConfirmationPage(
      {Key? key,
      required this.location,
      required this.gender,
      required this.person,
      required this.time,
      required this.date,
      required this.locationList,
      required this.locationIndex,
      required this.service,
      required this.profile})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late int locationIndex;

  Future<void> navigateToAppointmentDetails() async {
    if (locationIndex == -1) {
      Fluttertoast.showToast(
          msg: 'Please select a location first',
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    final data = AppointmentData();
    data.storeID = widget.locationList[locationIndex].storeID;
    data.customerID = widget.profile.customerID!;
    data.serviceID = widget.service.id;
    data.date = widget.date;
    data.slot = widget.time;
    data.stylist = widget.person;

    final code = await AppointmentModel.postData(data);

    if(code ==200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              AppointmentDetailsPage(
                  appointmentData: data, gender: widget.gender)));
    }else{
      Fluttertoast.showToast(
          msg: 'Couldn\'t book Appointment', toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  void initState() {
    this.locationIndex = widget.locationIndex;
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
        //backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: primaryColor)),
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
                    side: BorderSide(color: primaryColor)),
                leading: Icon(Icons.account_circle),
                title: Text(widget.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: primaryColor)),
                leading: Icon(Icons.location_on),
                title: Text((locationIndex == -1)
                    ? 'Unselected Location'
                    : widget.locationList[locationIndex].storeName),
              ),
            ),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: widget.locationList.length,
                    //physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

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
                                    (index == this.locationIndex)
                                        ? (Colors.blue.shade100)
                                        : Colors.white,
                                backgroundColor: (index == this.locationIndex)
                                    ? (Colors.blue.shade100)
                                    : Colors.white,
                                leading: Icon(Icons.location_on),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.locationList[index].storeName,
                                      style: bold16,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 8),
                                      child: Text(
                                        widget.locationList[index].storeAddress,
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
                                              '    ${index == this.locationIndex ? 'Unselect' : 'Select'}    '),
                                          onPressed: () {
                                            setState(() {
                                              if (index == this.locationIndex)
                                                this.locationIndex = -1;
                                              else
                                                this.locationIndex = index;
                                              print(locationIndex);
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularButton(
                  text: 'Confirm',
                  //backColor: primaryColor,
                  onButtonTap: () => navigateToAppointmentDetails()),
            ),
          ],
        ),
      ),
    );
  }
}
