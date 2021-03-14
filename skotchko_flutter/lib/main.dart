import 'package:flutter/material.dart';

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
        buttonColor: Colors.blue[100],
        dividerColor: Colors.blue[100],
        canvasColor: Colors.blue[900],
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Skotchko'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 150.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RaisedButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'New Combination',
                                style: TextStyle(fontSize: 28.0),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFields(),
                            VerticalDivider(),
                            _buildCheckFields(),
                          ],
                        ),
                      );
                    }),
                _divider(),
                _buildFields(),
                _divider(),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(
                      flex: 4,
                      child: RaisedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'CHECK',
                              style: TextStyle(fontSize: 28.0),
                            ),
                          )),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: RaisedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'UNDO',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          )),
                    ),
                  ]),
                ),
                Expanded(child: SizedBox()),
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
    List<Widget> symbols = List<Widget>();

    for (int i = 1; i < 7; i++) {
      symbols.add(GestureDetector(
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

  Widget _field() {
    return Container(
      height: MediaQuery.of(context).size.width / 10,
      width: MediaQuery.of(context).size.width / 10,
      color: Colors.blue,
    );
  }

  Widget _checkField() {
    return Container(
      height: MediaQuery.of(context).size.width / 10,
      width: MediaQuery.of(context).size.width / 10,
      color: Colors.blue,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.black,
        ),
        margin: EdgeInsets.all(1.0),
      ),
    );
  }

  Widget _buildFields() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _field(),
          _field(),
          _field(),
          _field(),
        ],
      ),
    );
  }

  Widget _buildCheckFields() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _checkField(),
          _checkField(),
          _checkField(),
          _checkField(),
        ],
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
      'assets/images/$image.png',
      fit: BoxFit.contain,
    );
  }
}
