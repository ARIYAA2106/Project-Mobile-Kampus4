```php
{{-- resources/views/inventory/show.blade.php --}}
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            Detail Inventory Gudang
        </h2>
    </x-slot>

    <div class="py-6 max-w-4xl mx-auto">
        <div class="bg-white p-6 rounded shadow">

            @if($inventory->image)
                <div class="mb-4 text-center">
                    <img src="{{ asset('storage/' . $inventory->image) }}"
                         alt="{{ $inventory->name }}"
                         class="mx-auto w-64 h-64 object-cover rounded-lg shadow">
                </div>
            @endif

            <div class="space-y-2">

                <p>
                    <strong>Nama Barang :</strong>
                    {{ $inventory->name }}
                </p>

                <p>
                    <strong>File Gambar :</strong>
                    <span class="text-gray-700">
                        {{ $inventory->image }}
                    </span>
                </p>

                <p>
                    <strong>Deskripsi :</strong>
                    {{ $inventory->descriptions }}
                </p>

                <p>
                    <strong>Harga :</strong>
                    {{ number_format($inventory->price, 0, ',', '.') }}
                </p>

                <p>
                    <strong>Stok :</strong>
                    {{ number_format($inventory->stock, 0, ',', '.') }}
                </p>

            </div>

            <div class="mt-4">
                <a href="{{ route('inventory.index') }}"
                   class="text-blue-600 hover:text-blue-900">
                    Kembali ke Daftar Inventory
                </a>
            </div>

        </div>
    </div>
</x-app-layout>
```