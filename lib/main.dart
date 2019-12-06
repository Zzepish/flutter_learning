import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/models/transaction.dart';
import 'package:learning/widgets/chart.dart';
import 'package:learning/widgets/new_transaction.dart';
import 'package:learning/widgets/transaction_list.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      title: 'Personal expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans', fontSize: 18),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(fontFamily: 'OpenSans', fontSize: 20))),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
        title: 'SOme title',
        id: 'qwrs123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwras123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwrf123',
        date: DateTime.now().subtract(Duration(days: 2)),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwfasr123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwafsr123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qw12r123',
        date: DateTime.now().subtract(Duration(days: 3)),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwr53123',
        date: DateTime.now().subtract(Duration(days: 2)),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwr1353523',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qw5523r123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qw32r123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title',
        id: 'qwr23t123',
        date: DateTime.now(),
        amount: 13.15),
    Transaction(
        title: 'SOme title!',
        id: 'qwt32r123!',
        date: DateTime.now(),
        amount: 13.15)
  ];
  bool _showChart = false;

  final String currency = '\$';

  void _add(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());
    this.setState(() {
      this._transactions.insert(0, newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builderContext) {
          return GestureDetector(
            child: NewTransaction(this._add),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String transaction_id) {
    setState(() {
      this._transactions.removeWhere((Transaction transaction) {
        return transaction.id == transaction_id;
      });
    });
  }

  List<Transaction> _recentTransactions() {
    return this._transactions.where((Transaction transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void deleteAllTransactions() {
    this.setState(() {
      this._transactions.clear();
    });
  }

  CupertinoPageScaffold _buildCupertinoApp(
      BuildContext context, bool isLandscape, MediaQueryData mediaQuery) {
    final navigationBar = CupertinoNavigationBar(
      middle: const Text('Hello!'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => this._startAddNewTransaction(context),
          )
        ],
      ),
    );

    return CupertinoPageScaffold(
      navigationBar: navigationBar,
      child: SafeArea(
        child: this._buildBaseColumnWidget(
            isLandscape,
            this._buildTransactionsListWidget(
                mediaQuery, navigationBar.preferredSize),
            navigationBar.preferredSize,
            mediaQuery),
      )
    );
  }

  Scaffold _buildMaterialApp(
      BuildContext context, bool isLandscape, MediaQueryData mediaQuery) {
    AppBar appBar = AppBar(
      title: Text('Personal expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => this._startAddNewTransaction(context),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => this.deleteAllTransactions(),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: this._buildBaseColumnWidget(
              isLandscape,
              this._buildTransactionsListWidget(
                  mediaQuery, appBar.preferredSize),
              appBar.preferredSize,
              mediaQuery)),
    );
  }

  Widget _buildBaseColumnWidget(bool isLandscape, Container txListWidget,
      Size preferredSize, MediaQueryData mediaQuery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isLandscape)
          ...this
              ._buildLandscapeContent(mediaQuery, preferredSize, txListWidget),
        if (!isLandscape)
          ...this
              ._buildPortraitContent(mediaQuery, preferredSize, txListWidget),
      ],
    );
  }

  Widget _buildTransactionsListWidget(
      MediaQueryData mediaQuery, Size preferredSize) {
    return Container(
      height: (mediaQuery.size.height -
              preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: TransactionList(this._transactions, this._deleteTransaction),
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, Size barSize, Container txListWidget) {
    return [
      Row(children: [
        Text('Show chart'),
        Switch(
          value: _showChart,
          onChanged: (value) {
            this.setState(() {
              this._showChart = value;
            });
          },
        ),
      ]),
      this._showChart
          ? Container(
              height: (mediaQuery.size.height -
                      barSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(this._recentTransactions()),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, Size preferredSize, Container txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(this._recentTransactions()),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Platform.isIOS
        ? this._buildCupertinoApp(context, isLandscape, mediaQuery)
        : this._buildMaterialApp(context, isLandscape, mediaQuery);
  }
}
