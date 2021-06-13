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
  final timeList = List.generate(10, (index) => '${(index + 9) % 12 + 1}:00');
  final personList = ['Person 1', 'Person 2'];
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }

  void navigateToConfirmationPage(String person, String time) {
    print(person);
    print(time);
    print(widget.gender);
    print('location ' + widget.location.toString());
    print(selectedDay.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmationPage(
            location: widget.location,
            gender: widget.gender,
            person: person,
            time: time,
            date: selectedDay)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Calendar(
                startOnMonday: true,
                weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                events: _events,
                isExpandable: true,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: personList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(personList[index]),
                      MyGridView(
                        timeList: timeList,
                        person: personList[0],
                        onPressed: (timeIndex) => navigateToConfirmationPage(
                            personList[index], timeList[timeIndex]),
                      ),
                    ],
                  );
                },
              ),
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
