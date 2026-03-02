import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with TickerProviderStateMixin {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // 0 = email, 1 = code, 2 = nouveau mot de passe, 3 = succès
  int _step = 0;

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
    ).animate(CurvedAnimation(
        parent: _slideController, curve: Curves.easeOutCubic));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── ÉTAPE 1 : Envoyer le code ────────────────────────────────────────────
  Future<void> _submitEmail() async {
    if (!_emailFormKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .startPasswordReset(_emailController.text.trim());

    if (!mounted) return;
    if (success) {
      setState(() => _step = 1);
      _showSnack(
          'Code envoyé ! Vérifiez les logs du serveur en dev.', isError: false);
    } else {
      _showSnack(ref.read(authProvider).error ?? 'Une erreur est survenue');
    }
  }

  // ── ÉTAPE 2 : Vérifier le code ───────────────────────────────────────────
  Future<void> _submitCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showSnack('Veuillez entrer le code reçu');
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .verifyPasswordResetCode(_codeController.text.trim());

    if (!mounted) return;
    if (success) {
      setState(() => _step = 2);
    } else {
      _showSnack(ref.read(authProvider).error ?? 'Code invalide');
    }
  }

  // ── ÉTAPE 3 : Nouveau mot de passe ───────────────────────────────────────
  Future<void> _submitNewPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .finishPasswordReset(_newPasswordController.text);

    if (!mounted) return;
    if (success) {
      setState(() => _step = 3);
    } else {
      _showSnack(ref.read(authProvider).error ?? 'Une erreur est survenue');
    }
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
        isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
                    color: const Color(0xFFE50914).withOpacity(0.07),
                    width: 1),
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
                      const SizedBox(height: 16),
                      // Back button
                      IconButton(
                        onPressed: () {
                          if (_step > 0 && _step < 3) {
                            setState(() => _step--);
                          } else {
                            context.go('/auth/login');
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white70, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Icon
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFFE50914), Color(0xFFB20710)]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE50914).withOpacity(0.4),
                              blurRadius: 20, offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.lock_reset_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 20),
                      // Titre selon l'étape
                      Text(
                        _step == 0
                            ? 'Mot de passe\noublié ?'
                            : _step == 1
                            ? 'Vérifier\nle code'
                            : _step == 2
                            ? 'Nouveau\nmot de passe'
                            : 'Réinitialisé !',
                        style: const TextStyle(
                          color: Colors.white, fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5, height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _step == 0
                            ? 'Entrez votre email pour recevoir un code.'
                            : _step == 1
                            ? 'Entrez le code affiché dans les logs du serveur.'
                            : _step == 2
                            ? 'Choisissez un nouveau mot de passe sécurisé.'
                            : 'Votre mot de passe a été réinitialisé.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 32),

                      // Indicateur d'étapes
                      if (_step < 3)
                        Row(
                          children: List.generate(3, (i) {
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: i <= _step
                                      ? const Color(0xFFE50914)
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                      const SizedBox(height: 32),

                      // Erreur
                      if (authState.error != null && _step < 3)
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

                      // ── STEP 0 : Email ──────────────────────────────────
                      if (_step == 0)
                        Form(
                          key: _emailFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return 'Email requis';
                                  if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(v))
                                    return 'Email invalide';
                                  return null;
                                },
                                decoration: _inputDecoration(
                                    'Adresse email', Icons.email_outlined),
                              ),
                              const SizedBox(height: 32),
                              _buildButton(
                                label: 'Envoyer le code',
                                isLoading: authState.isLoading,
                                onPressed: _submitEmail,
                              ),
                            ],
                          ),
                        ),

                      // ── STEP 1 : Code ───────────────────────────────────
                      if (_step == 1)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline,
                                      color: Colors.blueAccent, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Le code est visible dans les logs du terminal serveur.',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  letterSpacing: 8,
                                  fontWeight: FontWeight.bold),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                              decoration:
                              _inputDecoration('Code reçu', Icons.lock_outline)
                                  .copyWith(
                                hintText: '00000000',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.2),
                                    fontSize: 24,
                                    letterSpacing: 8),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildButton(
                              label: 'Vérifier le code',
                              isLoading: authState.isLoading,
                              onPressed: _submitCode,
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () {
                                _codeController.clear();
                                ref
                                    .read(authProvider.notifier)
                                    .startPasswordReset(
                                    _emailController.text.trim());
                                _showSnack('Nouveau code envoyé !',
                                    isError: false);
                              },
                              child: Text('Renvoyer le code',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14)),
                            ),
                          ],
                        ),

                      // ── STEP 2 : Nouveau mot de passe ───────────────────
                      if (_step == 2)
                        Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return 'Mot de passe requis';
                                  if (v.length < 8)
                                    return 'Minimum 8 caractères';
                                  return null;
                                },
                                decoration: _inputDecoration(
                                    'Nouveau mot de passe',
                                    Icons.lock_outline_rounded)
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
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirm,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                validator: (v) {
                                  if (v != _newPasswordController.text)
                                    return 'Les mots de passe ne correspondent pas';
                                  return null;
                                },
                                decoration: _inputDecoration(
                                    'Confirmer le mot de passe',
                                    Icons.lock_outline_rounded)
                                    .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white38, size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                    _obscureConfirm = !_obscureConfirm),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildButton(
                                label: 'Réinitialiser le mot de passe',
                                isLoading: authState.isLoading,
                                onPressed: _submitNewPassword,
                              ),
                            ],
                          ),
                        ),

                      // ── STEP 3 : Succès ─────────────────────────────────
                      if (_step == 3)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.3), width: 1),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: Colors.green, size: 56),
                              const SizedBox(height: 16),
                              const Text('Mot de passe réinitialisé !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(
                                'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13, height: 1.5),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => context.go('/auth/login'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE50914),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Se connecter',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const Spacer(),
                      if (_step != 3)
                        Center(
                          child: GestureDetector(
                            onTap: () => context.go('/auth/login'),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back,
                                      color: Colors.white.withOpacity(0.4),
                                      size: 16),
                                  const SizedBox(width: 6),
                                  Text('Retour à la connexion',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 14)),
                                ],
                              ),
                            ),
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

  Widget _buildButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914),
          disabledBackgroundColor: const Color(0xFFE50914).withOpacity(0.5),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5))
            : Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3)),
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