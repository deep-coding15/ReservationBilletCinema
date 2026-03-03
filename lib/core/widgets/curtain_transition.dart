import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart' show kAppName;

/// Animation de transition puzzle : les morceaux s'assemblent pour former « CinePass »
/// puis disparaissent pour révéler la page.
class CurtainRevealTransition extends StatefulWidget {
  const CurtainRevealTransition({
    super.key,
    required this.child,
    required this.path,
  });

  final Widget child;
  final String path;

  /// Chemins qui déclenchent l'animation (onglets principaux uniquement).
  static bool useCurtainForPath(String path) {
    final p = path.replaceAll(RegExp(r'/+$'), '');
    if (p.isEmpty || p == '/') return true;
    return p == '/films' || p == '/events' || p == '/billets' || p == '/profil';
  }

  @override
  State<CurtainRevealTransition> createState() => _CurtainRevealTransitionState();
}

class _CurtainRevealTransitionState extends State<CurtainRevealTransition>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _assembleAnim;
  late Animation<double> _holdAnim;
  late Animation<double> _revealAnim;

  static const Duration _duration = Duration(milliseconds: 650);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this);
    _assembleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _holdAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.65, curve: Curves.linear),
      ),
    );
    _revealAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1, curve: Curves.easeInCubic),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => Opacity(
            opacity: _revealAnim.value,
            child: widget.child,
          ),
        ),
        IgnorePointer(
          ignoring: _controller.value >= 1,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return _PuzzleOverlay(
                appName: kAppName,
                assembleProgress: _assembleAnim.value,
                holdProgress: _holdAnim.value,
                revealProgress: _revealAnim.value,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PuzzleOverlay extends StatelessWidget {
  const _PuzzleOverlay({
    required this.appName,
    required this.assembleProgress,
    required this.holdProgress,
    required this.revealProgress,
  });

  final String appName;
  final double assembleProgress;
  final double holdProgress;
  final double revealProgress;

  @override
  Widget build(BuildContext context) {
    if (revealProgress >= 1) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    final letters = appName.split('');
    const letterSpacing = 4.0;
    const fontSize = 36.0;
    final style = GoogleFonts.orbitron(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
    );

    final logoProgress = Curves.easeOutBack.transform(
      (assembleProgress * 1.2).clamp(0.0, 1.0),
    );
    final logoOpacity = 1.0 - revealProgress;

    return Container(
      color: const Color(0xFF0a0a0d),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: logoProgress * logoOpacity,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(Icons.movie_filter_rounded, color: AppColors.accent, size: 36),
              ),
            ),
            ...List.generate(letters.length, (i) {
            final delay = (i / letters.length) * 0.65;
            final t = ((assembleProgress - delay) / (1 - delay)).clamp(0.0, 1.0);
            final assemble = Curves.easeOutBack.transform(t);
            final scale = assemble;
            final opacity = 1.0 - revealProgress;
            final fromY = (i % 3 == 0) ? -40.0 : (i % 3 == 1) ? 40.0 : -20.0;
            final yOffset = fromY * (1 - assemble);

            return Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : letterSpacing / 2,
                right: i == letters.length - 1 ? 0 : letterSpacing / 2,
              ),
              child: Transform.translate(
                offset: Offset(0, yOffset),
                child: Transform.scale(
                  scale: scale * opacity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.neon.withValues(alpha: 0.4),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neon.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        AppColors.neon.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                      child: Text(
                        letters[i],
                        style: style.copyWith(
                          shadows: [
                            Shadow(
                              color: AppColors.neon.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          ],
        ),
      ),
    );
  }
}
