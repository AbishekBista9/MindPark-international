import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindgames/Domains.dart';
import 'package:mindgames/ERTInsPage.dart';
import 'package:mindgames/gaze_maze_demo_page.dart';
import 'package:mindgames/gaze_maze_page.dart';
import 'package:mindgames/jungle_jingles_demo_page.dart';
import 'package:mindgames/jungle_jingles_page.dart';
import 'package:mindgames/profile.dart';
import 'package:mindgames/simon_says_demo_page.dart';

class SocialskillsPage extends StatefulWidget {
  const SocialskillsPage({super.key});

  @override
  State<SocialskillsPage> createState() => _SocialskillsPageState();
}

class _SocialskillsPageState extends State<SocialskillsPage> {
  int index = 1;

  final screens = [
    const Profile(),
    const DomainPage(),
  ];
  final player = AudioPlayer();

  List<Map<String, dynamic>> levelTiles = [
    {
      "levelName": "Mood Magic",
      "levelImage": "ert.png",
      "levelPage": const ERTInfoScreen(shownWhen: 'before-game'),
    },
    {
      "levelName": "Simon Says",
      "levelImage": "simonsays.jpeg",
      "levelPage": const SimonSaysDemoPage(),
    },
    {
      "levelName": "Gaze Maze",
      "levelImage": "gaze-maze.jpeg",
      "levelPage": const GazeMazeDemoPage(),
    },
    {
      "levelName": "Jungle Jingles",
      "levelImage": "jungle_jingles.jpeg",
      "levelPage": const JungleJinglesDemoPage(),
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the homepage when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DomainPage()),
        );
        return false; // Prevents the default back button action
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/levelscreen.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Social Skills:'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: const Color.fromARGB(255, 51, 106, 134)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.17),
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                    mainAxisSpacing: MediaQuery.of(context).size.width * 0.04,
                    crossAxisCount: 2,
                    children: levelTiles
                        .map(
                          (item) => buildLevelTile(
                            item['levelName'].toString(),
                            item['levelImage'].toString(),
                            item['levelPage'],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  GestureDetector buildLevelTile(
      String levelName, String levelImage, Widget levelPage) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Navigate to the new page (Level 6)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => levelPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 51, 106, 134),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  24), // Match the container's border radius
              child: Center(
                child: Image.asset(
                  'assets/images/$levelImage',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.05,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    levelName.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 51, 106, 134),
                      fontSize: MediaQuery.of(context).size.width * 0.048,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}