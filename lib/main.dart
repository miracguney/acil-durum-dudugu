

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:whistle/generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acil Durum Sesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool _iconBool = true;
  final IconData _iconLight = Icons.wb_sunny;
  final IconData _iconDark = Icons.nights_stay;

  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    brightness: Brightness.light,
    cardColor: Colors.black

  );

  final ThemeData _darkTheme = ThemeData(
      primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    cardColor: Colors.black
  );


  bool isPlaying = false;
  final player = AudioPlayer();


  @override
  void initState() {
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  List<String> items = ["Siren", "Düdük", "Uyarı"];
  String? selectedItem = "Siren";
  String selected = Assets.mp3Siren;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _iconBool ? _darkTheme : _lightTheme,
      home: Scaffold(
        backgroundColor: _iconBool ? Colors.grey[900] : Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Acil Durum Sesi",style: TextStyle(fontSize: 30),),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                _iconBool=!_iconBool;
              });
            }, icon: Icon(_iconBool ? _iconLight : _iconDark))
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    buttons(210,210,100),
                    Container(
                      height: 210,
                        width: 210,
                        decoration: BoxDecoration(
                            color: isPlaying ? Colors.grey : Colors.transparent,
                            borderRadius: BorderRadius.circular(100)
                        ),),
                    GestureDetector(
                        onTap: () async{
                          if (isPlaying){
                            await player.pause();
                          } else {
                            await player.play(AssetSource(selected));//"mp3/Duduk.mp3"
                             player.setReleaseMode(ReleaseMode.loop); //devam etmesini sağlıyor
                          }
                        },
                          child: SizedBox(
                              width: 200,
                              child: Image.asset(
                                isPlaying ? Assets.imageButon2 : Assets.imageButon,
                                color: Colors.amber)),//const Color(0xff7b82fa)
                    ),

                  ],
                ),
                const SizedBox(height: 60,),
                Stack(
                  alignment: Alignment.center,
                    children: [
                      buttons(50, 170, 20),
                      SizedBox(
                        height: 50,
                        width: 125,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: _iconBool ?  Colors.grey[900] : Colors.grey[300],
                          value: selectedItem,
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,style: const TextStyle(fontSize: 20,color: Colors.amber),)
                          )).toList(),
                          onChanged: (item)=> setState(() {
                            selectedItem = item;

                            switch(selectedItem){
                              case "Siren" : selected = Assets.mp3Siren; break;
                              case "Düdük" : selected = Assets.mp3Duduk; break;
                              case "Uyarı" : selected = Assets.mp3Uyari; break;

                            }
                          }

                          ),

                        ),
                      ),
                    ],
                )
              ],
            ),
          ),
    ),
      ),
    );
  }
  Widget buttons (double height,double width,double radius) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: _iconBool ? Colors.grey[900]: Colors.grey[300],//Colors.deepPurple[300],
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: _iconBool ?  Colors.black : Colors.grey.shade600,//Colors.deepPurple.shade700,
              offset: const Offset(5,5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: _iconBool ? Colors.grey.shade800 : Colors.white,//Colors.deepPurple.shade200,
              offset: const Offset(-5,-5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _iconBool ? Colors.black26 : Colors.grey.shade200,//Colors.deepPurple.shade200,
                _iconBool ? Colors.black45 :Colors.grey.shade400//Colors.deepPurple.shade400,
              ],
              stops: const [
                0.1,
                0.9,
              ]
          )
      ),
    );
  }
}



