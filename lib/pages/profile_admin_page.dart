import 'package:flutter/material.dart';

/// Data profil sederhana selama aplikasi berjalan.
/// Untuk menyimpan permanen setelah aplikasi ditutup, tambahkan penyimpanan lokal.
class ProfileAdminData {
  static String nama = 'Admin TU';
  static String username = 'admin';
  static String email = '';
}

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color background = Color(0xFFF1F5F9);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: ProfileAdminData.nama);
    _usernameController = TextEditingController(text: ProfileAdminData.username);
    _emailController = TextEditingController(text: ProfileAdminData.email);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      ProfileAdminData.nama = _namaController.text.trim();
      ProfileAdminData.username = _usernameController.text.trim();
      ProfileAdminData.email = _emailController.text.trim();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil admin berhasil diperbarui.')),
    );
  }

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: navy),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD7E0EA)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text('Profil Admin'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundColor: Color(0xFF287EB4),
                        child: Icon(Icons.person, size: 42, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text('Pengaturan Profil', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy)),
                      const SizedBox(height: 6),
                      const Text('Ubah informasi akun administrator.', textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF71839D))),
                      const SizedBox(height: 26),
                      TextFormField(
                        controller: _namaController,
                        decoration: _decoration('Nama Admin', Icons.badge_outlined),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Nama admin wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: _decoration('Username', Icons.person_outline),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Username wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _decoration('Email (opsional)', Icons.email_outlined),
                        validator: (v) {
                          final email = (v ?? '').trim();
                          if (email.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                            return 'Format email belum benar';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _simpan,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Simpan Perubahan'),
                        style: FilledButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Kembali ke Dashboard'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
