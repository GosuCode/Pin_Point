import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class DotsProps{
  bool isVisible = false;
}

class Dots extends StatefulWidget {
  const Dots({super.key});

  @override
  State<Dots> createState() => _Dotstate();
}

class _Dotstate extends State<Dots> {

  List<DotsProps> dots = List.generate(110, (index) => DotsProps());
  int score = 0;
  late Timer dotsTimer;
  int speedUpPoints = 10;
  int initialTime = 1000;
  int misses = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    dotsTimer = Timer.periodic(Duration(milliseconds: initialTime), (timer) {
      hideAllDots();
      showRandomDots();
      if(score >= speedUpPoints) {
        speedUpPoints += 1;
        initialTime -= 20;
        if(dotsTimer.isActive){
        dotsTimer.cancel();
        startGame();
        }
      }
     });
  }

  void hideAllDots() {
      for (var dot in dots) {
        dot.isVisible = false;
      }
  }

  void showRandomDots() {
    Random random = Random();
    int randomIndex = random.nextInt(dots.length);
    print(randomIndex);
    setState(() {
      dots[randomIndex].isVisible = true;
    });
  }

  void onTapDot(int index) {
    if(dots[index].isVisible){
        dots[index].isVisible = false;
        score++;
        misses = 0;
    }else{
        misses++;
        if(misses>=2){
          gameOver();
        }
    }
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your final score is $score'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                score = 0;
                startGame();
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
    dotsTimer.cancel();
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
        backgroundColor: Colors.black,
        title: Text(
            'Score: $score',
            style: const TextStyle(fontSize: 20, color: Colors.amber),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: dots.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onTapDot(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black
                ),
                child: Center(
                  child: Text(
                    dots[index].isVisible ? '👾' : '',
                    style: const TextStyle(fontSize: 30, color: Colors.yellow),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//when crosses 20 points also show 'X' and when it's pressed game over.
//when crosses 30 points make it snake game