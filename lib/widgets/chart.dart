
import 'package:flutter/material.dart';
import 'package:learning/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:learning/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
 
  final List<Transaction> _recentTransactions;
  
  Chart(this._recentTransactions);
  
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for(Transaction transaction in this._recentTransactions) {
        if(
          transaction.date.day == weekDay.day
          && transaction.date.weekday == weekDay.weekday
          && transaction.date.year == weekDay.year
        ) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0,1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold<double>(0.0, (double sum, Map<String, Object> item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: this.groupedTransactionValues.map((data){
                  return Flexible(
                      fit: FlexFit.tight,
                      child: ChartBar(
                          data['day'],
                          data['amount'],
                          this.maxSpending == 0.0 ? 0.0 : (data['amount'] as double) / this.maxSpending
                      )
                  );
                }).toList(),
              ),
      )
    );
  }
}