<?php

use App\Http\Controllers\API\InventoryController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::apiResource('inventories', InventoryController::class);

Route::post(
    'inventories/{id}/upload-image',
    [InventoryController::class, 'uploadImage']
);

// Route custom untuk mengurangi stok
Route::patch(
    'inventories/{id}/reduce-stock',
    [InventoryController::class, 'reduceStock']
);

// Akses gambar via API
Route::get('/image/{filename}', function ($filename) {
    $path = storage_path('app/public/inventories/' . $filename);

    if (!file_exists($path)) {
        return response()->json([
            'error' => 'Image not found'
        ], 404);
    }

    return response()->file($path, [
        'Access-Control-Allow-Origin' => '*'
    ]);
})->where('filename', '.*');

// Check API
Route::get('/check', function () {
    return response()->json([
        'message' => 'API route works'
    ]);
});