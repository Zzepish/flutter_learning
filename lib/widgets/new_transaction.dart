import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransaction;

  NewTransaction(this._addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  DateTime _chosenDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: this._titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              controller: this._amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => this._submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: this._chosenDate == null
                          ? Text('No date chosen!')
                          : Text(DateFormat.yMd().format(this._chosenDate))),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text('Chose date',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      this._peresentDatePicker(context);
                    },
                  )
                ],
              ),
            ),
            RaisedButton(
              child: Text("Add transaction"),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: () => this._submitData(),
            )
          ],
        ),
      ),
    );
  }

  void _submitData() {
    final String enteredTitle = this._titleController.text;
    double enteredAmount;

    try {
      this._amountController.text =
          this._amountController.text.replaceAll(',', '.');
      enteredAmount = double.parse(this._amountController.text);
    } catch (exception) {
      Fluttertoast.showToast(msg: 'Incorrect double value!');
      return;
    }

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        this._chosenDate == null) {
      return;
    }

    this.widget._addTransaction(enteredTitle, enteredAmount, this._chosenDate);

    Navigator.pop(this.context);
  }

  void _peresentDatePicker(BuildContext context) {
    Future date = showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 7)),
        lastDate: DateTime.now().add(Duration(days: 7)));

    date.then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        this._chosenDate = pickedDate;
      });
    });
  }
}
