import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required Transaction transaction,
    @required Function deleteTransaction,
  }) : _transaction = transaction,
        _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction _transaction;
  final Function _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
                child: Text('\$${this._transaction.amount}',
                    style: Theme.of(context).textTheme.title)),
          ),
        ),
        title: Text('${this._transaction.title}'),
        subtitle: Text(DateFormat.yMMMMd().format(this._transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
            onPressed: () {
              this._deleteTransaction(this._transaction.id);
            },
            textColor: Colors.red,
            icon: Icon(Icons.delete),
            label: Text('Delete'))
            : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () {
            this._deleteTransaction(this._transaction.id);
          },
        ),
      ),
    );
  }
}
