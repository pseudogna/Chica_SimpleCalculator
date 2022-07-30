import 'dart:io';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MyCalculator(),
    );
  }
}

class MyCalculator extends StatefulWidget {
  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

//calculator operations
class _MyCalculatorState extends State<MyCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  //function that reads the text file
  readFile() {
    //saves file content to the variable
    var content = File('texts/history.txt').readAsLinesSync();
    return content;
  }

  //function that appends the transaction to the file
  void sinkOperation(var operation) {
    var sink = File('texts/history.txt'); //for appending to the file
    sink.writeAsStringSync(' ' + operation, mode: FileMode.append);
  }

  //processes when button is pressed
  buttonPressed(String buttonText) {
    setState(() {
      //appends every button pressed into the txt file
      sinkOperation(buttonText);
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 50.0;
        sinkOperation("\n");
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
        sinkOperation(readFile().length - 1);
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 50.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        //printing of result
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          sinkOperation(result);
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  //button layout
  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                  color: Colors.white, width: 0.2, style: BorderStyle.solid)),
          padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  //button design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 60, 60, 60),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          //equation
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize, color: Colors.white),
            ),
          ),

          //result
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize, color: Colors.white),
            ),
          ),

          //row divider
          Expanded(
            child: Divider(),
          ),

          //calculator buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", 1, Color.fromARGB(255, 227, 68, 0)),
                      buildButton("⌫", 1, Color.fromARGB(255, 60, 60, 60)),
                      buildButton("÷", 1, Color.fromARGB(255, 60, 60, 60)),
                    ]),
                    TableRow(children: [
                      buildButton("7", 1, Colors.black),
                      buildButton("8", 1, Colors.black),
                      buildButton("9", 1, Colors.black),
                    ]),
                    TableRow(children: [
                      buildButton("4", 1, Colors.black),
                      buildButton("5", 1, Colors.black),
                      buildButton("6", 1, Colors.black),
                    ]),
                    TableRow(children: [
                      buildButton("1", 1, Colors.black),
                      buildButton("2", 1, Colors.black),
                      buildButton("3", 1, Colors.black),
                    ]),
                    TableRow(children: [
                      buildButton(".", 1, Colors.black),
                      buildButton("0", 1, Colors.black),
                      buildButton("00", 1, Colors.black),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("×", 1, Color.fromARGB(255, 60, 60, 60)),
                    ]),
                    TableRow(children: [
                      buildButton("-", 1, Color.fromARGB(255, 60, 60, 60)),
                    ]),
                    TableRow(children: [
                      buildButton("+", 1, Color.fromARGB(255, 60, 60, 60)),
                    ]),
                    TableRow(children: [
                      buildButton("=", 2, Color.fromARGB(255, 227, 68, 0)),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
