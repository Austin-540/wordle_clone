import 'package:flutter/material.dart';
import 'package:wordle_clone/main.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  Future? getLeaderboardData;

  @override
  void initState() {
    super.initState();
    getLeaderboardData = pb.collection('high_scores').getList(
  page: 1,
  perPage: 20,
  sort: "+time"
);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard"), leading: IconButton(icon: Icon(Icons.arrow_back,), onPressed: () =>
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainApp()), (route)=>false),),
    ),
    
    
    body: ListView(children: [
      FutureBuilder(
        future: getLeaderboardData, builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return Column(children: [
              for (int i = 0; i < snapshot.data.items.length; i++) ... [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${i+1}    ${snapshot.data.items[i].data['time']}"),
                    ),
                  ),
                )
              ]
            ],);
          }
        }
        )
    ],),);
  }
}