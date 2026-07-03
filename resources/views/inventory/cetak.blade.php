```php
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Data Inventory Gudang</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            font-size: 12px;
        }

        h3 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th,
        td {
            border: 1px solid #000;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        .image-cell {
            width: 80px;
            text-align: center;
        }

        img {
            max-width: 60px;
            max-height: 60px;
            object-fit: cover;
        }

        .text-center {
            text-align: center;
        }

        .text-right {
            text-align: right;
        }
    </style>
</head>

<body>

    <h3>DATA INVENTORY GUDANG</h3>

    <table>
        <thead>
            <tr>
                <th width="5%" class="text-center">No</th>
                <th width="20%">Nama Barang</th>
                <th width="15%" class="text-center">Gambar</th>
                <th width="35%">Deskripsi</th>
                <th width="15%" class="text-right">Harga</th>
                <th width="10%" class="text-center">Stok</th>
            </tr>
        </thead>

        <tbody>
            @forelse($inventories as $index => $p)
                <tr>
                    <td class="text-center">
                        {{ $loop->iteration }}
                    </td>

                    <td>
                        {{ $p->name }}
                    </td>

                    <td class="text-center">
                        @if($p->image)

                            @php
                                $imagePath = storage_path('app/public/' . $p->image);
                            @endphp

                            @if(file_exists($imagePath))
                                <img src="{{ $imagePath }}" alt="{{ $p->name }}">
                            @else
                                <span style="color:#999;">No Image</span>
                            @endif

                        @else
                            <span style="color:#999;">No Image</span>
                        @endif
                    </td>

                    <td>
                        {{ $p->descriptions }}
                    </td>

                    <td class="text-right">
                        Rp {{ number_format($p->price, 0, ',', '.') }}
                    </td>

                    <td class="text-center">
                        {{ $p->stock ?? '-' }}
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="text-center">
                        Tidak ada data inventory
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>

    <div style="margin-top:30px; font-size:10px; text-align:center;">
        <hr>
        Dicetak pada: {{ date('d-m-Y H:i:s') }}
    </div>

</body>
</html>
```