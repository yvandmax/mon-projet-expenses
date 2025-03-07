// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/income_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../widgets/chart_widgets.dart';
import '../../../utils/currency_formatter.dart';
import '../../../widgets/expense_summary_card.dart';
import '../../../widgets/income_summary_card.dart';
import '../../../widgets/budget_progress_card.dart';
import '../../../widgets/recent_transactions_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Chargement des données via les providers
      await Future.wait([
        Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses(),
        Provider.of<IncomeProvider>(context, listen: false).fetchIncomes(),
        Provider.of<BudgetProvider>(context, listen: false).fetchBudgets(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement des données: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Résumé des finances
                    _buildFinancialSummary(),

                    SizedBox(height: 24.0),

                    // Graphique revenus vs dépenses
                    _buildIncomeVsExpensesChart(),

                    SizedBox(height: 24.0),

                    // Progression du budget
                    Text(
                      'Progression du budget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0),
                    BudgetProgressCard(),

                    SizedBox(height: 24.0),

                    // Dépenses par catégorie
                    Text(
                      'Dépenses par catégorie',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0),
                    _buildExpensesByCategoryChart(),

                    SizedBox(height: 24.0),

                    // Transactions récentes
                    Text(
                      'Transactions récentes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8.0),
                    RecentTransactionsList(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddTransactionDialog(context),
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Row(
      children: [
        Expanded(
          child: ExpenseSummaryCard(),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: IncomeSummaryCard(),
        ),
      ],
    );
  }

  Widget _buildIncomeVsExpensesChart() {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final incomeProvider = Provider.of<IncomeProvider>(context);

    final totalExpenses = expenseProvider.totalExpenses;
    final totalIncomes = incomeProvider.totalIncomes;

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenus vs Dépenses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 200.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalIncomes > totalExpenses
                      ? totalIncomes * 1.2
                      : totalExpenses * 1.2,
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        if (value == 0) return 'Revenus';
                        if (value == 1) return 'Dépenses';
                        return '';
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          y: totalIncomes,
                          colors: [Colors.green],
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          y: totalExpenses,
                          colors: [Colors.red],
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                    'Revenus', Colors.green, formatCurrency(totalIncomes)),
                _buildLegendItem(
                    'Dépenses', Colors.red, formatCurrency(totalExpenses)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesByCategoryChart() {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expensesByCategory = expenseProvider.expensesByCategory;

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          height: 300.0,
          child: expensesByCategory.isEmpty
              ? Center(child: Text('Aucune donnée disponible'))
              : PieChart(
                  PieChartData(
                    sections: expensesByCategory.entries.map((entry) {
                      final color = Colors.primaries[
                          entry.key.hashCode % Colors.primaries.length];
                      return PieChartSectionData(
                        color: color,
                        value: entry.value,
                        title: '${formatCurrency(entry.value)}',
                        radius: 100.0,
                        titleStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2.0,
                    centerSpaceRadius: 40.0,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color, String value) {
    return Row(
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          color: color,
        ),
        SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter une transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/expenses/add');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Ajouter une dépense'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/incomes/add');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Ajouter un revenu'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }
}
