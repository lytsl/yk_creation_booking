import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'location_page.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LocationPage()),
    );
  }

  Widget _buildFullscrenImage(String assetName) {
    return Image.asset(
      'assets/$assetName',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          pages: [
            PageViewModel(
                title: '',
                image: _buildFullscrenImage('onboarding1.jpg'),
                body: '',
                decoration: PageDecoration(
                  bodyFlex: 0,
                  fullScreen: true,
                )),
            PageViewModel(
                title: '',
                image: _buildFullscrenImage('onboarding2.jpg'),
                body: '',
                decoration: PageDecoration(
                  bodyFlex: 0,
                  fullScreen: true,
                )),
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          skipFlex: 0,
          nextFlex: 0,
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
