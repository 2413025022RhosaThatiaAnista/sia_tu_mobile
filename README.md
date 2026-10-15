# SIA-TU SEKOLAH
### Sistem Informasi Tata Usaha Sekolah

SIA-TU SEKOLAH adalah aplikasi antarmuka administrasi tata usaha sekolah yang dirancang untuk membantu pengguna mengakses dan melihat informasi administrasi sekolah melalui satu aplikasi. Proyek ini dibuat menggunakan **Flutter** dan **Dart**, dengan tampilan yang mengutamakan navigasi sederhana, informasi yang mudah dibaca, serta tata letak untuk penggunaan melalui browser desktop.

> **Catatan penting:** Screenshot di bawah ini mendokumentasikan tampilan aplikasi. Jumlah data dan isi tabel yang terlihat merupakan data contoh pada tampilan yang didokumentasikan, kecuali jika proyek sudah dihubungkan dengan penyimpanan data nyata. Jangan menganggap login, penyimpanan permanen, atau fitur yang belum diuji sebagai layanan produksi.

---

## Daftar Isi
- [Gambaran Umum](#gambaran-umum)
- [Tujuan Aplikasi](#tujuan-aplikasi)
- [Fitur dan Halaman](#fitur-dan-halaman)
- [Teknologi](#teknologi)
- [Tangkapan Layar](#tangkapan-layar)
- [Struktur Proyek](#struktur-proyek)
- [Persyaratan Menjalankan Aplikasi](#persyaratan-menjalankan-aplikasi)
- [Cara Mengunduh dan Menjalankan](#cara-mengunduh-dan-menjalankan)
- [Pemeriksaan Sebelum Menjalankan](#pemeriksaan-sebelum-menjalankan)
- [Riwayat Pengembangan](#riwayat-pengembangan)
- [Pengembang](#pengembang)

## Gambaran Umum

Administrasi tata usaha sekolah mencakup pengelolaan informasi siswa, tenaga pengajar, serta surat-menyurat. SIA-TU SEKOLAH menyajikan halaman-halaman tersebut dalam satu antarmuka dengan menu navigasi di sisi aplikasi. Dashboard menampilkan ringkasan informasi, sedangkan halaman data dan surat menyediakan tampilan daftar yang dapat membantu pengguna memahami susunan informasi administrasi.

README ini menjelaskan antarmuka yang terlihat pada screenshot yang disertakan, cara menyiapkan proyek Flutter, dan perintah dasar untuk menjalankannya. Ketersediaan operasi seperti tambah, ubah, hapus, autentikasi, unduh, atau penyimpanan permanen harus dikonfirmasi melalui kode dan pengujian proyek.

## Tujuan Aplikasi

1. Menyediakan antarmuka administrasi sekolah yang memiliki navigasi antarhalaman.
2. Menampilkan ringkasan informasi sekolah melalui dashboard.
3. Menyusun informasi siswa dan guru dalam bentuk daftar/tabel.
4. Menyajikan daftar surat masuk beserta informasi dasar dan status baca.
5. Menyediakan halaman laporan sebagai bagian dari navigasi aplikasi.
6. Menggunakan gaya visual yang konsisten, seperti warna biru tua, latar belakang terang, kartu informasi, ikon, dan label status.

## Fitur dan Halaman

### 1. Login

Halaman login menampilkan identitas SIA-TU SEKOLAH, panel sambutan, kolom **Username / ID Anggota**, kolom **Password Sistem**, opsi **Ingat Sesi**, tautan **Lupa Password?**, tombol **LOGIN**, dan tautan **Daftar Sini**.

Tampilan ini berfungsi sebagai halaman masuk. Mekanisme autentikasi sesungguhnya—misalnya pemeriksaan akun, penyimpanan sesi, pemulihan kata sandi, atau pendaftaran—perlu dipastikan dari implementasi kode dan diuji sebelum disebut aktif.

### 2. Dashboard

Dashboard menyajikan ringkasan visual, antara lain:
- jumlah siswa aktif;
- ringkasan tenaga pengajar;
- kategori status siswa;
- grafik perkembangan jumlah siswa per tahun;
- grafik statistik kelulusan siswa;
- menu menuju Data Siswa, Data Guru, Surat Masuk, Surat Keluar, dan Laporan;
- informasi akun administrator pada bagian atas.

Angka dan grafik pada screenshot merupakan angka yang ditampilkan oleh versi aplikasi yang didokumentasikan. Pastikan sumber angka tersebut sebelum menggunakannya sebagai data resmi sekolah.

### 3. Data Siswa

Halaman Data Siswa menampilkan kartu ringkasan **Total Siswa**, **Siswa Aktif**, **Laki-laki**, dan **Perempuan**. Di bawahnya terdapat daftar siswa dengan kolom:
- nama siswa;
- NIS;
- NISN;
- kelas;
- jenis kelamin;
- status;
- aksi.

Pada screenshot, contoh data yang terlihat mencakup Ahmad Fauzan, Siti Aisyah, dan Rizky Pratama. Nama dan nomor yang terlihat adalah isi screenshot demonstrasi; jangan gunakan sebagai data resmi tanpa verifikasi. Tombol aksi yang terlihat pada baris data juga perlu diuji untuk memastikan perilakunya.

### 4. Data Guru

Halaman Data Guru menyajikan ringkasan **Total Guru**, **Guru Aktif**, **Laki-laki**, dan **Perempuan**. Tabelnya menampilkan:
- nama guru;
- NIP;
- NUPTK;
- jabatan;
- mata pelajaran.

Screenshot memperlihatkan contoh nama Budi Santoso, Siti Rahmawati, dan Andi Wijaya. Data tersebut dicantumkan hanya untuk menjelaskan tampilan antarmuka dan bukan pernyataan bahwa data itu merupakan data sekolah yang sebenarnya.

### 5. Surat Masuk

Halaman Surat Masuk menampilkan judul **Data Surat Masuk**, deskripsi pengarsipan surat yang diterima sekolah, serta kartu ringkasan:
- total surat;
- belum dibaca;
- sudah dibaca;
- arsip.

Tersedia kolom pencarian dengan petunjuk untuk mencari nomor, asal surat, atau perihal, serta tombol **Tambah Surat**. Tabel menampilkan nomor surat, tanggal, asal, perihal, tujuan, status, dan aksi. Contoh baris pada screenshot antara lain surat dari Dinas Pendidikan, Kecamatan, dan Komite Sekolah. Pastikan tombol pencarian, tambah, edit, hapus, dan arsip diuji di aplikasi untuk memastikan fungsi yang sudah benar-benar berjalan.

### 6. Surat Keluar

Menu **Surat Keluar** terlihat pada navigasi. Screenshot halaman Surat Keluar belum disertakan dalam dokumentasi ini. Rincian kolom dan fungsi halaman tersebut perlu diperbarui setelah halaman aktual didokumentasikan dan diuji.

### 7. Laporan

Menu **Laporan** terlihat pada navigasi aplikasi. Halaman ini dimaksudkan sebagai bagian pelaporan administrasi. Screenshot halaman Laporan belum disertakan pada bagian ini; tambahkan screenshot halaman aktual dan jelaskan filter, ringkasan, serta ekspor hanya jika fungsi tersebut tersedia dan sudah diuji.

## Teknologi

Teknologi yang digunakan atau diperlukan untuk proyek ini:
- **Flutter** — framework untuk membangun antarmuka aplikasi.
- **Dart** — bahasa pemrograman Flutter.
- **Material Design / Material widgets** — komponen antarmuka Flutter, jika digunakan pada kode.
- **Git dan GitHub** — pengelolaan versi serta repositori proyek.

Versi Flutter/Dart dan paket yang digunakan mengikuti konfigurasi proyek, khususnya file `pubspec.yaml` dan berkas lock yang disertakan.

## Tangkapan Layar

Screenshot berikut merupakan dokumentasi visual halaman aplikasi. File gambar disimpan di folder `screenshots/` di dalam repositori agar tampil ketika README dibuka di GitHub.

### 1. Halaman Login

Halaman awal aplikasi dengan panel sambutan di sebelah kiri dan formulir login di sebelah kanan. Formulir menyediakan kolom username/ID anggota dan password serta opsi ingat sesi.

![Screenshot halaman Login](screenshots/login.png)

### 2. Halaman Dashboard

Dashboard memperlihatkan ringkasan siswa dan tenaga pengajar, kategori status siswa, grafik perkembangan jumlah siswa, grafik statistik kelulusan, serta menu navigasi utama.

![Screenshot halaman Dashboard](screenshots/dashboard.png)

### 3. Halaman Data Siswa

Halaman ini menampilkan kartu ringkasan jumlah siswa dan tabel data yang memuat nama, NIS, NISN, kelas, jenis kelamin, status, serta kolom aksi.

![Screenshot halaman Data Siswa](screenshots/data-siswa.png)

### 4. Halaman Data Guru

Halaman ini menampilkan ringkasan jumlah guru dan tabel dengan informasi nama, NIP, NUPTK, jabatan, serta mata pelajaran.

![Screenshot halaman Data Guru](screenshots/data-guru.png)

### 5. Halaman Surat Masuk

Halaman ini menampilkan statistik surat, kolom pencarian, tombol tambah surat, serta daftar surat dengan nomor, tanggal, asal, perihal, tujuan, status, dan aksi.

![Screenshot halaman Surat Masuk](screenshots/surat-masuk.png)

> **Catatan screenshot:** gambar di atas adalah file yang diberikan untuk dokumentasi. Jika tampilan aplikasi berubah, ambil screenshot baru dan ganti file terkait. Hindari menyertakan kata sandi, token, atau informasi pribadi nyata dalam screenshot.

## Struktur Proyek

Struktur umum proyek Flutter biasanya seperti berikut. Nama file di repositori harus disesuaikan dengan struktur yang benar-benar ada pada proyek.

```text
sia_tu_mobile/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   └── pages/
│       ├── login_page.dart
│       ├── dashboard_page.dart
│       ├── siswa_page.dart
│       ├── guru_page.dart
│       ├── surat_masuk_page.dart
│       └── laporan_page.dart
├── screenshots/
│   ├── login.png
│   ├── dashboard.png
│   ├── data-siswa.png
│   ├── data-guru.png
│   └── surat-masuk.png
├── test/
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── AI_DECLARATION.md
```

Folder dan file di atas adalah contoh struktur dokumentasi. Hapus atau ubah bagian yang tidak cocok dengan isi repositori aktual.

## Persyaratan Menjalankan Aplikasi

Sebelum menjalankan proyek, siapkan:
1. Flutter SDK yang terpasang dan sudah ditambahkan ke PATH.
2. Dart SDK yang sesuai; biasanya sudah disertakan bersama Flutter.
3. Git untuk mengambil repositori.
4. Browser Google Chrome jika ingin menjalankan target web melalui Chrome, atau perangkat/emulator yang didukung Flutter.
5. Editor seperti Visual Studio Code atau Android Studio (opsional, tetapi membantu).

Periksa instalasi Flutter dengan:

```bash
flutter --version
flutter doctor
```

Untuk menjalankan di Chrome, pastikan Chrome terdeteksi sebagai perangkat Flutter:

```bash
flutter devices
```

## Cara Mengunduh dan Menjalankan

### Langkah 1 — Clone repositori

Buka terminal atau Command Prompt, lalu jalankan:

```bash
git clone https://github.com/2413025022RhosaThatiaAnista/sia_tu_mobile.git
cd sia_tu_mobile
```

Jika repositori sudah ada di komputer, pindah ke folder proyek tersebut, lalu ambil perubahan terbaru:

```bash
git pull origin main
```

### Langkah 2 — Unduh dependensi

Dari folder yang berisi `pubspec.yaml`, jalankan:

```bash
flutter pub get
```

Tunggu sampai proses selesai. Jika muncul pesan error, baca pesan tersebut dan pastikan koneksi internet, versi Flutter, serta konfigurasi dependensi sudah sesuai.

### Langkah 3 — Periksa perangkat yang tersedia

```bash
flutter devices
```

Jika Chrome muncul dalam daftar, aplikasi dapat dicoba di browser. Jika tidak, periksa instalasi Chrome dan dukungan platform web pada instalasi Flutter.

### Langkah 4 — Jalankan aplikasi di Chrome

```bash
flutter run -d chrome
```

Untuk menjalankan aplikasi pada perangkat atau emulator lain, gunakan ID perangkat yang ditampilkan oleh `flutter devices`, misalnya:

```bash
flutter run -d <device_id>
```

Ganti `<device_id>` dengan ID perangkat yang benar; tanda kurung sudut tidak perlu diketik jika menggunakan ID asli.

### Langkah 5 — Periksa kode

Untuk melakukan pemeriksaan statis dasar, jalankan:

```bash
flutter analyze
```

Jika proyek memiliki pengujian, jalankan:

```bash
flutter test
```

Perintah di atas merupakan langkah pemeriksaan yang disarankan, bukan pernyataan bahwa analisis atau seluruh pengujian sudah lulus. Catat hasil aktual saat menjalankannya.

## Pemeriksaan Sebelum Menjalankan

Jika aplikasi tidak berjalan, coba langkah berikut:
1. Pastikan terminal berada di folder proyek yang memiliki `pubspec.yaml`.
2. Jalankan kembali `flutter pub get`.
3. Periksa keluaran `flutter doctor` dan selesaikan masalah instalasi yang dilaporkan.
4. Pastikan target yang dipilih tersedia melalui `flutter devices`.
5. Baca error pertama yang relevan di terminal; perbaiki error tersebut sebelum mencoba ulang.
6. Jangan menghapus file konfigurasi atau mengubah versi paket secara acak tanpa memahami penyebab error.

## Riwayat Pengembangan

Repositori Git menyimpan riwayat perubahan proyek. Riwayat commit dapat dilihat melalui:

[Riwayat commit SIA-TU SEKOLAH di GitHub](https://github.com/2413025022RhosaThatiaAnista/sia_tu_mobile/commits/main/)

Untuk menjaga dokumentasi pengembangan yang jelas, buat commit ketika ada perubahan yang benar-benar dikerjakan, gunakan pesan commit yang menjelaskan perubahan, dan jangan membuat commit atau tanggal seolah-olah pekerjaan dilakukan pada waktu yang berbeda.

## Pengembang

- **Nama:** [Isi nama lengkap]
- **NIM:** [Isi NIM]
- **Mata kuliah/Kelas:** [Isi sesuai kebutuhan]
- **Repositori:** https://github.com/2413025022RhosaThatiaAnista/sia_tu_mobile

## Deklarasi Penggunaan AI

Informasi penggunaan alat AI dan pembagian pekerjaan dijelaskan di [`AI_DECLARATION.md`](AI_DECLARATION.md). Pastikan isinya ditinjau dan disesuaikan dengan proses pengerjaan yang sebenarnya sebelum dikumpulkan.
