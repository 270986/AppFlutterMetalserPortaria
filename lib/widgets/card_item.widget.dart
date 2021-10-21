import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String title;
  final Function selecionaPonto;
  CardItem({this.title, this.selecionaPonto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selecionaPonto,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 120,
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
