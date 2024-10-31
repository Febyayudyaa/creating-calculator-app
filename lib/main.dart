import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _equation = "0";
  String _result = "0";

  void _onPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case "AC":
          _equation = "0";
          _result = "0";
          break;
        case "=":
          _result = _calculate();
          break;
        case "⌫":
          _equation = _equation.length > 1 ? _equation.substring(0, _equation.length - 1) : "0";
          break;
        default:
          _equation = _equation == "0" ? buttonText : _equation + buttonText;
      }
    });
  }

  String _calculate() {
    try {
      final parser = Parser();
      final expression = parser.parse(_equation);
      final contextModel = ContextModel();
      return expression.evaluate(EvaluationType.REAL, contextModel).toString();
    } catch (_) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator"), backgroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildDisplay(_equation, 40, Colors.black54),
            _buildDisplay(_result, 64, Colors.white),
            const SizedBox(height: 20),
            _buildButtonRow(
              ["AC", "+/-", "%", "/"],
              [Colors.grey, Colors.grey, Colors.grey, Colors.orange],
              [70, 70, 70, 70],
            ),
            _buildButtonRow(
              ["7", "8", "9", "*"],
              [Colors.grey[800]!, Colors.grey[800]!, Colors.grey[800]!, Colors.orange],
              [70, 70, 70, 70],
            ),
            _buildButtonRow(
              ["4", "5", "6", "-"],
              [Colors.grey[800]!, Colors.grey[800]!, Colors.grey[800]!, Colors.orange],
              [70, 70, 70, 70],
            ),
            _buildButtonRow(
              ["1", "2", "3", "+"],
              [Colors.grey[800]!, Colors.grey[800]!, Colors.grey[800]!, Colors.orange],
              [70, 70, 70, 70],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: CircularCalculatorButton("0", _onPressed, Colors.grey[800]!, width: 195, height: 70),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: CircularCalculatorButton(".", _onPressed, Colors.grey[800]!, width: 70, height: 70),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: CircularCalculatorButton("=", _onPressed, Colors.orange, width: 70, height: 70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(String text, double fontSize, Color color) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(text, style: TextStyle(fontSize: fontSize, color: color), overflow: TextOverflow.ellipsis),
    );
  }

  Row _buildButtonRow(List<String> buttonTexts, List<Color> colors, List<double> sizes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonTexts.asMap().entries.map((entry) {
        int index = entry.key;
        String text = entry.value;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
            child: CircularCalculatorButton(
              text,
              _onPressed,
              colors[index],
              width: sizes[index],
              height: 70,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CircularCalculatorButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final Color color;
  final double width;
  final double height;

  const CircularCalculatorButton(
    this.buttonText,
    this.onPressed,
    this.color, {
    this.width = 70,
    this.height = 70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(buttonText),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: color,
        ),
        child: Center(
          child: Text(buttonText, style: const TextStyle(fontSize: 28, color: Colors.white)),
        ),
      ),
    );
  }
}
