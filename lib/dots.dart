import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class DotsProps{
  bool isVisible = false;
  int score = 0;
}

class Dots extends StatefulWidget {
  const Dots({super.key});

  @override
  State<Dots> createState() => _Dotstate();
}

class _Dotstate extends State<Dots> {

  List<DotsProps> dots = List.generate(400, (index) => DotsProps());
  int score = 0;
  late Timer dotsTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    dotsTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      hideAllDots();
      showRandomDots();
     });
  }

  void hideAllDots() {
    setState(() {
      dots.forEach((dot) {dot.isVisible = false;});
    });
  }

  void showRandomDots() {
    Random random = Random();
    int randomIndex = random.nextInt(dots.length);
    setState(() {
      dots[randomIndex].isVisible = true;
    });
  }

  void onTapDot(int index) {
    if(dots[index].isVisible){
      setState(() {
        dots[index].isVisible = false;
        score++;
      });
    }
  }

  @override
  void dispose() {
    dotsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pin Point'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 20,
        ),
        itemCount: dots.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTapDot(index),
            child: Container(
              color: dots[index].isVisible ? Colors.white : Colors.black,
              child: Center(
                child: Text(
                  dots[index].isVisible ? 'O' : '',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Score: $score',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

//when reaches 10 points speed up by 0.1 sec, change upto 20 points
//when crosses 20 points also show 'X' and when it's pressed game over.
//when crosses 30 points make it snake game