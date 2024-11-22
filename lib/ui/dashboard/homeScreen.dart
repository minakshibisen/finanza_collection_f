import 'package:finanza_collection_f/ui/collection/collection_screen.dart';
import 'package:finanza_collection_f/ui/dashboard/profileScreen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryColor,
        systemNavigationBarIconBrightness:
            Brightness.light, // Adjust icon brightness
      ),
    );

    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        elevation: 0,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, height),
              painter: BottomNavCurvePainter(
                  backgroundColor: AppColors.primaryColor),
            ),
            Center(
              heightFactor: 0.6,
              child: FloatingActionButton(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.height)),
                  elevation: 0.1,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CollectionScreen(),
                        ));
                  },
                  tooltip: "Add Receipt",
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textOnPrimary,
                  )),
            ),
            SizedBox(
              height: height + 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavBarIcon(
                    text: "Dashboard",
                    icon: Icons.dashboard,
                    selected: _selectedIndex == 0 ? true : false,
                    onPressed: () => _onItemTapped(0),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  NavBarIcon(
                    text: "Profile",
                    icon: Icons.person,
                    selected: _selectedIndex == 1 ? true : false,
                    onPressed: () => _onItemTapped(1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter(
      {this.backgroundColor = Colors.white, this.insetRadius = 34});

  Color backgroundColor;
  double insetRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 12);

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;
    double transitionToInsetCurveWidth = size.width * .05;
    path.quadraticBezierTo(size.width * 0.20, 0,
        insetCurveBeginnningX - transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(
        insetCurveBeginnningX, 0, insetCurveBeginnningX, insetRadius / 2);

    path.arcToPoint(Offset(insetCurveEndX, insetRadius / 2),
        radius: Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(
        insetCurveEndX, 0, insetCurveEndX + transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 12);
    path.lineTo(size.width, size.height + 56);
    path.lineTo(
        0,
        size.height +
            56); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      this.selectedColor = AppColors.textOnPrimary,
      this.defaultColor = AppColors.unselectedColor});

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: selected ? selectedColor : Colors.transparent))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? selectedColor : defaultColor,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected ? AppColors.textOnPrimary : defaultColor),
            )
          ],
        ),
      ),
    );
  }
}