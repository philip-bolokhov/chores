import 'dart:ui';
import 'package:chores/routing_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPageView extends StatelessWidget {
  final _logoColor = Color(0xff00bfff);
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
                          ]),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image(
                        width: 160.75,
                        height: 91,
                        image: AssetImage("assets/icons/logo.png"),
                      ),
                      Spacer(),
                      ButtonTheme(
                        minWidth: 280,
                        height: 60,
                        child: RaisedButton(
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: 20),
                          ),
                          color: _googleBackgroundColor,
                          onPressed: () =>
                              Navigator.pushNamed(context, HomePageViewRoute),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          textColor: Colors.white,
                        ),
                      ),
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
}
