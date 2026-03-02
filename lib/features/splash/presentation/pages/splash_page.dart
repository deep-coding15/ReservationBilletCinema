import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Nom de l'application : court et accrocheur (cinéma + événements).
const String kAppName = 'CinePass';

/// Écran de démarrage : logo animé, son d'ouverture, barre de chargement brillante.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _exitController;
  late Animation<double> _exitAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const Duration _splashDuration = Duration(milliseconds: 4200);
  static const Duration _exitDuration = Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    _playOpeningSound();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: _splashDuration,
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _exitController = AnimationController(
      duration: _exitDuration,
      vsync: this,
    );
    _exitAnimation = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _scaleController.forward();
    _fadeController.forward();
    _progressController.forward();

    Timer(_splashDuration, () {
      if (!mounted) return;
      _exitController.forward().then((_) {
        if (!mounted) return;
        // Après le splash, on va vers l'écran d'authentification (login)
        // avant de laisser l'utilisateur accéder au reste de l'application.
        context.go('/auth/login');
      });
    });
  }

  Future<void> _playOpeningSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/opening.mp3'));
    } catch (_) {
      // Fichier opening.mp3 absent : ajoutez-le dans assets/sounds/ pour le son
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    _shimmerController.dispose();
    _exitController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _exitAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _exitAnimation.value,
          child: child,
        );
      },
      child: Scaffold(
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a0a0a),
              const Color(0xFF2d1515),
              const Color(0xFF1a0a0a),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleController, _fadeController]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFc41e3a).withValues(alpha: 0.5),
                                    blurRadius: 40,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.movie_filter_rounded,
                                size: 100,
                                color: Color(0xFFc41e3a),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFc41e3a),
                                  Color(0xFFe8b923),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                kAppName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Billets cinéma & événements',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.85),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                _ShinyLoadingBar(
                  progressController: _progressController,
                  shimmerController: _shimmerController,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

/// Barre de chargement avec effet brillant (shimmer).
class _ShinyLoadingBar extends StatelessWidget {
  const _ShinyLoadingBar({
    required this.progressController,
    required this.shimmerController,
  });

  final AnimationController progressController;
  final AnimationController shimmerController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([progressController, shimmerController]),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final progressW = w * progressController.value.clamp(0.0, 1.0);
                final shimmerX = progressW * shimmerController.value;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 8,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Fond
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // Remplissage gradient (rouge → or)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: progressW,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFc41e3a),
                                  Color(0xFFe8b923),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Bandeau brillant qui glisse
                        if (progressW > 8)
                          Positioned(
                            left: shimmerX.clamp(0.0, progressW - 24),
                            top: 0,
                            bottom: 0,
                            width: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Chargement...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}
