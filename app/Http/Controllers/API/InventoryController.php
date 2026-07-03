<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Models\Inventory;

class InventoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $inventories = Inventory::all();

        $inventories->each(function($inventory) {
            $inventory->image_url = $inventory->image
                ? asset('storage/' . $inventory->image)
                : null;
        });

        return response()->json([
            'success' => true,
            'data' => $inventories,
            'message' => 'Data inventory berhasil diambil'
        ], Response::HTTP_OK);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'         => 'required|string|max:255',
            'descriptions' => 'nullable|string',
            'price'        => 'required|numeric|min:0',
            'stock'        => 'required|integer|min:0',
            'image'        => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors()
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $inventory = new Inventory();
        $inventory->name         = $request->name;
        $inventory->descriptions = $request->descriptions;
        $inventory->price        = $request->price;
        $inventory->stock        = $request->stock;

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('inventories', 'public');
            $inventory->image = $path;
        }

        $inventory->save();

        $inventory->image_url = $inventory->image
            ? asset('storage/' . $inventory->image)
            : null;

        return response()->json([
            'success' => true,
            'data'    => $inventory,
            'message' => 'Inventory created successfully'
        ], Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json([
                'success' => false,
                'message' => 'Inventory not found'
            ], Response::HTTP_NOT_FOUND);
        }

        $inventory->image_url = $inventory->image
            ? asset('storage/' . $inventory->image)
            : null;

        return response()->json([
            'success' => true,
            'data' => $inventory
        ], Response::HTTP_OK);
    }

    public function update(Request $request, string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json([
                'success' => false,
                'message' => 'Inventory not found'
            ], Response::HTTP_NOT_FOUND);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|required|string|max:255',
            'descriptions' => 'nullable|string',
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if ($request->has('name')) $inventory->name = $request->name;
        if ($request->has('descriptions')) $inventory->descriptions = $request->descriptions;
        if ($request->has('price')) $inventory->price = $request->price;
        if ($request->has('stock')) $inventory->stock = $request->stock;

        if ($request->hasFile('image')) {
            if ($inventory->image && Storage::disk('public')->exists($inventory->image)) {
                Storage::disk('public')->delete($inventory->image);
            }

            $path = $request->file('image')->store('inventories', 'public');
            $inventory->image = $path;
        }

        $inventory->save();

        $inventory->image_url = $inventory->image
            ? asset('storage/' . $inventory->image)
            : null;

        return response()->json([
            'success' => true,
            'data' => $inventory,
            'message' => 'Inventory updated successfully'
        ], Response::HTTP_OK);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json([
                'success' => false,
                'message' => 'Inventory not found'
            ], Response::HTTP_NOT_FOUND);
        }

        if ($inventory->image && Storage::disk('public')->exists($inventory->image)) {
            Storage::disk('public')->delete($inventory->image);
        }

        $inventory->delete();

        return response()->json([
            'success' => true,
            'message' => 'Inventory deleted successfully'
        ], Response::HTTP_OK);
    }

    /**
     * Reduce inventory stock (custom method untuk Flutter)
     */
    public function reduceStock(Request $request, string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json([
                'success' => false,
                'message' => 'Inventory not found'
            ], Response::HTTP_NOT_FOUND);
        }

        $validator = Validator::make($request->all(), [
            'quantity' => 'required|integer|min:1'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $quantity = $request->quantity;

        if ($inventory->stock < $quantity) {
            return response()->json([
                'success' => false,
                'message' => 'Insufficient stock. Available: ' . $inventory->stock
            ], Response::HTTP_BAD_REQUEST);
        }

        $inventory->stock -= $quantity;
        $inventory->save();

        $inventory->image_url = $inventory->image
            ? asset('storage/' . $inventory->image)
            : null;

        return response()->json([
            'success' => true,
            'data' => $inventory,
            'message' => "Stock reduced by $quantity"
        ], Response::HTTP_OK);
    }

    // Upload Image
    public function uploadImage(Request $request, $id)
    {
        try {
            Log::info('Upload image called', [
                'inventory_id' => $id,
                'has_file' => $request->hasFile('image'),
                'all_files' => $request->allFiles(),
                'all_input' => $request->all()
            ]);

            $inventory = Inventory::find($id);
            if (!$inventory) {
                return response()->json(['message' => 'Inventory not found'], 404);
            }

            // 🔥 Cek apakah ada file yang dikirim
            if (!$request->hasFile('image')) {
                return response()->json([
                    'message' => 'No image file found',
                    'received' => $request->allFiles()
                ], 400);
            }

            $file = $request->file('image');

            // 🔥 Validasi manual
            if (!$file->isValid()) {
                return response()->json([
                    'message' => 'Uploaded file is not valid',
                    'error' => $file->getError()
                ], 400);
            }

            // 🔥 Validasi ukuran dan tipe
            $validator = Validator::make(['image' => $file], [
                'image' => 'required|image|mimes:jpeg,png,jpg|max:2048'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'errors' => $validator->errors()
                ], 422);
            }

            // Hapus gambar lama
            if ($inventory->image && Storage::disk('public')->exists($inventory->image)) {
                Storage::disk('public')->delete($inventory->image);
            }

            // Simpan dengan cara manual
            $destinationPath = storage_path('app/public/inventories');
            if (!file_exists($destinationPath)) {
                mkdir($destinationPath, 0777, true);
            }

            $originalName = pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME);
            $filename = $originalName . '_' . time() . '.' . $file->getClientOriginalExtension();
            $file->move($destinationPath, $filename);

            $inventory->image = 'inventories/' . $filename;
            $inventory->save();

            return response()->json([
                'success' => true,
                'image_url' => asset('storage/inventories/' . $filename)
            ], 200);

        } catch (\Exception $e) {
            Log::error('Upload image error: ' . $e->getMessage());
            Log::error($e->getTraceAsString());
            return response()->json([
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ], 500);
        }
    }
}