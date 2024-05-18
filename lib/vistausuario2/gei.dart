import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animated_button/simple_animated_button.dart';

class GeiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: Column(
            children: [
              section(
                context: context,
                child: ElevatedLayerButton(
                  onClick: () {},
                  buttonHeight: 60,
                  buttonWidth: 270,
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.ease,
                  topDecoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(),
                  ),
                  topLayerChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "ElevatedLayerButton()",
                        style: monoStyle,
                      ),
                    ],
                  ),
                  baseDecoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget section({required BuildContext context, required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: const EdgeInsets.only(bottom: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 0.3),
      ),
      child: child,
    );
  }

  TextStyle monoStyle = const TextStyle(
    fontSize: 18,
    fontFamily: 'Fira Mono',
    color: Color(0xff202020),
  );
}
