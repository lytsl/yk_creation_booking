import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yk_creation_booking/constants/colors.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/pages/service_page.dart';
import 'package:yk_creation_booking/util/gender.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int gender = Gender.male;
  bool _selectedGender = false;

  Future<void> navigateToServicePage(int index) async {
    print('navigateToServicePage');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("location", index);
    await prefs.setInt("gender", gender);
    /*Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ServicePage(
                gender: this.gender,
                location: index,
              )),
    );*/
    print(index + 1);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ServicePage(
              gender: this.gender,
                  location: index,
                )),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Select Your Option',
                    style: bold16,
                  ),
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
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            foregroundColor: (gender == Gender.male)
                                ? selectedGenderColor
                                : unSelectedGenderColor,
                            child: Icon(Icons.account_circle,
                                size: 100,
                                color: (gender == Gender.male)
                                    ? selectedGenderColor
                                    : unSelectedGenderColor),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Male',
                            style: bold16,
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
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            foregroundColor: (gender == Gender.female)
                                ? selectedGenderColor
                                : unSelectedGenderColor,
                            child: Icon(Icons.account_circle,
                                size: 100,
                                color: (gender == Gender.female)
                                    ? selectedGenderColor
                                    : unSelectedGenderColor),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Female',
                            style: bold16,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                (_selectedGender)
                    ? Column(
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
                                                      onPressed: () =>
                                                          navigateToServicePage(
                                                              index),
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
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
