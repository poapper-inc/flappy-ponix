library flappy_ponix;

import 'dart:async';
import 'dart:math';

import 'package:flappy_ponix/barriers.dart';
import 'package:flappy_ponix/bird.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlappyPonix extends StatefulWidget {
  @override
  _FlappyPonixState createState() => _FlappyPonixState();
}

class _FlappyPonixState extends State<FlappyPonix> {
  int score = 0;
  int bestScore = 0;
  bool barrierOneCheck = false, barrierTwoCheck = false;
  static double birdYAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYAxis;
  bool gameHasStarted = false;
  static double barrierXOne = 2;
  double barrierXTwo = barrierXOne + 2;
  double barrierHeightOne = 200;
  double barrierHeightTwo = 150;
  Random random = new Random();
  double deviceWidthHalf;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYAxis;
    });
  }

  void restartGame() {
    setState(() {
      score = 0;
      barrierOneCheck = false;
      barrierTwoCheck = false;
      birdYAxis = 0;
      time = 0;
      height = 0;
      initialHeight = birdYAxis;
      gameHasStarted = false;
      barrierXOne = 2;
      barrierXTwo = barrierXOne + 2;
      barrierHeightOne = 200;
      barrierHeightTwo = 150;
    });
  }

  void startGame() {
    deviceWidthHalf = MediaQuery.of(context).size.width / 2;
    gameHasStarted = true;

    Timer.periodic(Duration(milliseconds: 15), (timer) {
      time += 0.0125;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYAxis = initialHeight - height;
      });

      // 첫번째 장애물 이동
      setState(() {
        if (barrierXOne < -2) {
          barrierXOne += 4;
          barrierHeightOne =  100.0 + random.nextInt(200);
          barrierOneCheck = false;
        } else {
          barrierXOne -= 0.01;
        }
      });

      // 두번째 장애물 이동
      setState(() {
        if (barrierXTwo < -2) {
          barrierXTwo += 4;
          barrierHeightTwo =  100.0 + random.nextInt(200);
          barrierTwoCheck = false;
        } else {
          barrierXTwo -= 0.01;
        }
      });

      // 첫번째 장애물 X 좌표 위치 계산
      var b1x1 = barrierXOne * deviceWidthHalf + deviceWidthHalf - 50;
      var b1x2 = barrierXOne * deviceWidthHalf + deviceWidthHalf + 50;

      // 두번째 장애물 X 좌표 위치 계산
      var b2x1 = barrierXTwo * deviceWidthHalf + deviceWidthHalf - 50;
      var b2x2 = barrierXTwo * deviceWidthHalf + deviceWidthHalf + 50;

      // 충돌 판정 - 첫번째 장애물
      if (((birdYAxis * 300 + 280) < barrierHeightOne || (birdYAxis * 300 + 320) > 200 + barrierHeightOne) && b1x1 < deviceWidthHalf + 30 && b1x2 > deviceWidthHalf - 30) {
        timer.cancel();
        gameHasStarted = false;
      }

      // 충돌 판정 - 두번째 장애물
      // print("(${birdYAxis * 300 + 280} < $barrierHeightTwo || ${birdYAxis * 300 + 320}) > ${200 + barrierHeightTwo} && $b2x1 < ${deviceWidthHalf + 30} && $b2x2 > ${deviceWidthHalf - 30}");
      if (((birdYAxis * 300 + 280) < barrierHeightTwo || (birdYAxis * 300 + 320) > 200 + barrierHeightTwo) && b2x1 < deviceWidthHalf + 30 && b2x2 > deviceWidthHalf - 30) {
        timer.cancel();
        gameHasStarted = false;
      }

      // 점수 카운트 - 첫번째 장애물
      if (!barrierOneCheck && b1x2 < deviceWidthHalf - 30) {
        barrierOneCheck = true;
        score++;
        if (bestScore < score) {
          bestScore = score;
          setBestScore();
        }
      }

      // 점수 카운트 - 두번 장애물
      if (!barrierTwoCheck && b2x2 < deviceWidthHalf - 30) {
        barrierTwoCheck = true;
        score++;
        if (bestScore < score) {
          bestScore = score;
          setBestScore();
        }
      }

      // 바닥으로 추락했을 경우
      if (birdYAxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bestScoreInit();
  }

  void bestScoreInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }

  void setBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestScore', bestScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: () {
            if (gameHasStarted) {
              jump();
            } else {
              restartGame();
              startGame();
            }
          },
          child: Column(
            children: [
              Container(
                height: 600,
                child: Stack(
                    children: [
                      AnimatedContainer(
                        alignment: Alignment(0, birdYAxis),
                        duration: Duration(milliseconds: 0),
                        color: Colors.blue,
                        child: Bird(),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXOne, -1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          size: barrierHeightOne,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXOne, 1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          size: 400.0 - barrierHeightOne,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXTwo, -1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          size: barrierHeightTwo,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierXTwo, 1),
                        duration: Duration(milliseconds: 0),
                        child: Barrier(
                          size: 400.0 - barrierHeightTwo,
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, -0.3),
                        child: gameHasStarted ? Text(" ") : Text("T A P  T O  P L A Y", style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                    ]),
              ),
              Container(
                height: 15,
                color: Colors.green,
              ),
              Expanded(
                child: Container(
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SCORE",
                            style: TextStyle(color: Colors.white, fontSize: 20),),
                          SizedBox(height: 20),
                          Text("$score",
                              style: TextStyle(color: Colors.white, fontSize: 35))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("BEST", style: TextStyle(
                              color: Colors.white, fontSize: 20)),
                          SizedBox(height: 20,),
                          Text("$bestScore",
                              style: TextStyle(color: Colors.white, fontSize: 35))
                        ],
                      )
                    ],),
                ),
              )
            ],
          ),
        )
    );
  }
}
