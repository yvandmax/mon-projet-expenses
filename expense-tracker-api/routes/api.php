<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ExpenseController;
use App\Http\Controllers\API\IncomeController;
use App\Http\Controllers\API\CategoryController;
use App\Http\Controllers\API\BudgetController;
use App\Http\Controllers\API\BankAccountController;
use App\Http\Controllers\API\AlertController;
use App\Http\Controllers\API\DashboardController;

// Routes d'authentification
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);

// Routes protégées
Route::middleware('auth:sanctum')->group(function () {
    Route::post('logout', [AuthController::class, 'logout']);
    
    // Dépenses
    Route::apiResource('expenses', ExpenseController::class);
    
    // Revenus
    Route::apiResource('incomes', IncomeController::class);
    
    // Catégories
    Route::apiResource('categories', CategoryController::class);
    
    // Budgets
    Route::apiResource('budgets', BudgetController::class);
    Route::get('budgets/{budget}/progress', [BudgetController::class, 'getProgress']);
    
    // Comptes bancaires
    Route::apiResource('bank-accounts', BankAccountController::class);
    Route::post('bank-accounts/{account}/connect', [BankAccountController::class, 'connectToBank']);
    
    // Alertes
    Route::apiResource('alerts', AlertController::class);
    
    // Tableau de bord
    Route::get('dashboard/summary', [DashboardController::class, 'summary']);
    Route::get('dashboard/expenses-by-category', [DashboardController::class, 'expensesByCategory']);
    Route::get('dashboard/income-vs-expenses', [DashboardController::class, 'incomeVsExpenses']);
    Route::get('dashboard/budget-progress', [DashboardController::class, 'budgetProgress']);
});