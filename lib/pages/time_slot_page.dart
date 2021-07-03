import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_model.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/data/salon_location_model.dart';
import 'package:yk_creation_booking/data/salon_service_model.dart';
import 'package:yk_creation_booking/pages/appointment_details_page.dart';

double textSize14 = 16, textSizeBold16 = 18;

class TimeSlotPage extends StatefulWidget {
  final String location;
  final String gender;
  final List<SalonService> serviceList;
  final List<SalonLocation> locationList;
  final int locationIndex;
  final Profile profile;

  const TimeSlotPage(
      {Key? key,
      required this.gender,
      required this.location,
      required this.serviceList,
      required this.locationList,
      required this.locationIndex,
      required this.profile})
      : super(key: key);

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): []
  };
  final timeList = List.generate(3, (index) => '${index + 8}:30');
  final timeList1 = List.generate(4, (index) => '${index + 12 + 3}:00');
  final personList = List.generate(5, (index) => 'Person ${index + 1}');
  late final List<String?> selectedSlotList, selectedStylistList;
  late final List<SalonService> serviceList;
  int slotCount = 0, stylistCount = 0;
  DateTime selectedDay = DateTime.now();
  String _selectedSlot = '', _selectedStylist = '';

  @override
  void initState() {
    super.initState();
    serviceList = widget.serviceList;
    selectedSlotList = List.filled(widget.serviceList.length, null);
    selectedStylistList = List.filled(widget.serviceList.length, null);
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  void navigateToAppointmentDetails() {
    //print(person);
    //print(time);
    print(widget.gender);
    print('location ' + widget.location.toString());
    print(selectedDay.toString());
    final List<String> stylistList = [];
    for (int i = 0; i < selectedStylistList.length; i++)
      if (selectedStylistList[i] != null)
        stylistList.add(selectedStylistList[i]!);
    final List<String> slotList = [];
    for (int i = 0; i < selectedSlotList.length; i++)
      if (selectedSlotList[i] != null) slotList.add(selectedSlotList[i]!);

    final data = AppointmentData();
    data.storeID = widget.locationList[widget.locationIndex].storeID;
    data.customerID = widget.profile.customerID!;
    data.serviceID = widget.serviceList.first.id;
    data.date = selectedDay;
    data.slot = slotList.first;
    data.stylist = stylistList.first;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AppointmentDetailsPage(appointmentData: data, gender: widget.gender)));
  }

  Size textSize(String text, TextStyle textStyle, BuildContext context) =>
      (TextPainter(
              text: TextSpan(text: text, style: textStyle),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

  @override
  Widget build(BuildContext context) {
    textSize14 = textSize('text', TextStyle(fontSize: 14), context).height;
    textSizeBold16 = textSize('text',
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold), context)
        .height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Calendar(
                    startOnMonday: true,
                    weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    events: _events,
                    isExpandable: false,
                    //eventDoneColor: Colors.green,
                    selectedColor: primaryColor1,
                    todayColor: primaryColor,
                    //eventColor: Colors.grey,
                    isExpanded: false,
                    onDateSelected: (time) {
                      selectedDay = time;
                    },
                    dayOfWeekStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 11),
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: ListView.builder(
                      itemCount: widget.serviceList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == widget.serviceList.length)
                          return Container(
                            height: 80,
                          );
                        return ServiceView(
                          serviceName: serviceList[index].name,
                          slotList: timeList,
                          timeList1: timeList1,
                          stylistList: personList,
                          slotCallBack: (slot) {
                            if (selectedSlotList[index] == null)
                              setState(() {
                                slotCount++;
                              });
                            selectedSlotList[index] = slot;
                          },
                          stylistCallBack: (stylist) {
                            if (selectedStylistList[index] == null)
                              setState(() {
                                stylistCount++;
                              });
                            selectedStylistList[index] = stylist;
                          },
                        );
                      }),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: (stylistCount == serviceList.length &&
                      slotCount == serviceList.length)
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )),
                            /*shape:
                                                  MaterialStateProperty.all(CircleBorder()),*/
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(16)),
                            backgroundColor: MaterialStateProperty.all(
                                primaryColor), // <-- Button color
                          ),
                          onPressed: navigateToAppointmentDetails,
                          child: Text(
                            'Book Appointment',
                            style: TextStyle(fontSize: 16),
                          )),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceView extends StatefulWidget {
  final String serviceName;
  final List<String> slotList, timeList1, stylistList;
  final void Function(String) slotCallBack, stylistCallBack;

  ServiceView(
      {Key? key,
      required this.serviceName,
      required this.slotList,
      required this.timeList1,
      required this.stylistList,
      required this.slotCallBack,
      required this.stylistCallBack})
      : super(key: key);

  @override
  _ServiceViewState createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  String? _selectedSlot, _selectedStylist;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 6.0),
        decoration: BoxDecoration(
          /*gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),*/
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.serviceName,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Available Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '• Morning',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: textSize14 + 16,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.slotList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSlot = widget.slotList[index];
                        });
                        widget.slotCallBack(widget.slotList[index]);
                      },
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                              color: (_selectedSlot ==
                                      widget.slotList.elementAt(index)
                                  ? primaryColor
                                  : Colors.blueGrey.shade200),
                              width: 2),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            widget.slotList.elementAt(index),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '• Afternoon',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: textSize14 + 16,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.timeList1.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSlot = widget.timeList1[index];
                        });
                        widget.slotCallBack(widget.timeList1[index]);
                      },
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                              color: (_selectedSlot ==
                                      widget.timeList1.elementAt(index)
                                  ? Colors.pink
                                  : Colors.blueGrey.shade200),
                              width: 2),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            widget.timeList1.elementAt(index),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Choose Hair Stylist',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: textSizeBold16 + 16 + 16 + 80,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.stylistList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStylist = widget.stylistList[index];
                        });
                        widget.stylistCallBack(widget.stylistList[index]);
                      },
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(
                              color:
                                  (_selectedStylist == widget.stylistList[index]
                                      ? Colors.pink
                                      : Colors.blueGrey.shade200),
                              width: 3),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 80,
                              ),
                              Text(
                                widget.stylistList.elementAt(index),
                                style: bold16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            //Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

class MyGridView extends StatelessWidget {
  const MyGridView({
    Key? key,
    required this.timeList,
    required this.person,
    required this.onPressed,
  }) : super(key: key);

  final List<String> timeList;
  final String person;
  final Function(int index) onPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: timeList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => this.onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeList.elementAt(index),
                  style: timeSlotStyle,
                ),
                Text(
                  'AM',
                  style: timeSlotStyle,
                ),
              ],
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(16)),
              backgroundColor: MaterialStateProperty.all(
                  Colors.redAccent), // <-- Button color
              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                if (states.contains(MaterialState.pressed))
                  return Colors.blue; // <-- Splash color
              }),
            ),
          );
        });
  }
}
