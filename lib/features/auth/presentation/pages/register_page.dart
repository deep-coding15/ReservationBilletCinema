import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  DateTime? _selectedDate;

  // Étapes du flow inscription
  // 0 = formulaire, 1 = vérification code email
  int _step = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _dateNaissanceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 10, now.month, now.day),
      helpText: 'Date de naissance',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE50914),
              onPrimary: Colors.white,
              surface: Color(0xFF1A1A2E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateNaissanceController.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // ── ÉTAPE 1 : Envoyer le code de vérification ────────────────────────────
  Future<void> _submitStep1() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .startRegistration(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() => _step = 1);
      _showSnack('Code envoyé à ${_emailController.text}', isError: false);
    } else {
      final error = ref.read(authProvider).error;
      _showSnack(error ?? 'Erreur lors de l\'envoi du code');
    }
  }

  // ── ÉTAPE 2 : Vérifier le code ───────────────────────────────────────────
  Future<void> _submitStep2() async {
    if (_codeController.text.trim().isEmpty) {
      _showSnack('Veuillez entrer le code reçu par email');
      return;
    }

    final verified = await ref
        .read(authProvider.notifier)
        .verifyRegistrationCode(_codeController.text.trim());

    if (!mounted) return;
    if (!verified) {
      final error = ref.read(authProvider).error;
      _showSnack(error ?? 'Code invalide');
      return;
    }

    // ── ÉTAPE 3 : Finaliser l'inscription ────────────────────────────────
    final finished = await ref.read(authProvider.notifier).finishRegistration(
      password: _passwordController.text,
      nom: _nomController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _telephoneController.text.trim(),
      dateNaissance: _selectedDate,
    );

    if (!mounted) return;

    if (finished) {
      _showSnack('Compte créé avec succès !', isError: false);
      context.go('/');
    } else {
      final error = ref.read(authProvider).error;
      _showSnack(error ?? 'Erreur lors de la création du compte');
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
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            IconButton(
                              onPressed: () {
                                if (_step == 1) {
                                  setState(() => _step = 0);
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
                            const SizedBox(height: 28),
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
                              child: const Icon(Icons.movie_filter_rounded,
                                  color: Colors.white, size: 28),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _step == 0 ? 'Créer un compte' : 'Vérifier votre email',
                              style: const TextStyle(
                                color: Colors.white, fontSize: 30,
                                fontWeight: FontWeight.w800, letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _step == 0
                                  ? 'Rejoignez-nous pour réserver vos séances'
                                  : 'Entrez le code reçu à ${_emailController.text}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5), fontSize: 14),
                            ),
                            const SizedBox(height: 36),

                            // ── Affichage erreur ──────────────────────────
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

                            // ── STEP 0 : Formulaire ───────────────────────
                            if (_step == 0)
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    _buildField(
                                      controller: _nomController,
                                      label: 'Nom complet',
                                      icon: Icons.person_outline_rounded,
                                      validator: (v) => v == null || v.isEmpty
                                          ? 'Nom requis' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildField(
                                      controller: _emailController,
                                      label: 'Adresse email',
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return 'Email requis';
                                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(v))
                                          return 'Email invalide';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildField(
                                      controller: _telephoneController,
                                      label: 'Téléphone',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return 'Téléphone requis';
                                        if (v.length < 10) return 'Numéro invalide';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDateField(),
                                    const SizedBox(height: 16),
                                    _buildPasswordField(
                                      controller: _passwordController,
                                      label: 'Mot de passe',
                                      obscure: _obscurePassword,
                                      onToggle: () => setState(
                                              () => _obscurePassword = !_obscurePassword),
                                      validator: (v) {
                                        if (v == null || v.isEmpty)
                                          return 'Mot de passe requis';
                                        if (v.length < 8)
                                          return 'Minimum 8 caractères';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildPasswordField(
                                      controller: _confirmPasswordController,
                                      label: 'Confirmer le mot de passe',
                                      obscure: _obscureConfirm,
                                      onToggle: () => setState(
                                              () => _obscureConfirm = !_obscureConfirm),
                                      validator: (v) {
                                        if (v != _passwordController.text)
                                          return 'Les mots de passe ne correspondent pas';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    _buildSubmitButton(
                                      label: "S'inscrire",
                                      isLoading: authState.isLoading,
                                      onPressed: _submitStep1,
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Déjà un compte ? ',
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(0.5),
                                                fontSize: 14)),
                                        GestureDetector(
                                          onTap: () => context.go('/auth/login'),
                                          child: const Text('Se connecter',
                                              style: TextStyle(
                                                  color: Color(0xFFE50914),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                  ],
                                ),
                              ),

                            // ── STEP 1 : Vérification code ─────────────────
                            if (_step == 1)
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.blue.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info_outline,
                                            color: Colors.blueAccent, size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Vérifiez votre boîte email et entrez le code reçu.',
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
                                    decoration: _inputDecoration(
                                        'Code de vérification', Icons.lock_outline)
                                        .copyWith(
                                      hintText: '000000',
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.2),
                                          fontSize: 24,
                                          letterSpacing: 8),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  _buildSubmitButton(
                                    label: 'Vérifier et créer le compte',
                                    isLoading: authState.isLoading,
                                    onPressed: _submitStep2,
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: authState.isLoading
                                        ? null
                                        : () => ref
                                        .read(authProvider.notifier)
                                        .startRegistration(
                                        _emailController.text.trim()),
                                    child: Text(
                                      'Renvoyer le code',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      validator: validator,
      decoration: _inputDecoration(label, icon),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      validator: validator,
      decoration: _inputDecoration(label, Icons.lock_outline_rounded).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.white38, size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateNaissanceController,
      readOnly: true,
      onTap: _selectDate,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      validator: (v) =>
      v == null || v.isEmpty ? 'Date de naissance requise' : null,
      decoration: _inputDecoration('Date de naissance', Icons.cake_outlined)
          .copyWith(
        suffixIcon: const Icon(Icons.calendar_today_outlined,
            color: Colors.white38, size: 18),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white38, size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}