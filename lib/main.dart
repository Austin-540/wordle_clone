import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';

import 'leaderboard.dart';
final pb = PocketBase('https://belligerent-beach.pockethost.io');

void main() {
  runApp(const MaterialApp(home:MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List guesses = [];
  TextEditingController controller = TextEditingController();
  String word = "";
  DateTime? startTime;
  @override
  void initState() {
    super.initState();
    do {
      word = nouns[Random().nextInt(2535)].toUpperCase();
  } while (word.length != 5);

  startTime = DateTime.now();
  print(word);
  }

  TextStyle greenText = TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 30);
  TextStyle orangeText = TextStyle(color: const Color.fromARGB(255, 82, 82, 82), fontSize: 30);
  TextStyle greyText = TextStyle(fontSize: 30);


  String currentGuess = "";

  var inputFocusNode = FocusNode();

  bool previouslyHoldingBackspace = false;


  Map letterStatuses = {
    "A": Colors.white60,
    "B": Colors.white60,
    "C": Colors.white60,
    "D": Colors.white60,
    "E": Colors.white60,
    "F": Colors.white60,
    "G": Colors.white60,
    "H": Colors.white60,
    "I": Colors.white60,
    "J": Colors.white60,
    "K": Colors.white60,
    "L": Colors.white60,
    "M": Colors.white60,
    "N": Colors.white60,
    "O": Colors.white60,
    "P": Colors.white60,
    "Q": Colors.white60,
    "R": Colors.white60,
    "S": Colors.white60,
    "T": Colors.white60,
    "U": Colors.white60,
    "V": Colors.white60,
    "W": Colors.white60,
    "X": Colors.white60,
    "Y": Colors.white60,
    "Z": Colors.white60,
    "DELETE": Colors.white60,
    "ENTER": Colors.white60,
    "             ": Colors.white60
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Definitely Wordle"),),
        body: Center(
          child: Column(children: [
            for (var guess in guesses) ... [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i =0; i < 5; i++) ... [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      child: Container(
                        color: guess['correctness'][i] == greyText? Colors.grey: guess['correctness'][i] == orangeText? Colors.orange: Colors.green,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(child: Text(guess['string'][i], style: guess['correctness'][i],))),
                        ),
                    )
                  ]
              ],),
              SizedBox(height: 20,),
            ],
            Spacer(),
            Text(currentGuess, style: TextStyle(fontSize: 30),),
            KeyboardListener(focusNode: inputFocusNode, child: SizedBox(), autofocus: true, 
            onKeyEvent: (value) async{
              if(value.physicalKey == PhysicalKeyboardKey.space) {
                return;
              }
              if (value.physicalKey == PhysicalKeyboardKey.backspace) {
                if (!previouslyHoldingBackspace && currentGuess != "") {
                setState(() {
                currentGuess = currentGuess.substring(0, currentGuess.length-1);
                });
                previouslyHoldingBackspace = true;
                } else {
                  previouslyHoldingBackspace = false;
                }
              }
              
              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                if (currentGuess.length !=5) {
                  return;
                }

                print(currentGuess);

                List correctness = [];
                 if (word == currentGuess.toUpperCase()) {
                  var finalScore = DateTime.now().difference(startTime!).inMilliseconds/1000;

                  pb.collection('high_scores').create(body: {"time": finalScore});

                      showDialog(context: context, builder: (context)=>AlertDialog(
                        title: Text("You Win!"),
                        content: Text("Your time is: $finalScore seconds"),
                        actions: [TextButton(child: Text("See the leaderboard"),
                        onPressed: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LeaderboardPage()), (route) => false),)],));
                    } else if (guesses.length == 5) {
                      showDialog(barrierDismissible: false,context: context, builder: (context) => AlertDialog(
                        title: Text("You lost :("),
                        content: Text("The word was ${word}"),
                      ));
                    }

                    for (int x = 0; x < currentGuess.length; x ++) {
                    if (word[x] == currentGuess[x].toUpperCase()) {
                        correctness.add(greenText);
                        setState(() {
                        letterStatuses[currentGuess[x]] = Colors.green;
                        });
                      } else if (word.contains(currentGuess[x].toUpperCase())) {
                          correctness.add(orangeText);
                          setState(() {
                          letterStatuses[currentGuess[x]] = Colors.orange;
                          });
                        } else {
                          correctness.add(greyText);
                          setState(() {
                          letterStatuses[currentGuess[x]] = Colors.grey;
                          });
                        }
                  }
                  setState(() {
                    guesses.add({"string": currentGuess.toUpperCase(), "correctness": correctness });
                  });



                currentGuess = "";
              }
              
              
              setState(() {
                if (value.character != null && value.physicalKey != PhysicalKeyboardKey.enter) {
              currentGuess += value.character!.toUpperCase();
                }
              inputFocusNode.requestFocus();
            });
            }),



                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        for (var letter in ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "DELETE"]) ... [
                        GestureDetector(child: Container(
                          color: letterStatuses[letter],
                          width: 30,
                          height: 25,
                          child: Center(child: Text(letter))), onTap: () {
                            if (letter == "DELETE") {
                              //backspace code
                              if (currentGuess != "") {
                            setState(() {
                            currentGuess = currentGuess.substring(0, currentGuess.length-1);
                            });}
                            } else {

                            
                          setState(() {
                          currentGuess += letter;
                          });}
                        })
                        ]
                      ],),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        for (var letter in ["A", "S", "D", "F", "G", "H", "J", "K", "L", "ENTER"]) ... [
                        GestureDetector(child: Container(
                          color: letterStatuses[letter],
                          width: 30,
                          height: 25,
                          child: Center(child: Text(letter))), onTap: () async{
                            if (letter == "ENTER"){
                              //submit code
                              if (currentGuess.length !=5) {
                    return;
                  }
                  
                  print(currentGuess);
                  
                  List correctness = [];
                   if (word == currentGuess.toUpperCase()) {
                    var finalScore = DateTime.now().difference(startTime!).inMilliseconds/1000;

                  pb.collection('high_scores').create(body: {"time": finalScore});

                        showDialog(context: context, builder: (context)=>AlertDialog(title: Text("You Win!"),
                        actions: [TextButton(child: Text("See the leaderboard"),
                        onPressed: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LeaderboardPage()), (route) => false),)],));
                      } else if (guesses.length == 5) {
                        showDialog(barrierDismissible: false,context: context, builder: (context) => AlertDialog(
                          title: Text("You lost :("),
                          content: Text("The word was ${word}"),
                        ));
                      }
                  
                      for (int x = 0; x < currentGuess.length; x ++) {
                      if (word[x] == currentGuess[x].toUpperCase()) {
                        correctness.add(greenText);
                        setState(() {
                        letterStatuses[currentGuess[x]] = Colors.green;
                        });
                      } else if (word.contains(currentGuess[x].toUpperCase())) {
                          correctness.add(orangeText);
                          setState(() {
                          letterStatuses[currentGuess[x]] = Colors.orange;
                          });
                        } else {
                          correctness.add(greyText);
                          setState(() {
                          letterStatuses[currentGuess[x]] = Colors.grey;
                          });
                        }
                    }
                    setState(() {
                      guesses.add({"string": currentGuess.toUpperCase(), "correctness": correctness });
                    });
                  
                  
                  
                  currentGuess = "";
                              
                            } else {
                            
                          setState(() {
                          currentGuess += letter;
                          });}
                        })
                        ]
                      ],),
                    ),

                       Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          for (var letter in ["Z", "X", "C", "V", "B", "N", "M", "             "]) ... [
                          GestureDetector(child: Container(
                            color: letterStatuses[letter],
                          width: 30,
                          height: 25,
                          child: Center(child: Text(letter))), onTap: () {
                            if (letter == "             ") {
                              return;
                            }
                          setState(() {
                          currentGuess += letter;
                          });
                        })
                          ]
                        ],),
                      ),
                    

                  ]
                  )                )

                  ],),
        ),
      );

  }
}
