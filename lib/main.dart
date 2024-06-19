import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
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
      word = nouns[Random().nextInt(2535)].toUpperCase();
  } while (word.length != 5);
  print(word);
  }

  TextStyle greenText = TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 30);
  TextStyle orangeText = TextStyle(color: const Color.fromARGB(255, 82, 82, 82), fontSize: 30);
  TextStyle greyText = TextStyle(fontSize: 30);

  String currentGuess = "";

  var inputFocusNode = FocusNode();

  bool previouslyHoldingBackspace = false;




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
            onKeyEvent: (value) {
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



                currentGuess = "";
              }
              
              
              setState(() {
                if (value.character != null && value.physicalKey != PhysicalKeyboardKey.enter) {
              currentGuess += value.character!.toUpperCase();
                }
              inputFocusNode.requestFocus();
            });
            }),



                VirtualKeyboard(
                  alwaysCaps: true,
                  type: VirtualKeyboardType.Alphanumeric,
                  height: 200,
                  onKeyPress: (value) {
                    switch (value.action) {
                      case VirtualKeyboardKeyAction.Return:
                        //run the code to submit a guess
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



                currentGuess = "";
                        break;
                      case VirtualKeyboardKeyAction.Space:
                        break;
                      case VirtualKeyboardKeyAction.Shift:
                        break;
                      default:
                      setState(() {
                        currentGuess += value.capsText;
                      });
                    }
                  },

                  )

                  ],),
        ),
      );

  }
}
