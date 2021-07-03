import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/data/profile_model.dart';
import 'package:yk_creation_booking/data/salon_location_model.dart';
import 'package:yk_creation_booking/data/salon_service_model.dart';
import 'package:yk_creation_booking/pages/time_slot_page.dart';
import 'package:yk_creation_booking/util/gender.dart';

class ServicePage extends StatefulWidget {
  final String number;
  final Profile profile;

  ServicePage({Key? key, required this.number, required this.profile})
      : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String gender = Gender.male;
  int selectedLocationIndex = -1;

  bool _selectedGender = false;

  List<SalonLocation>? locationList;
  List<SalonService>? serviceList;

  late final selectedServiceList;
  int serviceCount = 0, serviceIndex = -1;

  int _pageState = 0;
  double xOffset = 0, yOffset = 0;
  double opacity = 1;
  Color color = Colors.white;

  int _locationState = 0;
  double locationYOffset = 0;
  double locationHeight = 0, serviceHeight = 0;
  double fixedLocationHeight = 0;
  String locationText = 'Select Your location';

  int _duration = 700;
  Curve _curve = Curves.ease;
  double windowHeight = 0, windowWidth = 0;

  void postPersonData() {
    if (widget.profile.name == null) return;
    Profile profile = widget.profile;
    profile.customerID = SalonLocationModel.customerID;
    profile.gender = this.gender;
    ProfileModel.postData(profile);
  }

  void getSalonLocationData() async {
    locationList = await SalonLocationModel.getLocationList(widget.number);
    setState(() {});
  }

  void getSalonServiceData(String id) async {
    serviceList = await SalonServiceModel.postData(id);
    print(serviceList!.length);
    selectedServiceList = List.filled(serviceList!.length, false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSalonLocationData();
  }

  void navigateToTimePage() {
    final List<SalonService> selectedList = [];
    /*for (int i = 0; i < selectedServiceList.length; i++) {
      if (selectedServiceList[i]) selectedList.add(serviceList![i]);
    }*/
    selectedList.add(serviceList![serviceIndex]);
    if (widget.profile.customerID == null)
      widget.profile.customerID = SalonLocationModel.customerID;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TimeSlotPage(
              gender: gender,
              location: locationList![selectedLocationIndex].storeName,
              serviceList: selectedList,
              locationList: locationList!,
              locationIndex: selectedLocationIndex,
              profile: widget.profile,
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
        serviceHeight = windowHeight - yOffset;
        break;
      case 1:
        xOffset = 0;
        yOffset = windowHeight * (0.1) + 50;
        serviceHeight = windowHeight -
            yOffset -
            textSize('text', bold16, context).height * 2 -
            16 * 4 -
            8;
        break;
    }

    locationYOffset = textSize('text', bold16, context).height +
        textSize('text', TextStyle(fontSize: 14), context).height * 2 +
        16 * 4 +
        8 +
        6 +
        2;

    if (_locationState == 0) {
      if (selectedLocationIndex == -1)
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
                          color: primaryColor,
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
                            postPersonData();
                            if (selectedLocationIndex == -1) {
                              Fluttertoast.showToast(
                                  msg: 'Please select location first',
                                  toastLength: Toast.LENGTH_LONG);
                            } else {
                              _pageState = 1;
                            }
                            setState(() {
                              gender = Gender.male;
                              _selectedGender = true;
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
                            postPersonData();
                            if (selectedLocationIndex == -1) {
                              Fluttertoast.showToast(
                                  msg: 'Please select location first',
                                  toastLength: Toast.LENGTH_LONG);
                            } else {
                              _pageState = 1;
                            }
                            setState(() {
                              gender = Gender.female;
                              _selectedGender = true;
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
                    /* SizedBox(height: 40),
                    TextButton(
                        onPressed: () {
                          AppointmentModel().postData(AppointmentData());
                        },
                        child: Text('Send Data'))*/
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
                            (selectedLocationIndex == -1)
                                ? Container()
                                : Text(
                                    locationList![selectedLocationIndex]
                                        .storeName,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (selectedLocationIndex == -1)
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
                                                locationList![
                                                        selectedLocationIndex]
                                                    .storeAddress,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              /*Text(
                                                '($selectedLocationIndex.46 KM)',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )*/
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
                      child: (locationList == null)
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    'Select Your Location',
                                    style: bold16,
                                  ),
                                ),
                                Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: locationList!.length,
                                        itemBuilder: (context, index) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration:
                                                const Duration(milliseconds: 500),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                //location card
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  margin: EdgeInsets.all(8.0),
                                                  elevation: 4,
                                                  child: ExpansionTile(
                                                    leading:
                                                        Icon(Icons.location_on),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          locationList![index]
                                                              .storeName,
                                                          style: bold16,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 0, 8, 8),
                                                          child: Text(
                                                            locationList![index]
                                                                .storeAddress,
                                                            style: blueGrey14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 16,
                                                                bottom: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                            primaryColor), // <-- Button color
                                                              ),
                                                              child: Text(
                                                                  '    Next    '),
                                                              onPressed: () {
                                                                getSalonServiceData(
                                                                    locationList![
                                                                            index]
                                                                        .storeID);
                                                                setState(() {
                                                                  selectedLocationIndex =
                                                                      index;
                                                                  _locationState =
                                                                      0;
                                                                  if (_selectedGender)
                                                                    _pageState =
                                                                        1;
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
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'Service List',
                            style: bold16,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Text(
                            /*'Total Service: $serviceCount',*/
                            '',
                            style: bold16,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: serviceHeight,
                    child: (serviceList == null)
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            //shrinkWrap: true,
                            itemCount: serviceList!.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            serviceList![index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            //textAlign: TextAlign.justify,
                                            style: bold16,
                                          ),
                                          Text(
                                            serviceList![index]
                                                    .duration
                                                    .toString() +
                                                ' Min',
                                            style: blueGrey14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        serviceList![index].price.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: SizedBox(
                                          width: 110,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                serviceIndex = index;
                                                /*selectedServiceList[index] =
                                                    !selectedServiceList[index];
                                                if (selectedServiceList[index])
                                                  serviceCount++;
                                                else
                                                  serviceCount--;*/
                                              });
                                            },
                                            child: Text(
                                              /*selectedServiceList[index]*/
                                              serviceIndex == index
                                                  ? 'Booked'
                                                  : 'Book',
                                              style: TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            style: ButtonStyle(
                                              elevation:
                                                  MaterialStateProperty.all(
                                                      selectedServiceList[index]
                                                          ? 0
                                                          : 2),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      //selectedServiceList[index]
                                                      serviceIndex == index
                                                          ? primaryColor1
                                                          : primaryColor),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 16, top: 0, bottom: 8),
                      child: ElevatedButton(
                          onPressed: navigateToTimePage,
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(4),
                            backgroundColor:
                            MaterialStateProperty.all(accentColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 8)),
                            //backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
