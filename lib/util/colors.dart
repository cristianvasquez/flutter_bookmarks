import 'dart:math';

import 'package:flutter/material.dart';

getLegibleColor(Color backgroundColor) {
  // @TODO This is computationally expensive to compute, move this to const when there is some time.
  return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

findSwatch(int data) {
  return materialColors.firstWhere((Color color) {
    return color.value == data;
  });
}

List<Color> getColorShades(ColorSwatch color) {
  return <Color>[
    if (color[50] != null) color[50],
    if (color[100] != null) color[100],
    if (color[200] != null) color[200],
    if (color[300] != null) color[300],
    if (color[400] != null) color[400],
    if (color[500] != null) color[500],
    if (color[600] != null) color[600],
    if (color[700] != null) color[700],
    if (color[800] != null) color[800],
    if (color[900] != null) color[900],
  ];
}

//const Color placeHeaderColor = Color.fromRGBO(74, 85, 96, .9);
//const Color cardColor = Color.fromRGBO(64, 75, 96, .9);
//const Color cardBackgroundColor = Color.fromRGBO(58, 66, 86, 0.7);

final _random = new Random();

Color randomColor() {
  return fullMaterialColors[_random.nextInt(fullMaterialColors.length)];
}

//List<Color> colorPalette = [
//  Color(0xff7a8388),
//  Color(0xff3c4145),
//  Color(0xff1f3038),
//  Color(0xff2a2f33),
//  Color(0xff5d4038),
//  Color(0xff605c5c),
//  Color(0xffa0887e),
//  Color(0xff607d8b),
//  Color(0xffb1b6b9),
//  Color(0xffe3b582),
//  Color(0xff543111),
//  Color(0xff362d11),
//  Color(0xffa46034),
//  Color(0xfff35f15),
//  Color(0xfffdd350),
//  Color(0xfffd9b02),
//  Color(0xfffec108),
//  Color(0xfffea15a),
//  Color(0xff8a762f),
//  Color(0xff505d29),
//  Color(0xff293313),
//  Color(0xff689e3a),
//  Color(0xffafb330),
//  Color(0xffedd836),
//  Color(0xff8bc24a),
//  Color(0xffedeb74),
//  Color(0xffb2d683),
//  Color(0xff207a87),
//  Color(0xff047366),
//  Color(0xff183534),
//  Color(0xff439f47),
//  Color(0xff4ec2c6),
//  Color(0xff019797),
//  Color(0xff01bcd5),
//  Color(0xff8abc91),
//  Color(0xff80c783),
//];

const List<ColorSwatch> materialColors = const <ColorSwatch>[
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey
];

const List<ColorSwatch> accentColors = const <ColorSwatch>[
  Colors.redAccent,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.deepPurpleAccent,
  Colors.indigoAccent,
  Colors.blueAccent,
  Colors.lightBlueAccent,
  Colors.cyanAccent,
  Colors.tealAccent,
  Colors.greenAccent,
  Colors.lightGreenAccent,
  Colors.limeAccent,
  Colors.yellowAccent,
  Colors.amberAccent,
  Colors.orangeAccent,
  Colors.deepOrangeAccent,
];

const List<ColorSwatch> fullMaterialColors = const <ColorSwatch>[
  const ColorSwatch(0xFFFFFFFF, {500: Colors.white}),
  const ColorSwatch(0xFF000000, {500: Colors.black}),
  Colors.red,
  Colors.redAccent,
  Colors.pink,
  Colors.pinkAccent,
  Colors.purple,
  Colors.purpleAccent,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.blue,
  Colors.blueAccent,
  Colors.lightBlue,
  Colors.lightBlueAccent,
  Colors.cyan,
  Colors.cyanAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.green,
  Colors.greenAccent,
  Colors.lightGreen,
  Colors.lightGreenAccent,
  Colors.lime,
  Colors.limeAccent,
  Colors.yellow,
  Colors.yellowAccent,
  Colors.amber,
  Colors.amberAccent,
  Colors.orange,
  Colors.orangeAccent,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey
];

class AppColors {
  const AppColors._();

  static const Color salmon1 = const Color(0xffFFCAC2);
  static const Color salmon2 = const Color(0xffFFAFA3);
  static const Color salmon3 = const Color(0xffFF998A);
  static const Color salmon4 = const Color(0xff66433D);
  static const Color salmon5 = const Color(0xff7F2D20);

  static const Color indigo1 = const Color(0xffCCCFFF);
  static const Color indigo2 = const Color(0xffB2B8FF);
  static const Color indigo3 = const Color(0xff99A0FF);
  static const Color indigo4 = const Color(0xff3D4066);
  static const Color indigo5 = const Color(0xff20267F);

  static const Color mint1 = const Color(0xffADFFDC);
  static const Color mint2 = const Color(0xff6ee5b2);
  static const Color mint3 = const Color(0xff2EE596);
  static const Color mint4 = const Color(0xff3D6654);
  static const Color mint5 = const Color(0xff207F56);

  static const Color arcticBlue1 = const Color(0xffB2E8FF);
  static const Color arcticBlue2 = const Color(0xff87D4F5);
  static const Color arcticBlue3 = const Color(0xff52BDEB);
  static const Color arcticBlue4 = const Color(0xff3D5A66);
  static const Color arcticBlue5 = const Color(0xff20637F);

  static const Color golden1 = const Color(0xffFFD7A3);
  static const Color golden2 = const Color(0xffFFCA85);
  static const Color golden3 = const Color(0xffFFBD66);
  static const Color golden4 = const Color(0xff66543D);
  static const Color golden5 = const Color(0xff7F5620);

  static const Color white1 = Colors.white;
  static const Color black1 = Colors.black;

  static const LinearGradient salmonGradient1 = LinearGradient(
    colors: [AppColors.white1, AppColors.salmon1],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient salmonGradient2 = LinearGradient(
    colors: [AppColors.salmon1, AppColors.salmon2],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient indigoGradient1 = LinearGradient(
    colors: [AppColors.white1, AppColors.indigo1],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient indigoGradient2 = LinearGradient(
    colors: [AppColors.indigo1, AppColors.indigo2],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient mintGradient1 = LinearGradient(
    colors: [AppColors.white1, AppColors.mint1],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient mintGradient2 = LinearGradient(
    colors: [AppColors.mint1, AppColors.mint2],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient arcticBlueGradient1 = LinearGradient(
    colors: [AppColors.white1, AppColors.arcticBlue1],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient arcticBlueGradient2 = LinearGradient(
    colors: [AppColors.arcticBlue1, AppColors.arcticBlue2],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient goldenGradient1 = LinearGradient(
    colors: [AppColors.white1, AppColors.golden1],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );

  static const LinearGradient goldenGradient2 = LinearGradient(
    colors: [AppColors.golden1, AppColors.golden2],
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
  );
}
