import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/pages/confirmation_page.dart';

class TimeSlotPage extends StatefulWidget {
  final int gender, location;

  const TimeSlotPage({Key? key, required this.gender, required this.location})
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
  DateTime selectedDay = DateTime.now();
  String _selectedSlot = '', _selectedStylist = '';

  @override
  void initState() {
    super.initState();
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  void navigateToConfirmationPage() {
    //print(person);
    //print(time);
    print(widget.gender);
    print('location ' + widget.location.toString());
    print(selectedDay.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmationPage(
            location: widget.location,
            gender: widget.gender,
            person: _selectedStylist,
            time: _selectedSlot,
            date: selectedDay)));
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
                    eventDoneColor: Colors.green,
                    selectedColor: Colors.pink,
                    todayColor: Colors.blue,
                    eventColor: Colors.grey,
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
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Slot',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                              height: textSize('text', TextStyle(fontSize: 14),
                                          context)
                                      .height +
                                  16,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: timeList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedSlot = timeList[index];
                                        });
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          side: BorderSide(
                                              color: (_selectedSlot ==
                                                      timeList.elementAt(index)
                                                  ? Colors.pink
                                                  : Colors.blueGrey.shade200),
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          /*decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(
                                                color: (_selectedSlot ==
                                                        timeList.elementAt(index)
                                                    ? Colors.pink
                                                    : Colors.blueGrey.shade200)),
                                          ),*/
                                          child: Text(
                                            timeList.elementAt(index),
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
                              height: textSize('text', TextStyle(fontSize: 14),
                                          context)
                                      .height +
                                  16,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: timeList1.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedSlot = timeList1[index];
                                        });
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          side: BorderSide(
                                              color: (_selectedSlot ==
                                                      timeList1.elementAt(index)
                                                  ? Colors.pink
                                                  : Colors.blueGrey.shade200),
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          /*decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(8)),
                                            border: Border.all(
                                                color: (_selectedSlot ==
                                                        timeList.elementAt(index)
                                                    ? Colors.pink
                                                    : Colors.blueGrey.shade200)),
                                          ),*/
                                          child: Text(
                                            timeList1.elementAt(index),
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
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: textSize('text', bold16, context).height +
                                  16 +
                                  16 +
                                  80,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: personList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedStylist = personList[index];
                                        });
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: (_selectedStylist ==
                                                      personList
                                                          .elementAt(index)
                                                  ? Colors.pink
                                                  : Colors.blueGrey.shade200),
                                              width: 3),
                                        ),
                                        child: Container(
                                          /*decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(16)),
                                            border: Border.all(
                                                color: (_selectedStylist ==
                                                        personList.elementAt(index)
                                                    ? Colors.pink
                                                    : Colors.blueGrey.shade200)),
                                          ),*/
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.account_circle,
                                                size: 80,
                                              ),
                                              Text(
                                                personList.elementAt(index),
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
                      )),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: (_selectedStylist.length != 0 && _selectedSlot.length != 0)
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
                                Colors.pink[300]), // <-- Button color
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.red; // <-- Splash color
                            }),
                          ),
                          onPressed: navigateToConfirmationPage,
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
