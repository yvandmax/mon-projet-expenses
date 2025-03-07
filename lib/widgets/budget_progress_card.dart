import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';
import '../utils/currency_formatter.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<BudgetProvider, ExpenseProvider>(
      builder: (context, budgetProvider, expenseProvider, _) {
        final budgets = budgetProvider.budgets;
        
        return Column(
          children: budgets.map((budget) {
            final spent = expenseProvider.getExpensesByCategory(budget.category);
            final progress = spent / budget.amount;
            final isOverBudget = progress > 1;
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          budget.category,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${formatCurrency(spent)} / ${formatCurrency(budget.amount)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        isOverBudget ? Colors.red : Colors.green,
                      ),
                    ),
                    if (isOverBudget) ...[
                      SizedBox(height: 4.0),
                      Text(
                        'Budget dépassé !',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
} 