import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const NumberShapesApp());
}

class NumberShapesApp extends StatelessWidget {
  const NumberShapesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _myController = TextEditingController();
  String _youTried = "";
  String _youGuessed = "";
  String _itWas = "";
  String _guessButton = "Guess";
  bool _isVisible = false;
  bool _isGuessed = false;
  bool _popClosed= false;

  //initializam numarul, punem +1 ca sa avem in range-ul 1-100
  int _randomNumber = Random().nextInt(100) + 1;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Guess my number'),
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
        ),

        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                  "I'm thinking of a number between 1 and 100.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                  )
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                  "It's your turn to guess my number!",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
              ),
            ),

            Visibility(
              child: Text(
                _youTried,

                style: const TextStyle(color: Colors.black54, fontSize: 32),
              ),
              visible: _isVisible,
              maintainSize: false,
            ),

            Visibility(
              child: Text(
                _youGuessed,

                style: const TextStyle(color: Colors.black54, fontSize: 32),
              ),
              visible: _isVisible,
              maintainSize: false,
            ),

            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(16),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text("Try a number!",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 32,
                        )
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _myController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      validator: (String? value) {

                        if (value != null || value!.isEmpty) {
                          final int? result = int.tryParse(value);

                          if ( result !=null && (result < 1 || result > 100)) {
                            return "please enter a number between 1 and 100";
                          }
                        }
                      },
                    )
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Builder(
                      builder: (BuildContext context) {
                        return ElevatedButton(
                          onPressed: () {
                            //am adaugat isNotEmpty pentru a verifica daca String-ul nu este null (valid este true si pentru stringuri nule ca sa nu ne apara textul pentru eroare
                            final bool valid = Form.of(context)!.validate() && (_myController.text.isNotEmpty);

                            //daca numarul introdus este valid dar inca nu este ghicit
                            if(valid && !_isGuessed){
                                final int value = int.parse(_myController.text);
                                _myController.text = "";

                                setState(() {
                                  _isVisible = true;
                                  _youTried = 'You tried $value';
                                  _itWas = 'It was $value';
                                  _youGuessed = guessNumber(value);
                                });

                              }

                            //daca numarul a fost ghicit, se deschide AlertDialog-ul si butonul de Guess devine butonul de Reset
                              if(_isGuessed && !_popClosed){
                                _guessButton = "Reset";

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text('You guessed right'),
                                          content: Text(_itWas),
                                          actions: [
                                            //daca apasam pe Try Again, se inchide fereastra si revenim la setarile initiale
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                _randomNumber = Random().nextInt(100) + 1;
                                                _isVisible = false;
                                                _isGuessed = false;
                                                _myController.value = TextEditingValue.empty;
                                                _guessButton = "Guess";
                                                _popClosed = false;
                                                });
                                              },
                                              child: const Text('Try again!',
                                                style: TextStyle(
                                                color: Colors.blue,
                                                ),
                                              ),
                                            ),

                                            //daca apasam pe OK, doar inchidem fereastra
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _popClosed = true; // dismiss dialog
                                                });
                                              },
                                              child: const Text('OK',
                                                style: TextStyle(
                                                color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                );
                              }

                            // apasam pe Reset dupa ce numarul a fost ghicit si fereastra a fost inchisa si revenim la instructiunile initiale
                            if(_isGuessed && _popClosed){
                              setState(() {
                                _randomNumber = Random().nextInt(100) + 1;
                                _isVisible = false;
                                _isGuessed = false;
                                _myController.value = TextEditingValue.empty;
                                _guessButton = "Guess";
                                _popClosed = false;
                              });
                            }
                          },

                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                          ),

                          child: Text(_guessButton,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              )
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //functie pentru a vedea daca utilizatorul a ghicit numarul sau ii oferim hint-uri
  guessNumber(int value){

    if(value > _randomNumber)
      return "Try lower";

    if(value < _randomNumber)
      return "Try higher";

    //daca nu e numarul nici mai mic, nici mai mare, este ghicit
    setState(() {
      _isGuessed = true;
    });

    return "You guessed right.";

  }
}