import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/income_provider.dart';
import '../utils/currency_formatter.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer2<ExpenseProvider, IncomeProvider>(
              builder: (context, expenseProvider, incomeProvider, _) {
                final expenses = expenseProvider.recentExpenses;
                final incomes = incomeProvider.recentIncomes;
                
                // Combine and sort transactions by date
                final allTransactions = [
                  ...expenses.map((e) => TransactionItem(
                    date: e.date,
                    description: e.description,
                    amount: -e.amount,
                    category: e.category,
                  )),
                  ...incomes.map((i) => TransactionItem(
                    date: i.date,
                    description: i.description,
                    amount: i.amount,
                    category: i.category,
                  )),
                ]..sort((a, b) => b.date.compareTo(a.date));

                if (allTransactions.isEmpty) {
                  return Center(
                    child: Text('Aucune transaction récente'),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allTransactions.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final transaction = allTransactions[index];
                    final isExpense = transaction.amount < 0;
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isExpense ? Colors.red : Colors.green,
                        child: Icon(
                          isExpense ? Icons.remove : Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(transaction.description),
                      subtitle: Text(transaction.category),
                      trailing: Text(
                        formatCurrency(transaction.amount.abs()),
                        style: TextStyle(
                          color: isExpense ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem {
  final DateTime date;
  final String description;
  final double amount;
  final String category;

  TransactionItem({
    required this.date,
    required this.description,
    required this.amount,
    required this.category,
  });
}