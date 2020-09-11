import 'package:def_tab_test/setting.dart';
import 'package:flutter/material.dart';

import 'liqid_container/liquid_container.dart';

void main() {
  runApp(MaterialApp(
    home: MyPainter(),
  ));
}

class MyPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bezier'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Container(
            //     height: 30,
            //     width: double.infinity,
            //     child: LiqidContainer(
            //       boxDecorationLable: kBoxDecorationLable,
            //       optionsParam: gOptionsParam1,
            //     )),
            Container(
                height: 200,
                width: 300,
                child: LiqidContainer(
                  boxDecorationLable: boxDecoration,
                  optionsParam: gOptionsParam2,
                  child: Icon(
                    Icons.add_to_home_screen,
                    size: 50,
                    color: Color(0xFFFFA600),
                  ),
                )),
            Container(
                height: 100,
                width: 100,
                child: LiqidContainer(
                  boxDecorationLable: kBoxDecorationLable.copyWith(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  optionsParam: gOptionsParam3,
                  child: Icon(
                    Icons.play_arrow,
                    size: 70,
                  ),
                )),
            // Container(
            //     height: 50,
            //     width: 300,
            //     child: LiqidContainer(
            //       boxDecorationLable: kBoxDecorationLable.copyWith(
            //           borderRadius:
            //               BorderRadius.only(topLeft: Radius.circular(25))),
            //       optionsParam: gOptionsParam4,
            //       child: Center(child: Text('LiqidContainer')),
            //     )),
          ],
        ),
      ),
    );
  }
}

BoxDecoration kBoxDecorationLable = BoxDecoration(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(10.0),
      bottom: Radius.circular(20),
    ),
    color: Color(0x8C70504D),
    border: Border.all(
      color: Color(0xFF9E0089),
      width: 1,
    ));

BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(60)),
    color: Color(0x8C70504D),
    border: Border.all(
      color: Color(0xFF9E0089),
      width: 0.5,
    ));
