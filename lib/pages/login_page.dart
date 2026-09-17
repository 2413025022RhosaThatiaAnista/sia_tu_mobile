import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool rememberMe = false;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> login() async {
    if (isLoading) return;

    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // ==========================================================
    // VALIDASI USERNAME
    // ==========================================================

    if (username.isEmpty) {
      showMessage('Username wajib diisi.');
      return;
    }

    // ==========================================================
    // VALIDASI PASSWORD
    // ==========================================================

    if (password.isEmpty) {
      showMessage('Password wajib diisi.');
      return;
    }

    // ==========================================================
    // LOADING LOGIN
    // ==========================================================

    setState(() {
      isLoading = true;
    });

    // Simulasi proses autentikasi
    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    if (!mounted) return;

    // ==========================================================
    // CEK AKUN
    // ==========================================================

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Username atau password salah.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF2F83BA),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool desktop =
                  constraints.maxWidth >= 800;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: desktop ? 55 : 18,
                    vertical: desktop ? 25 : 18,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Color(0xFF193F68),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'SIA-TU SEKOLAH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      if (desktop)
                        SizedBox(
                          width: 1200,
                          height: 650,
                          child: _desktopCard(),
                        )
                      else
                        _mobileCard(),

                      const SizedBox(height: 28),

                      const Text(
                        'SIA-TU SEKOLAH 2026',
                        style: TextStyle(
                          color: Color(0xFFB9D7EA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP CARD
  // ============================================================

  Widget _desktopCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Row(
        children: [
          Expanded(
            child: _welcomePanel(),
          ),
          Expanded(
            child: _loginPanel(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE CARD
  // ============================================================

  Widget _mobileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _welcomePanelMobile(),
          _loginPanelMobile(),
        ],
      ),
    );
  }

  // ============================================================
  // WELCOME DESKTOP
  // ============================================================

  Widget _welcomePanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF173F69),
            Color(0xFF287EB4),
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: -180,
            right: -150,
            child: Container(
              width: 430,
              height: 430,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -90,
            bottom: -100,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 380,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF3296BB)
                      .withValues(alpha: 0.85),
                  borderRadius:
                      BorderRadius.circular(130),
                ),
              ),
            ),
          ),

          Positioned(
            left: 35,
            bottom: 15,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.10),
                borderRadius:
                    BorderRadius.circular(25),
              ),
            ),
          ),

          Positioned(
            right: 35,
            bottom: 22,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(35),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      width: 55,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7298BA),
                        borderRadius:
                            BorderRadius.only(
                          topLeft:
                              Radius.circular(50),
                          topRight:
                              Radius.circular(10),
                          bottomLeft:
                              Radius.circular(10),
                          bottomRight:
                              Radius.circular(50),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'WELCOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 95,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF963F),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Silahkan masuk ke dalam sistem menggunakan akun '
                    'administrator Tata\n'
                    'Usaha Anda untuk mulai mengelola database sekolah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB8D4E9),
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WELCOME MOBILE
  // ============================================================

  Widget _welcomePanelMobile() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF173F69),
            Color(0xFF287EB4),
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -70,
            bottom: -70,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 300,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFF3296BB)
                      .withValues(alpha: 0.85),
                  borderRadius:
                      BorderRadius.circular(130),
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      width: 42,
                      height: 65,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7298BA),
                        borderRadius:
                            BorderRadius.only(
                          topLeft:
                              Radius.circular(40),
                          topRight:
                              Radius.circular(8),
                          bottomLeft:
                              Radius.circular(8),
                          bottomRight:
                              Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'WELCOME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF963F),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 13),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Silahkan masuk ke dalam sistem menggunakan akun '
                      'administrator Tata Usaha Anda untuk mulai '
                      'mengelola database sekolah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB8D4E9),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGIN DESKTOP
  // ============================================================

  Widget _loginPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 55,
      ),
      child: _loginForm(
        titleSize: 38,
        subtitleSize: 16,
        fieldFontSize: 17,
        buttonHeight: 58,
        buttonFontSize: 17,
        bottomFontSize: 15,
      ),
    );
  }

  // ============================================================
  // LOGIN MOBILE
  // ============================================================

  Widget _loginPanelMobile() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        22,
        28,
        22,
        25,
      ),
      child: _loginForm(
        titleSize: 28,
        subtitleSize: 13,
        fieldFontSize: 14,
        buttonHeight: 52,
        buttonFontSize: 15,
        bottomFontSize: 12,
      ),
    );
  }

  // ============================================================
  // LOGIN FORM
  // ============================================================

  Widget _loginForm({
    required double titleSize,
    required double subtitleSize,
    required double fieldFontSize,
    required double buttonHeight,
    required double buttonFontSize,
    required double bottomFontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login Account',
          style: TextStyle(
            color: const Color(0xFF193F68),
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Masukkan kredensial otentikasi resmi Anda di bawah ini',
          style: TextStyle(
            color: const Color(0xFF9AAAC0),
            fontSize: subtitleSize,
          ),
        ),

        const SizedBox(height: 30),

        // ======================================================
        // USERNAME
        // ======================================================

        TextField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Username / ID Anggota',
            hintStyle: TextStyle(
              color: const Color(0xFF9CA8B8),
              fontSize: fieldFontSize,
            ),
            prefixIcon: const Icon(
              Icons.person,
              color: Color(0xFF5C3C91),
            ),
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 15,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD1DCE8),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF287EB4),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // ======================================================
        // PASSWORD
        // ======================================================

        TextField(
          controller: passwordController,
          obscureText: hidePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => login(),
          decoration: InputDecoration(
            hintText: 'Password Sistem',
            hintStyle: TextStyle(
              color: const Color(0xFF9CA8B8),
              fontSize: fieldFontSize,
            ),
            prefixIcon: const Icon(
              Icons.lock,
              color: Color(0xFFFF9A3D),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                hidePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: const Color(0xFF9AAAC0),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 15,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFD1DCE8),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF287EB4),
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ======================================================
        // REMEMBER ME
        // ======================================================

        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        rememberMe =
                            value ?? false;
                      });
                    },
              activeColor:
                  const Color(0xFF1D4D7A),
            ),

            Expanded(
              child: Text(
                'Ingat Sesi',
                style: TextStyle(
                  color:
                      const Color(0xFF91A5BF),
                  fontSize: bottomFontSize,
                ),
              ),
            ),

            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      showMessage(
                        'Fitur lupa password belum tersedia.',
                      );
                    },
              child: Text(
                'Lupa Password?',
                style: TextStyle(
                  color:
                      const Color(0xFF91A5BF),
                  fontSize: bottomFontSize,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ======================================================
        // LOGIN BUTTON
        // ======================================================

        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : login,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF1C4D79),
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  const Color(0xFF7895AD),
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(35),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 23,
                    height: 23,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<
                              Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 25),

        const Divider(
          color: Color(0xFFE7EDF3),
          thickness: 1,
        ),

        const SizedBox(height: 20),

        // ======================================================
        // DAFTAR
        // ======================================================

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                'Belum memiliki akses sistem administrasi? ',
                style: TextStyle(
                  color:
                      const Color(0xFF91A5BF),
                  fontSize: bottomFontSize,
                ),
              ),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        showMessage(
                          'Halaman pendaftaran belum tersedia.',
                        );
                      },
                child: Text(
                  'Daftar Sini',
                  style: TextStyle(
                    color:
                        const Color(0xFF193F68),
                    fontSize: bottomFontSize,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}