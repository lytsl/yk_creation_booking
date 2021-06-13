//back button
/*
Container(
margin: EdgeInsets.only(left: 16,top: 24),
child: ElevatedButton(
onPressed: () {},
child: Icon(Icons.arrow_back),
style: ButtonStyle(
shape: MaterialStateProperty.all(CircleBorder()),
padding: MaterialStateProperty.all(EdgeInsets.all(16)),
backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
if (states.contains(MaterialState.pressed)) return Colors.red; // <-- Splash color
}),
),
),
)*/

//Rounded Button
/*style: ButtonStyle(
shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18.0),
side: BorderSide(color: Colors.red)
)
)
)*/

//Square Button
/*style: ButtonStyle(
shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
borderRadius: BorderRadius.zero,
side: BorderSide(color: Colors.red)
)
)
)*/

/*MediaQuery.of(context).orientation ==
Orientation.landscape
? 8
: 4,*/

