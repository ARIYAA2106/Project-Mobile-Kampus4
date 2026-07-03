<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Inventory;
use Illuminate\Support\Facades\Storage;
use Barryvdh\DomPDF\Facade\Pdf;

class InventoryController extends Controller
{
    public function index()
    {
        $inventories = Inventory::all();
        return view('inventory.index', compact('inventories'));
    }

    public function create()
    {
        return view('inventory.create');
    }

    public function store(Request $request)
    {
        $validate = $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpg,jpeg,png',
            'descriptions' => 'required|string|max:1000',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
        ]);

        if ($request->hasFile('image')) {
            $validate['image'] = $request->file('image')
                ->store('inventories', 'public');
        }

        Inventory::create($validate);

        return redirect()->route('inventory.index')
            ->with('success', 'Data Inventory Gudang berhasil ditambahkan!');
    }

    public function edit($id)
    {
        $inventory = Inventory::findOrFail($id);

        return view('inventory.edit', compact('inventory'));
    }

    public function update(Request $request, $id)
    {
        $inventory = Inventory::findOrFail($id);

        $validate = $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpg,jpeg,png',
            'descriptions' => 'required|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
        ]);

        // Update File
        if ($request->hasFile('image')) {
            if ($inventory->image && Storage::disk('public')->exists($inventory->image)) {
                Storage::disk('public')->delete($inventory->image);
            }

            $validate['image'] = $request->file('image')
                ->store('inventories', 'public');
        } else {
            $validate['image'] = $inventory->image;
        }

        $inventory->update($validate);

        return redirect()->route('inventory.index')
            ->with('success', 'Data Inventory Gudang berhasil diperbarui!');
    }

    public function show($id)
    {
        $inventory = Inventory::findOrFail($id);

        return view('inventory.show', compact('inventory'));
    }

    public function destroy($id)
    {
        $inventory = Inventory::findOrFail($id);

        if ($inventory->image &&
            Storage::disk('public')->exists($inventory->image)) {

            Storage::disk('public')->delete($inventory->image);
        }

        $inventory->delete();

        return redirect()->route('inventory.index')
            ->with('success', 'Data Inventory Gudang berhasil dihapus!');
    }

    public function cetakPdf()
    {
        $inventories = Inventory::all();

        $pdf = Pdf::loadView(
            'inventory.cetak',
            ['inventories' => $inventories]
        )->setPaper('a4', 'landscape');

        return $pdf->download('data-inventory-gudang.pdf');
    }
}