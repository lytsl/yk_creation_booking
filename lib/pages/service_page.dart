import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/appointment_model.dart';
import 'package:yk_creation_booking/pages/time_slot_page.dart';
import 'package:yk_creation_booking/util/gender.dart';

class ServicePage extends StatefulWidget {
  final String number;

  ServicePage({Key? key, required this.number}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  int gender = Gender.male;
  int location = -1;

  bool _selectedGender = false;

  int _pageState = 0;
  double xOffset = 0, yOffset = 0;
  double opacity = 1;
  Color color = Colors.white;

  int _locationState = 0;
  double locationYOffset = 0;
  double locationHeight = 0;
  double fixedLocationHeight = 0;
  String locationText = 'Select Your location';

  int _duration = 700;
  Curve _curve = Curves.ease;
  double windowHeight = 0, windowWidth = 0;

  void navigateToTimePage() {
    //print(widget.location);
    //final data = AppointmentModel();
    //data.gender = gender.toString();
    //data.storeID = location.toString();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TimeSlotPage(
              gender: gender,
              location: location,
            )));
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
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch (_pageState) {
      case 0:
        xOffset = 0;
        yOffset = windowHeight;
        //color = Colors.white;
        //opacity = 1;
        break;
      case 1:
        xOffset = 0;
        yOffset = windowHeight * (0.1) + 50;
        //opacity = 0.7;
        //color = Colors.blueGrey.shade200;
        break;
    }

    locationYOffset = textSize('text', bold16, context).height +
        textSize('text', TextStyle(fontSize: 14), context).height * 2 +
        16 * 4 +
        8 +
        6 +
        2;

    if (_locationState == 0) {
      if (location == -1)
        locationHeight =
            textSize('text', TextStyle(fontSize: 14), context).height + 16 + 8;
      else
        locationHeight = textSize(
                        'text',
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        context)
                    .height *
                3 +
            16 +
            8;
      //if (_pageState != 1) color = Colors.white;
    } else {
      locationHeight = windowHeight - locationYOffset - 24;
      //color = Colors.blueGrey.shade200;
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              curve: _curve,
              duration: Duration(
                milliseconds: _duration,
              ),
              decoration: BoxDecoration(
                color: color,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_pageState != 0) {
                    setState(() {
                      _pageState = 0;
                    });
                  }
                  if (_locationState != 0) {
                    setState(() {
                      _locationState = 0;
                    });
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Salon',
                          style: bold16,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 6,
                          width: 30,
                          color: Colors.red,
                        )),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 16),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.location_on),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(24, 6, 0, 0),
                              child: Text(
                                'Switch on your device location to improve your digital experience.',
                                style: TextStyle(fontSize: 14),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: (_locationState == 0)
                          ? locationHeight + 32 * 2
                          : 32 * 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Select Your Gender',
                        style: bold16,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //male
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.male;
                              _selectedGender = true;
                              _pageState = 1;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/male.png'),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Male',
                                style: bold16,
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 6,
                                width: 30,
                                color: (gender == Gender.male)
                                    ? selectedGenderColor
                                    : unSelectedGenderColor,
                              ),
                            ],
                          ),
                        ),
                        //female
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = Gender.female;
                              _selectedGender = true;
                              _pageState = 1;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/female.png'),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Female',
                                style: bold16,
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 6,
                                width: 30,
                                color: (gender == Gender.female)
                                    ? selectedGenderColor
                                    : unSelectedGenderColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    TextButton(
                        onPressed: () {
                          AppointmentModel().postData(AppointmentData());
                        },
                        child: Text('Send Data'))
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              height: locationHeight,
              //width: (_locationState == 0) ? null : windowWidth,
              curve: _curve,
              duration: Duration(
                milliseconds: _duration,
              ),
              transform: Matrix4.translationValues(0, locationYOffset, 1),
              margin: EdgeInsets.symmetric(
                  horizontal: (_locationState == 0) ? 16 : 0),
              decoration: BoxDecoration(
                border: (_locationState == 0)
                    ? Border.all(color: Colors.grey)
                    : Border.fromBorderSide(BorderSide.none),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: (_locationState == 0)
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        print('location pressed');
                        if (_locationState != 1)
                          setState(() {
                            _locationState = 1;
                          });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (location == -1)
                                ? Container()
                                : Text(
                                    'Location $location',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (location == -1)
                                    ? Text('Select your location')
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nearest Hub:',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Location $location Details',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '($location.46 KM)',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: locationHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Select Your Location',
                              style: bold16,
                            ),
                          ),
                          AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 3,
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
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          margin: EdgeInsets.all(8.0),
                                          elevation: 4,
                                          child: ExpansionTile(
                                            leading: Icon(Icons.location_on),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Location title $index',
                                                  style: bold16,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 8, 8),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      child:
                                                          Text('    Next    '),
                                                      onPressed: () {
                                                        setState(() {
                                                          location = index;
                                                          _locationState = 0;
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
                        ],
                      ),
                    ),
            ),
            AnimatedContainer(
              curve: _curve,
              duration: Duration(
                milliseconds: _duration,
              ),
              //color: Colors.white,
              transform: Matrix4.translationValues(xOffset, yOffset, 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Text(
                        'Service List',
                        style: bold16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hair Style $index',
                                      style: bold16,
                                    ),
                                    Text(
                                      '30 Min',
                                      style: blueGrey14,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '500',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ElevatedButton(
                                      onPressed: () => navigateToTimePage(),
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            //side: BorderSide(color: Colors.red),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 16)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepOrange),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
