import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot Using Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Chat bot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final messageController = TextEditingController();

  List<Map> messages = [];

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messages.insert(0, {
        "data": 0,
        "messages": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 18),
                child: Text(
                  "Today, ${DateFormat("Hm").format(DateTime.now())}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: 0,
                itemBuilder: (context, index) => chat(
                    messages[index]["message"].toString(),
                    messages[index]["data"]),
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.greenAccent,
            ),
            Container(
              child: ListTile(
                leading: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.greenAccent,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
                title: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Color.fromRGBO(220, 220, 220, 1)),
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Enter a message",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.greenAccent,
                  ),
                  onPressed: () {
                    if (messageController.text.isEmpty) {
                      print("empty message");
                    } else {
                      setState(() {
                        messages.insert(
                            0, {"data": 1, "message": messageController.text});
                      });
                      response(messageController.text);
                      messageController.clear();
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/robot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Bubble(
              radius: const Radius.circular(15),
              color: data == 0
                  ? const Color.fromRGBO(23, 157, 139, 1)
                  : Colors.orangeAccent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(
                        message,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          data == 1
              ? Container(
                  height: 60,
                  width: 60,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
