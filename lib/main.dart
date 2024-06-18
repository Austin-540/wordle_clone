import 'package:flutter/material.dart';

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
  String word = "LINUX";

  TextStyle greenText = TextStyle(color: Colors.green);
  TextStyle orangeText = TextStyle(color: Colors.orange);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Definitely Wordle"),),
        body: Center(
          child: Column(children: [
            for (var guess in guesses) ... [
              Row(children: [
                  for (int i =0; i < 5; i++) ... [
                    Text(guess['string'][i], style: guess['correctness'][i],)
                  ]
              ],),
              SizedBox(height: 20,)
            ],
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(label: Text("Guess here")),
                onSubmitted: (value) { 
                  
                  print(value);
                  if (value.length != 5) {
                    return;
                  }
                  List correctness = [];
                    if (word == value.toUpperCase()) {
                      showDialog(context: context, builder: (context)=>AlertDialog(title: Text("You Win!"),));
                    } else if (guesses.length == 5) {
                      showDialog(barrierDismissible: false,context: context, builder: (context) => AlertDialog(
                        title: Text("You lost :("),
                        content: Text("The word was ${word}"),
                      ));
                    }
                  for (int x = 0; x < value.length; x ++) {
                    if (word[x] == value[x].toUpperCase()) {
                      correctness.add(greenText);
                    } else if (word.contains(value[x].toUpperCase())) {
                        correctness.add(orangeText);
                      } else {
                        correctness.add(null);
                      }
                  }
                  setState(() {
                    guesses.add({"string": value.toUpperCase(), "correctness": correctness });
                  });
                controller.clear();
                
                },
              ),
            )
            
          ],),
        ),
      );

  }
}