<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\InventoryController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

// Route Cetak PDF
Route::get('/inventory/cetak-pdf', [InventoryController::class, 'cetakPdf'])
    ->name('inventory.cetakPdf');

Route::middleware('auth')->group(function () {

    Route::get('/profile', [ProfileController::class, 'edit'])
        ->name('profile.edit');

    Route::patch('/profile', [ProfileController::class, 'update'])
        ->name('profile.update');

    Route::delete('/profile', [ProfileController::class, 'destroy'])
        ->name('profile.destroy');

    // Tambahan route untuk photo profile
    Route::post('/profile/photo', [ProfileController::class, 'updatePhoto'])
        ->name('profile.photo.update');

    Route::delete('/profile/photo', [ProfileController::class, 'deletePhoto'])
        ->name('profile.photo.destroy');

    // Route Inventory Gudang
    Route::get('/inventory', [InventoryController::class, 'index'])
        ->name('inventory.index');

    Route::get('/inventory/create', [InventoryController::class, 'create'])
        ->name('inventory.create');

    Route::post('/inventory', [InventoryController::class, 'store'])
        ->name('inventory.store');

    Route::get('/inventory/{id}', [InventoryController::class, 'show'])
        ->name('inventory.show');

    Route::get('/inventory/{id}/edit', [InventoryController::class, 'edit'])
        ->name('inventory.edit');

    Route::put('/inventory/{id}', [InventoryController::class, 'update'])
        ->name('inventory.update');

    Route::delete('/inventory/{id}', [InventoryController::class, 'destroy'])
        ->name('inventory.destroy');
});

require __DIR__.'/auth.php';