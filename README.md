
# kelompok6_Petify

## Deskripsi Proyek

Petify merupakan aplikasi mobile yang dirancang untuk membantu pemilik hewan peliharaan dalam mengelola kebutuhan perawatan secara lebih teratur, terpantau, dan terdokumentasi dengan baik. Aplikasi ini berfungsi sebagai media pencatatan digital untuk aktivitas penting seperti jadwal makan, vaksinasi, kebersihan, serta riwayat kesehatan hewan. Pengembangan Petify dilatarbelakangi oleh permasalahan umum yang sering dihadapi pemilik hewan, yaitu kesulitan menjaga keteraturan perawatan akibat tidak adanya sistem pencatatan terpusat, sehingga informasi penting seperti perkembangan kondisi hewan dan jadwal vaksinasi kerap terlewat.

Aplikasi Petify bertujuan untuk menyediakan platform terintegrasi bagi pemilik hewan dalam menyimpan data pemilik dan hewan, memantau kondisi kesehatan melalui dashboard, mencatat pelayanan medis serta pengingat vaksin, dan menyimpan riwayat aktivitas perawatan sebagai bahan evaluasi perkembangan hewan. Petify ditujukan bagi pemilik hewan pemula maupun berpengalaman, baik individu maupun keluarga, yang membutuhkan sistem terorganisir untuk membantu pengelolaan perawatan hewan secara konsisten.

---

## Panduan Instalasi dan Menjalankan Prototype Aplikasi Petify

Bagian ini menjelaskan tahapan instalasi Flutter dan konfigurasi lingkungan pengembangan hingga prototype aplikasi Petify dapat dijalankan.

### 1. Persiapan Perangkat dan Lingkungan
Pengguna memastikan perangkat menggunakan sistem operasi Windows, macOS, atau Linux dengan koneksi internet yang stabil. Selain itu, disiapkan ruang penyimpanan yang cukup untuk Flutter SDK dan dependency pendukung. Apabila pengujian dilakukan pada perangkat mobile, pengguna menyiapkan smartphone Android beserta kabel USB.

### 2. Instalasi Flutter SDK
Flutter SDK diunduh melalui situs resmi Flutter, kemudian diekstrak ke direktori tertentu. Direktori `bin` Flutter ditambahkan ke Environment Variables agar Flutter dapat dijalankan melalui terminal. Setelah itu, pengguna menjalankan perintah berikut untuk memastikan instalasi berhasil:
```bash
flutter doctor
````

### 3. Instalasi Visual Studio Code

Pengguna mengunduh dan menginstal Visual Studio Code sebagai editor pengembangan. Setelah instalasi selesai, aplikasi dijalankan untuk memastikan dapat digunakan dengan normal.

### 4. Instalasi Ekstensi Flutter dan Dart

Melalui menu Extensions di Visual Studio Code, pengguna menginstal ekstensi **Flutter** dan **Dart**. Setelah instalasi, Visual Studio Code direstart agar seluruh fitur berjalan optimal.

### 5. Menjalankan Prototype di Browser Google Chrome

Pengguna membuka folder project Petify di Visual Studio Code dan menjalankan perintah:

```bash
flutter pub get
flutter run
```

Dengan target perangkat berupa browser Google Chrome, prototype aplikasi akan ditampilkan setelah proses build selesai.

### 6. Menjalankan Prototype di Perangkat Android

Pengguna mengaktifkan **Developer Options** dan **USB Debugging** pada perangkat Android, lalu menghubungkannya ke komputer. Setelah perangkat terdeteksi oleh Flutter, aplikasi dijalankan menggunakan perintah:

```bash
flutter run
```

### 7. Verifikasi Instalasi

Sebagai tahap akhir, pengguna kembali menjalankan `flutter doctor` untuk memastikan seluruh komponen pendukung telah terpasang dengan benar.

---

## Cara Menjalankan Prototype Aplikasi Petify

### 1. Membuka Project

Pengguna membuka Visual Studio Code dan memuat folder project Petify.

### 2. Menjalankan Dependency

Pastikan seluruh dependency telah terpasang dengan menjalankan:

```bash
flutter pub get
```

### 3. Pemilihan Perangkat Target

Pengguna memilih perangkat target berupa browser Google Chrome atau perangkat Android yang terhubung.

### 4. Menjalankan Aplikasi

Aplikasi dijalankan dengan perintah:

```bash
flutter run
```

### 5. Pengujian Aplikasi

Setelah aplikasi berjalan, pengguna dapat menguji fitur utama seperti **Owner Profile**, **Virtual Pet Wellbeing**, **Medical Record**, dan **History**.

### 6. Menghentikan Aplikasi

Untuk menghentikan aplikasi, tekan:

```bash
Ctrl + C
```

pada terminal.

---

## Struktur Folder Aplikasi Petify

Inti folder aplikasi berada pada direktori `lib` dengan struktur sebagai berikut:

### `common/widget`

* `calender_modal.dart`
  Menampilkan kalender custom dalam bentuk modal/dialog.
* `failure_dialog.dart`
  Menampilkan dialog error atau kegagalan (registrasi, upload, validasi, dan lain-lain).
* `shortcut_page.dart`
  Halaman pintasan untuk akses cepat ke fitur utama.
* `success_dialog.dart`
  Dialog notifikasi untuk aksi yang berhasil dilakukan.

### `features/auth`

#### `models`

* `user_model.dart`
  Model data profil pengguna.

#### `screens`

* `login_screen.dart`
  Halaman login menggunakan email–password atau Google Sign-In melalui Supabase.
* `register_screen.dart`
  Halaman pendaftaran akun baru.
* `splash_welcome_screen.dart`
  Halaman onboarding awal dengan beberapa slide pengenalan aplikasi.

### `features/history`

* `history_page.dart`
  Menampilkan riwayat aktivitas pengguna dan total poin secara real-time dari Supabase.

### `features/rewards/screens`

* `reward_confirmation.dart`
  Halaman konfirmasi penukaran reward.
* `reward_status_dialogue.dart`
  Dialog status keberhasilan atau kegagalan penukaran reward.
* `rewards_page.dart`
  Halaman daftar reward yang dapat ditukar beserta total poin pengguna.

### `features/virtual_pet_wellbeing`

#### `models`

* `pet_model.dart`
  Model data hewan peliharaan.

#### `screens`

* `add_medical_record_screen.dart`
  Menambahkan data rekam medis peliharaan.
* `add_pet_screen.dart`
  Menambahkan data peliharaan baru.
* `add_vaksin_screen.dart`
  Menambahkan data vaksinasi peliharaan.
* `dashboard_screen.dart`
  Dashboard ringkasan profil pengguna, poin, dan data peliharaan.
* `jenis_vaksinasi_modal.dart`
  Modal pilihan jenis vaksinasi.
* `medical_record_screen.dart`
  Daftar riwayat medis dan vaksinasi peliharaan.
* `vpm_home_screen.dart`
  Halaman utama Virtual Pet Wellbeings.

#### `widget`

* `pet_card.dart`
  Kartu interaktif untuk menampilkan informasi peliharaan.

### `owner_profile`

* `edit_profile.dart`
  Halaman untuk mengubah data profil pengguna.
* `profile_page.dart`
  Halaman tampilan profil pengguna.

### `main.dart`

Entry point aplikasi Petify yang menginisialisasi Supabase, konfigurasi tema dan lokalisasi, serta navigasi awal aplikasi.
