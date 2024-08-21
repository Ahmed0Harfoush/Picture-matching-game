import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false; // Track if the user is logged in
  bool _isDarkMode = false;
  final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0);

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _exitGame() {
    setState(() {
      _isLoggedIn = false; // Navigate back to the login screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: _isLoggedIn ? CombinedExampleApp(
        scoreNotifier: _scoreNotifier,
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
        onExit: _exitGame,
      ) : Login(
        onLogin: _login,
        onExit: _exitGame,
      ),
    );
  }
}

class Login extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onExit;

  const Login({
    super.key,
    required this.onLogin,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Start",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: Colors.purple,
          ),
        ),
        actions: [
          Icon(
            Icons.login,
          ),
          SizedBox(width: 20),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/PNG-Page_Mobile_banner.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Text(
                    'Welcome to the card matching game',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple,
                    ),
                  ),
                ),
                // SizedBox(height: 16.0),
                // Text(
                //   'what do you want to do?',
                //   style: TextStyle(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.w300,
                //     color: Colors.indigo, // Adjust text color for better visibility
                //   ),
                // ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: onLogin,
                  child: Text(
                    'Start Game',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                      minimumSize: Size(200, 60),
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16)),
                ),
                SizedBox(height: 24.0),
                MyButton(onExit: onExit), // Add the button here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CombinedExampleApp extends StatelessWidget {
  final ValueNotifier<int> scoreNotifier;
  final void Function(bool) toggleTheme;
  final bool isDarkMode;
  final VoidCallback onExit;

  const CombinedExampleApp({
    super.key,
    required this.scoreNotifier,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: const Text(
            'Picture Matching Game',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Picture Matching',
                  style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'Score',
                  style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<Menu>(
              icon: const Icon(Icons.settings),
              onSelected: (Menu item) {
                // Handle menu selection
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                const PopupMenuItem<Menu>(
                  value: Menu.preview,
                  child: ListTile(
                    leading: Icon(Icons.visibility_outlined),
                    title: Text('Preview'),
                  ),
                ),
                const PopupMenuItem<Menu>(
                  value: Menu.share,
                  child: ListTile(
                    leading: Icon(Icons.share_outlined),
                    title: Text('Share'),
                  ),
                ),
                const PopupMenuItem<Menu>(
                  value: Menu.getLink,
                  child: ListTile(
                    leading: Icon(Icons.link_outlined),
                    title: Text('Get link'),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<Menu>(
                  value: Menu.remove,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Remove'),
                  ),
                ),
                const PopupMenuItem<Menu>(
                  value: Menu.download,
                  child: ListTile(
                    leading: Icon(Icons.download_outlined),
                    title: Text('Download'),
                  ),
                ),
              ],
            ),
            Switch(
              value: isDarkMode,
              onChanged: toggleTheme,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.grey,
              inactiveThumbColor: Colors.blue,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Images/imagespage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            children: [
              PictureMatchingPage(scoreNotifier: scoreNotifier),
              TabBarDemo(scoreNotifier: scoreNotifier),
            ],
          ),
        ),
      ),
    );
  }
}

enum Menu { preview, share, getLink, remove, download }

class PictureMatchingPage extends StatefulWidget {
  final ValueNotifier<int> scoreNotifier;

  const PictureMatchingPage({super.key, required this.scoreNotifier});

  @override
  State<PictureMatchingPage> createState() => _PictureMatchingPageState();
}

class _PictureMatchingPageState extends State<PictureMatchingPage> {
  int imageNumber1 = 1;
  int imageNumber2 = 2;
  int attempts = 0;

  void _changeImage() {
    setState(() {
      imageNumber1 = Random().nextInt(11) + 1;
      imageNumber2 = Random().nextInt(11) + 1;
      attempts++;

      if (imageNumber1 == imageNumber2) {
        widget.scoreNotifier.value++;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You scored! Total score: ${widget.scoreNotifier.value}'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          imageNumber1 == imageNumber2 ? "Congratulations you won" : "Try again",
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontStyle: FontStyle.italic,
            color: Colors.cyan,
          ),
        ),
        SizedBox(
          height: 100,
          width: 200,
          child: Divider(
            color: Colors.green,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          onPressed: () {},
                          label: 'Dismiss',
                          textColor: Colors.redAccent,
                        ),
                        content: Text("Change image $attempts"),
                      ),
                    );
                    _changeImage();
                  },
                  child: Image.asset('Images/image-$imageNumber1.png'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  onPressed: () {
                    _changeImage();
                  },
                  child: Image.asset('Images/image-$imageNumber2.png'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TabBarDemo extends StatelessWidget {
  final ValueNotifier<int> scoreNotifier;

  const TabBarDemo({super.key, required this.scoreNotifier});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<int>(
        valueListenable: scoreNotifier,
        builder: (context, score, child) {
          return Text(
            'Score: $score',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final VoidCallback onExit;

  MyButton({required this.onExit});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showExitConfirmationDialog(context);
      },
      child: Text(
        'Exit',
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(200, 60),
        backgroundColor: Colors.purple,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Are you sure you want to exit the game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onExit(); // Call the exit function
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }
}


























// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'login.dart';
// import 'package:flutter/rendering.dart';
//
// void main() => runApp(const CombinedExampleApp());
//
// class CombinedExampleApp extends StatefulWidget {
//   const CombinedExampleApp({super.key});
//
//   @override
//   _CombinedExampleAppState createState() => _CombinedExampleAppState();
// }
//
// class _CombinedExampleAppState extends State<CombinedExampleApp> {
//   bool _isDarkMode = false;
//   final ValueNotifier<int> _scoreNotifier = ValueNotifier<int>(0);
//
//   void _toggleTheme(bool isDarkMode) {
//     setState(() {
//       _isDarkMode = isDarkMode;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.deepOrangeAccent,
//             title: const Text('Picture Matching Game',
//               style: TextStyle(
//                 fontFamily: 'Georgia',
//                 fontStyle: FontStyle.italic,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(
//                   child: Text(
//                     'Picture Matching',
//                     style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Tab(
//                   child: Text(
//                     'Score',
//                     style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.bold), // Adjust the font size here
//                   ),
//                 ),
//               ],
//             ),
//             actions: <Widget>[
//               PopupMenuButton<Menu>(
//                 icon: const Icon(Icons.settings),
//                 onSelected: (Menu item) {
//                   // Handle menu selection
//                 },
//                 itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
//                   const PopupMenuItem<Menu>(
//                     value: Menu.preview,
//                     child: ListTile(
//                       leading: Icon(Icons.visibility_outlined),
//                       title: Text('Preview'),
//                     ),
//                   ),
//                   const PopupMenuItem<Menu>(
//                     value: Menu.share,
//                     child: ListTile(
//                       leading: Icon(Icons.share_outlined),
//                       title: Text('Share'),
//                     ),
//                   ),
//                   const PopupMenuItem<Menu>(
//                     value: Menu.getLink,
//                     child: ListTile(
//                       leading: Icon(Icons.link_outlined),
//                       title: Text('Get link'),
//                     ),
//                   ),
//                   const PopupMenuDivider(),
//                   const PopupMenuItem<Menu>(
//                     value: Menu.remove,
//                     child: ListTile(
//                       leading: Icon(Icons.delete_outline),
//                       title: Text('Remove'),
//                     ),
//                   ),
//                   const PopupMenuItem<Menu>(
//                     value: Menu.download,
//                     child: ListTile(
//                       leading: Icon(Icons.download_outlined),
//                       title: Text('Download'),
//                     ),
//                   ),
//                 ],
//               ),
//               Switch(
//                 value: _isDarkMode,
//                 onChanged: _toggleTheme,
//                 activeColor: Colors.green,
//                 inactiveTrackColor: Colors.grey,
//                 inactiveThumbColor: Colors.blue,
//               ),
//             ],
//           ),
//           body: TabBarView(
//             children: [
//               PictureMatchingPage(scoreNotifier: _scoreNotifier),
//               TabBarDemo(scoreNotifier: _scoreNotifier),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// enum Menu { preview, share, getLink, remove, download }
//
// class PictureMatchingPage extends StatefulWidget {
//   final ValueNotifier<int> scoreNotifier;
//
//   const PictureMatchingPage({super.key, required this.scoreNotifier});
//
//   @override
//   State<PictureMatchingPage> createState() => _PictureMatchingPageState();
// }
//
// class _PictureMatchingPageState extends State<PictureMatchingPage> {
//   int imageNumber1 = 1;
//   int imageNumber2 = 2;
//   int attempts = 0;
//
//   void _changeImage() {
//     setState(() {
//       imageNumber1 = Random().nextInt(11) + 1;
//       imageNumber2 = Random().nextInt(11) + 1;
//       attempts++;
//
//       if (imageNumber1 == imageNumber2) {
//         widget.scoreNotifier.value++;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('You scored! Total score: ${widget.scoreNotifier.value}'),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           imageNumber1 == imageNumber2 ? "Congratulations you won" : "Try again",
//           style: TextStyle(
//             fontFamily: 'Georgia',
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//             fontStyle: FontStyle.italic,
//             color: Colors.cyan,
//           ),
//         ),
//         SizedBox(
//           height: 100,
//           width: 200,
//           child: Divider(
//             color: Colors.green,
//           ),
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: TextButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         action: SnackBarAction(
//                           onPressed: () {},
//                           label: 'Dismiss',
//                           textColor: Colors.redAccent,
//                         ),
//                         content: Text("Change image $attempts"),
//                       ),
//                     );
//                     _changeImage();
//                   },
//                   child: Image.asset('images/image-$imageNumber1.png'),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: TextButton(
//                   onPressed: () {
//                     _changeImage();
//                   },
//                   child: Image.asset('images/image-$imageNumber2.png'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class TabBarDemo extends StatelessWidget {
//   final ValueNotifier<int> scoreNotifier;
//
//   const TabBarDemo({super.key, required this.scoreNotifier});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ValueListenableBuilder<int>(
//         valueListenable: scoreNotifier,
//         builder: (context, score, child) {
//           return Text(
//             'Score: $score',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 40,
//               color: Colors.green,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }