// lib/models/expense.dart
class Expense {
  final int? id;
  final int userId;
  final int categoryId;
  final double amount;
  final String? description;
  final DateTime date;
  final int? bankAccountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    this.description,
    required this.date,
    this.bankAccountId,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      amount: double.parse(json['amount'].toString()),
      description: json['description'],
      date: DateTime.parse(json['date']),
      bankAccountId: json['bank_account_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String().split('T').first,
      'bank_account_id': bankAccountId,
    };
  }
}