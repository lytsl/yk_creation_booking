import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yk_creation_booking/constants/text_styles.dart';
import 'package:yk_creation_booking/pages/time_slot_page.dart';

class ServicePage extends StatefulWidget {
  final int gender, location;

  const ServicePage({Key? key, required this.gender, required this.location})
      : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  void navigateToTimePage() {
    print(widget.location);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TimeSlotPage(
              gender: widget.gender,
              location: widget.location,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/splashscreen.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top: 176),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 140, top: 8),
                    child: Text(
                      'Location ${widget.location}',
                      style: bold16,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 60, bottom: 8),
                    child: Text(
                      'Service List',
                      style: bold16,
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
            Container(
              margin: EdgeInsets.only(top: 106, left: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  'https://via.placeholder.com/100x100',
                  height: 140.0,
                  width: 100.0,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
