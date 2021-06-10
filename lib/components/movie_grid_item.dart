import 'package:flutter/material.dart';

typedef OnTap = void Function(int);

class MovieGridItem extends StatelessWidget {
  const MovieGridItem({
    Key? key,
    required this.index,
    required this.movieId,
    required this.title,
    required this.imageUrl,
    // required this.onTap
  }) : super(key: key);

  final int index;
  final int movieId;
  final String title;
  final String imageUrl;

  // final OnTap onTap;

  Widget _getOutlinedText(String text, double fontSize, Color textColor, Color outlineColor, double outlineWidth) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () {
        //   onTap(index);
        // },
        child: Stack(children: <Widget>[
      Image.network(imageUrl),
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.all(8.0), child: _getOutlinedText(title, 20, Colors.white, Colors.black, 6))),
    ]));
  }
}
