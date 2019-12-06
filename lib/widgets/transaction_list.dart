import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/widgets/transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final Function _deleteTransaction;

  TransactionList(this._transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('HH:mm dd/mm/yyyy');

    return this._transactions.isEmpty
        ? LayoutBuilder(builder: (BuildContext context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(child: Text('No transactions provided!')),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.8,
                  child: Image.asset('assets/images/waiting.png',
                      fit: BoxFit.cover),
                )
              ],
            );
          })
        : ListView(
            children: <Widget>[
              ...this._transactions.map((Transaction tx) {
                return new TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    deleteTransaction: this._deleteTransaction);
              }).toList(),
            ],
          );
  }
}
