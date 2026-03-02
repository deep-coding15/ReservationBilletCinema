import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/');
    } else {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Erreur de connexion'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.7, -0.6),
                radius: 1.2,
                colors: [Color(0xFF2A0A0A), Color(0xFF0D0D1A)],
              ),
            ),
          ),
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFE50914).withOpacity(0.1), width: 1),
              ),
            ),
          ),
          Positioned(
            bottom: -60, left: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFE50914).withOpacity(0.07), width: 1),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),
                      Center(
                        child: Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFFE50914), Color(0xFFB20710)]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE50914).withOpacity(0.4),
                                blurRadius: 24, offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.movie_filter_rounded,
                              color: Colors.white, size: 36),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            const Text('Bon retour !',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5)),
                            const SizedBox(height: 8),
                            Text('Connectez-vous pour continuer',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Affichage erreur
                      if (authState.error != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Text(authState.error!,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 13)),
                        ),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Email requis';
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(v))
                                  return 'Email invalide';
                                return null;
                              },
                              decoration: _inputDecoration(
                                  'Adresse email', Icons.email_outlined),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Mot de passe requis';
                                if (v.length < 8) return 'Minimum 8 caractères';
                                return null;
                              },
                              decoration: _inputDecoration(
                                  'Mot de passe', Icons.lock_outline_rounded)
                                  .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white38, size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () =>
                                    context.go('/auth/forgot-password'),
                                child: const Text('Mot de passe oublié ?',
                                    style: TextStyle(
                                        color: Color(0xFFE50914),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed:
                                authState.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE50914),
                                  disabledBackgroundColor:
                                  const Color(0xFFE50914).withOpacity(0.5),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5))
                                    : const Text('Se connecter',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3)),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        color: Colors.white.withOpacity(0.1),
                                        thickness: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text('ou',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.3),
                                          fontSize: 13)),
                                ),
                                Expanded(
                                    child: Divider(
                                        color: Colors.white.withOpacity(0.1),
                                        thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () => context.go('/auth/register'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.15),
                                      width: 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                ),
                                child: const Text('Créer un compte',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle:
      TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE50914), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}