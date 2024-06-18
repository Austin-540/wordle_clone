import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

import 'package:flutter/services.dart';

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
  @override
  void initState() {
    super.initState();
    do {
      word = nouns[Random().nextInt(2536)].toUpperCase();
  } while (word.length != 5);
  print(word);
  }

  TextStyle greenText = TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 30);
  TextStyle orangeText = TextStyle(color: const Color.fromARGB(255, 82, 82, 82), fontSize: 30);
  TextStyle greyText = TextStyle(fontSize: 30);

  String currentGuess = "";

  var inputFocusNode = FocusNode();




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
                      padding: const EdgeInsets.all(8.0),
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
            KeyboardListener(focusNode: inputFocusNode, child: Text("This is a keyboard listener"), autofocus: true, 
            onKeyEvent: (value) {

              if (value.physicalKey == PhysicalKeyboardKey.enter) {
                if (currentGuess.length !=5) {
                  return;
                }

                print(currentGuess);

                List correctness = [];
                 if (word == currentGuess.toUpperCase()) {
                      showDialog(context: context, builder: (context)=>AlertDialog(title: Text("You Win!"),));
                    } else if (guesses.length == 5) {
                      showDialog(barrierDismissible: false,context: context, builder: (context) => AlertDialog(
                        title: Text("You lost :("),
                        content: Text("The word was ${word}"),
                      ));
                    }

                    for (int x = 0; x < currentGuess.length; x ++) {
                    if (word[x] == currentGuess[x].toUpperCase()) {
                      correctness.add(greenText);
                    } else if (word.contains(currentGuess[x].toUpperCase())) {
                        correctness.add(orangeText);
                      } else {
                        correctness.add(greyText);
                      }
                  }
                  setState(() {
                    guesses.add({"string": currentGuess.toUpperCase(), "correctness": correctness });
                  });



                currentGuess = '';
              }
              
              
              setState(() {
              currentGuess += value.character!.toUpperCase();
              inputFocusNode.requestFocus();
            });
            }),
                  ],),
        ),
      );

  }
}
