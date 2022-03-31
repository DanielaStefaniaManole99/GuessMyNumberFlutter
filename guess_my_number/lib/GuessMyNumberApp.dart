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

//genereaza un numar care se schimba cand apesi pe reset sau try again - done
// nu mai afisa eroare daca nu ai introdus inca un numar
//daca numarul nu e ghicit, se afiseaza you tried ... try higher/slower, daca e ghicit, se afiseaza you guessed right - done
//buton guess -> se schimba in reset cand e ghicit - done
//cand buton e ghicit -> Alert Window -> cu 2 butoane -> Try Again! (reseteaza tot) si OK (inchide pop ul ul si window-ul ramane la fel - done

class _HomePageState extends State<HomePage> {

  final TextEditingController _myController = TextEditingController();
  String _youTried = "";
  String _youGuessed = "";
  String _itWas = "";
  String _guessButton = "Guess";
  bool _isVisible = false;
  bool _isGuessed = false;
  bool _popClosed= false;
  bool _reset = false;
  bool _tryAgain = false;

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
                            final bool valid = Form.of(context)!.validate() && (_myController.text.isNotEmpty);

                            if(valid && !_isGuessed){
                                final int value = int.parse(_myController.text);
                                print(_randomNumber);

                                setState(() {
                                  _isVisible = true;
                                  _youTried = 'You tried $value';
                                  _itWas = 'It was $value';
                                  _youGuessed = guessNumber(value);
                                });

                              }

                              if(_isGuessed && !_popClosed){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text('You guessed right'),
                                          content: Text(_itWas),
                                          actions: [
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

                                _guessButton = "Reset";
                              }

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

  guessNumber(int value){

    if(value > _randomNumber)
      return "Try lower";

    if(value < _randomNumber)
      return "Try higher";

    setState(() {
      _isGuessed = true;
    });

    return "You guessed right.";

  }

}