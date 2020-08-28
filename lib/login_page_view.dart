import 'dart:ui';
import 'package:chores/routing_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginPageView extends StatelessWidget {
  final _logoColor = Color(0xff00bfff);
  // final _logoAltColor = Color(0xff8EF0C1);
  final _googleBackgroundColor = Color(0xff4285F4);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(fit: StackFit.expand, children: [
        Image(
            fit: BoxFit.cover, image: AssetImage('assets/images/kitchen.jpg')),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox.shrink()),
                Expanded(
                  child: Center(
                    child: Text(
                      'Chores',
                      style: GoogleFonts.fugazOne(
                        color: _logoColor,
                        fontSize: 80,
                        fontWeight: FontWeight.w500,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset.zero,
                              blurRadius: 60,
                              color: _logoColor),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Image(
                          width: 160.75,
                          height: 91,
                          image: AssetImage("assets/icons/logo-bicolor.png"),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset.zero,
                              blurRadius: 40.0,
                              color: _logoColor,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      _signInButton(context),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // Draw the 'Sign in with Google' button
  Widget _signInButton(BuildContext context) {
    const double letterGSize = 28;
    const double circleSize = 54;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 280),
      child: ButtonTheme(
        minWidth: 280,
        height: 60,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: circleSize,
                  maxHeight: circleSize,
                ),
                child: Container(
                  padding: EdgeInsets.all((circleSize - letterGSize) / 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset("assets/icons/google-logo.png"),
                ),
              ),
              SizedBox(width: 18),
              Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          color: _googleBackgroundColor,
          onPressed: () => Navigator.pushNamed(context, HomePageViewRoute),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          textColor: Colors.white,
        ),
      ),
    );
  }
}
