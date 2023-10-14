import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skotchko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //buttonColor: Colors.blue[100],
        dividerColor: Colors.blue[100],
        canvasColor: Colors.blue[900],
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'СКОЧКО СТОЈКОВИЋИ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _animationValue = 15.0;
  List<int> _randomCombinationSymbolIndexes = <int>[];
  List<int> _randomCombinationSymbolCounter = <int>[];
  Color _animationColor = Colors.transparent;
  //Color _animationColor = Colors.red;

  late AnimationController _controller;

  List<List<int?>> chosenSymbols = <List<int?>>[];
  List<List<int>> matchSymbols = <List<int>>[];

  late int chosenSymbolIndex;
  late int matchSymbolIndex;
  late int rowIndex;

  late bool isCheckPressed;

  List<int> tempFullmatch = <int>[];
  List<int> tempHalfmatch = <int>[];

  late bool isGameFinished;

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _getRandomCombinationSymbolIndexes();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();

    print('init State');
    print(_randomCombinationSymbolCounter);
    print(tempFullmatch);
    print(tempHalfmatch);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        leading: TweenAnimationBuilder(
          duration: Duration(milliseconds: 15000),
          tween: Tween<double>(begin: 5.0, end: _animationValue),
          builder: (BuildContext context, double value, Widget? child) {
            return Container(
              margin: EdgeInsets.all(value),
              color: _animationColor,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                child: ClipOval(
                    child: Center(
                  child: Text('C',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700)),
                )),
              ),
            );
          },
          onEnd: () {
            setState(() {
              _animationValue = _animationValue == 15.0 ? 5.0 : 15.0;
              // _animationColor =
              //     _animationColor == Colors.red ? Colors.orange : Colors.red;
            });
          },
        ),
        // leading: TweenAnimationBuilder(
        //   duration: Duration(milliseconds: 15000),
        //   tween: Tween<double>(begin: 5.0, end: _animationValue),
        //   builder: (BuildContext context, double value, Widget child) {
        //     return Container(
        //       margin: EdgeInsets.all(value),
        //       color: _animationColor,
        //       child: Image.asset(
        //         'assets/sipod/6.png',
        //       ),
        //     );
        //   },
        //   onEnd: () {
        //     setState(() {
        //       _animationValue = _animationValue == 15.0 ? 5.0 : 15.0;
        //       _animationColor =
        //           _animationColor == Colors.red ? Colors.orange : Colors.red;
        //     });
        //   },
        // ),
        // leading: RotationTransition(
        //   turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        //   child: ClipOval(
        //     child: Image.asset(
        //       'assets/sipod/6.png',
        //     ),
        //   ),
        // ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 140.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _getRandomCombinationSymbolIndexes();
                              });
                            },
                            child: Text(
                              'Нова комбинација',
                              style: TextStyle(fontSize: 28.0),
                            )),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 32,
                  child: ListView.builder(
                      shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _enterCombination(index),
                              VerticalDivider(),
                              _buildCheckFields(index),
                            ],
                          ),
                        );
                      }),
                ),
                _divider(),
                _buildRandomCombination(),
                _divider(),
                // SizedBox(
                //   height: 16.0,
                // ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(children: [
                      Expanded(
                        flex: 9,
                        child: ElevatedButton(
                          onPressed: () {
                            onCheck();
                          },
                          child: Text(
                            'ПРОВЕРИ',
                            style: TextStyle(fontSize: 24.0),
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                onUndo();
                              });
                            },
                            child: Text(
                              'ОБРИШИ',
                              style: TextStyle(fontSize: 14.0),
                            )),
                      ),
                    ]),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox()),
              ]),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [..._getSymbols()],
        ),
      ),
    );
  }

  List<Widget> _getSymbols() {
    List<Widget> symbols = <Widget>[];

    for (int i = 1; i < 7; i++) {
      symbols.add(GestureDetector(
        onTap: () {
          setState(() {
            chooseSymbol(i);
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.width / 8,
          width: MediaQuery.of(context).size.width / 8,
          color: Colors.blue,
          child: _getSymbolString(i.toString()),
        ),
      ));
    }
    return symbols;
  }

  Widget _field([int? symbolIndex]) {
    return Container(
        height: MediaQuery.of(context).size.width / 10,
        width: MediaQuery.of(context).size.width / 10,
        color: Colors.blue,
        child: symbolIndex == null || symbolIndex < 1 || symbolIndex > 6
            ? null
            : _getSymbolString(symbolIndex.toString()));
  }

  Widget _checkField(int index, int i) {
    return Container(
      height: MediaQuery.of(context).size.width / 10,
      width: MediaQuery.of(context).size.width / 10,
      color: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: getCheckFieldColor(matchSymbols[index][i]),
        ),
        margin: EdgeInsets.all(1.0),
      ),
    );
  }

  Widget _buildRandomCombination() {
    return Expanded(
      flex: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < 4; i++)
            _field(isGameFinished ? _randomCombinationSymbolIndexes[i] : null),
        ],
      ),
    );
  }

  Widget _enterCombination(int index) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < 4; i++) _field(chosenSymbols[index][i] ?? null)
        ],
      ),
    );
  }

  Widget _buildCheckFields(int index) {
    // print("builded $index");
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [for (int i = 0; i < 4; i++) _checkField(index, i)],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Divider(
        height: 0,
        thickness: 2.0,
      ),
    );
  }

  Image _getSymbolString(String image) {
    return Image.asset(
      'assets/stojkovici/$image.jpg',
      fit: BoxFit.cover,
    );
  }

  void resetTemp() {
    tempFullmatch.clear();
    tempHalfmatch.clear();

    for (int i = 0; i < 6; i++) {
      tempFullmatch.add(0);
      tempHalfmatch.add(0);
    }
  }

  void resetCombinationCounter() {
    _randomCombinationSymbolCounter.clear();
    for (int i = 0; i < 6; i++) {
      _randomCombinationSymbolCounter.add(0);
    }
  }

  void _getRandomCombinationSymbolIndexes() {
    isGameFinished = false;
    chosenSymbolIndex = 0;
    matchSymbolIndex = 0;
    rowIndex = 0;

    resetCombinationCounter();

    _randomCombinationSymbolIndexes.clear();
    for (int i = 0; i < 4; i++) {
      _randomCombinationSymbolIndexes.add(Random().nextInt(6) + 1);
      for (int j = 0; j < 6; j++) {
        if (j == _randomCombinationSymbolIndexes[i] - 1) {
          _randomCombinationSymbolCounter[
              _randomCombinationSymbolIndexes[i] - 1]++;
        }
      }
    }

    chosenSymbols.clear();
    matchSymbols.clear();

    for (int i = 0; i < 6; i++) {
      chosenSymbols.add(List<int?>.filled(4, null));
      matchSymbols.add(<int>[]);

      for (int j = 0; j < 4; j++) {
        matchSymbols[i].add(3);
      }
    }
    print(matchSymbols);
    isCheckPressed = false;
    resetTemp();
  }

  void chooseSymbol(int i) {
    print(matchSymbols);
    if ((chosenSymbolIndex + 1) % 5 == 0 && isCheckPressed && !isGameFinished) {
      rowIndex++;
      chosenSymbolIndex = 0;
      matchSymbolIndex = 0;
      isCheckPressed = false;
    }
    if (rowIndex < 6) {
      if ((chosenSymbolIndex + 1) % 5 != 0) {
        chosenSymbols[rowIndex][chosenSymbolIndex] = i;

        chosenSymbolIndex++;
      }
    }
  }

  void onUndo() {
    if (chosenSymbolIndex > 0 && !isCheckPressed && !isGameFinished) {
      print(chosenSymbols);
      var last;
      last =
          chosenSymbols[rowIndex].lastIndexWhere((element) => element != null);
      chosenSymbols[rowIndex][last] = null;

      print(chosenSymbols);
      print('last $last');
      print(chosenSymbolIndex);

      chosenSymbolIndex--;

      print(chosenSymbolIndex);
    }
  }

  void onCheck() {
    print("check pressed");
    int _countHalfMatch = 0;
    if ((chosenSymbolIndex + 1) % 5 == 0) {
      int fullMatch = 0;
      int halfMatch = 0;

      for (int j = 0; j < 4; j++) {
        if (chosenSymbols[rowIndex][j] == _randomCombinationSymbolIndexes[j]) {
          matchSymbols[rowIndex][j] = 1;
          tempFullmatch[_randomCombinationSymbolIndexes[j] - 1]++;

          fullMatch++;
        } else {
          if ((_randomCombinationSymbolIndexes
              .any((element) => (element == chosenSymbols[rowIndex][j])))) {
            if (_randomCombinationSymbolIndexes
                .contains(chosenSymbols[rowIndex][j])) {
              tempHalfmatch[chosenSymbols[rowIndex][j]! - 1]++;
            }

            halfMatch++;
          }
        }
      }

      print(
          '_randomCombinationSymbolIndexes: $_randomCombinationSymbolIndexes');
      print('chosenSymbols[rowIndex]: ${chosenSymbols[rowIndex]}');

      print(
          '_randomCombinationSymbolCounter: $_randomCombinationSymbolCounter');
      print('fullMatch: $fullMatch');
      print('halfMatch: $halfMatch');

      matchSymbols[rowIndex].sort();

      for (int i = 0; i < 6; i++) {
        int localCounter = 0;
        if (_randomCombinationSymbolCounter[i] > tempFullmatch[i] &&
            tempHalfmatch[i] > 0) {
          do {
            _countHalfMatch++;
            localCounter++;
          } while (tempFullmatch[i] + localCounter <
                  _randomCombinationSymbolCounter[i] &&
              tempHalfmatch[i] > localCounter);
        }
        localCounter = 0;
      }

      for (int i = 0; i < _countHalfMatch; i++) {
        matchSymbols[rowIndex][fullMatch + i] = 2;
      }
      isCheckPressed = true;
      _countHalfMatch = 0;
      matchSymbols[rowIndex].sort();
      isGameFinished = fullMatch == 4 || rowIndex == 5;
      if (isGameFinished) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white.withOpacity(0.9),
          margin: EdgeInsets.only(bottom: 250),
          behavior: SnackBarBehavior.floating,
          content: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: Container(
              height: 150,
              width: 50,
              color: Colors.blue.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              child: Image.asset(
                                'assets/stojkovici/6.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        fullMatch == 4 ? 'Браво!' : 'Лоша срећа!',
                        style: TextStyle(color: Colors.orange, fontSize: 32),
                      ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      fullMatch == 4
                          ? 'Комбинација погођена из ${rowIndex + 1} покушаја'
                          : 'Покушај поново',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          duration: Duration(seconds: 3),
        ));
      }

      setState(() {});
      print('isGameFinished: $isGameFinished');
      print(matchSymbols);
      print(tempFullmatch);
      print(tempHalfmatch);
      resetTemp();
    }
  }

  void checkCombination() {}

  Color getCheckFieldColor(int i) {
    switch (i) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.black;
      default:
        return Colors.black;
    }
  }
}
