# Setup Laravel untuk Flutter App - Pertemuan 12

## 🔧 Konfigurasi Backend Laravel

### 1. **Storage Link Setup**
Pastikan sudah membuat symbolic link di Laravel:
```bash
php artisan storage:link
```

**Output yang diharapkan:**
```
The [public/storage] directory has been linked to [storage/app/public] successfully.
```

### 2. **Upload Path di Controller**
Pastikan di Laravel controller saat upload gambar, simpan path-nya ke database:

```php
// Contoh Laravel Controller
if ($request->hasFile('image')) {
    $path = $request->file('image')->store('products', 'public');
    $product->image = $path; // Simpan: "products/filename.jpg"
}
```

### 3. **Response Format API**
Pastikan API response format seperti ini:

**GET /api/products**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Produk A",
      "descriptions": "Deskripsi produk",
      "price": 50000,
      "stock": 10,
      "image": "products/xyz123.jpg",
      "created_at": "2024-01-01T10:00:00",
      "updated_at": "2024-01-01T10:00:00"
    }
  ]
}
```

**Atau tanpa wrapper:**
```json
[
  {
    "id": 1,
    "name": "Produk A",
    ...
  }
]
```

---

## 🔍 Debugging Gambar

Jika gambar tidak muncul, ikuti langkah berikut:

### **Step 1: Check Console Log**
Jalankan app dan lihat console Flutter untuk melihat log:
```
========== IMAGE DEBUG ==========
Original: products/xyz123.jpg
Cleaned: /products/xyz123.jpg
Storage URL: http://localhost:8000/storage
Final URL: http://localhost:8000/storage/products/xyz123.jpg
==================================
```

### **Step 2: Test URL di Browser**
Copy URL dari log (contoh: `http://localhost:8000/storage/products/xyz123.jpg`)
Buka di browser untuk test apakah gambar bisa diakses.

### **Step 3: Common Issues**

**❌ 404 - File Not Found**
- Check folder `storage/app/public/products/` apakah file ada
- Pastikan sudah jalankan `php artisan storage:link`

**❌ 403 - Forbidden**
- Check permission folder `storage/app/public/`
- Jalankan: `chmod -R 755 storage/`

**❌ CORS Error**
- Tambahkan di Laravel `config/cors.php`:
```php
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

**❌ localhost:8000 tidak terhubung**
- Pastikan Laravel running: `php artisan serve`
- Check port 8000 tidak dipakai app lain
- Dari device emulator Android, gunakan: `http://10.0.2.2:8000` bukan localhost

---

## 📱 Untuk Emulator Android

Ganti base URL di `api_service.dart`:
```dart
// Dari:
static const String baseUrl = 'http://localhost:8000/api';
static const String storageUrl = 'http://localhost:8000/storage';

// Menjadi:
static const String baseUrl = 'http://10.0.2.2:8000/api';
static const String storageUrl = 'http://10.0.2.2:8000/storage';
```

---

## ✅ Checklist Setup

- [ ] `php artisan storage:link` sudah dijalankan
- [ ] File gambar ada di `storage/app/public/products/`
- [ ] Laravel server berjalan (`php artisan serve`)
- [ ] Database migration sudah dijalankan
- [ ] API response format sesuai dokumentasi
- [ ] CORS sudah dikonfigurasi (jika perlu)
- [ ] Tested URL gambar di browser - berhasil

---

## 🚀 Cara Test

1. Buka Postman/Insomnia
2. GET `http://localhost:8000/api/products`
3. Lihat response, ambil field `image` dari salah satu produk
4. Test URL gambar di browser
5. Jika berhasil, baru jalankan Flutter app

