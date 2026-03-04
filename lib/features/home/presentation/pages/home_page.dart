import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart';
import 'package:reservation_billet_cinema/features/programmation/data/repositories/films_repository.dart';
import 'package:reservation_billet_cinema/features/events/data/repositories/events_repository.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';

/// Page d'accueil : hero, carrousels films/événements (clic → détail direct), ambiance cinéma.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;
  late AnimationController _heroPulseController;
  late PageController _heroPageController;
  Timer? _heroAutoPlayTimer;
  Offset _popcornFabPosition = const Offset(280, 320);
  bool _fabPositionInitialized = false;

  List<Film> _films = [];
  List<Evenement> _events = [];
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController(viewportFraction: 1.0);
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _entranceController.forward();
    _heroPulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _loadData();
  }

  int get _heroItemCount => _films.length + _events.length;

  void _startHeroAutoPlay() {
    _heroAutoPlayTimer?.cancel();
    if (_heroItemCount == 0) return;
    _heroAutoPlayTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final next = (_heroPageController.page?.round() ?? 0) + 1;
      final target = next >= _heroItemCount ? 0 : next;
      _heroPageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadData() async {
    _loadError = null;
    final filmsRepo = ref.read(filmsRepositoryProvider);
    final eventsRepo = ref.read(eventsRepositoryProvider);
    try {
      final films = await filmsRepo.getFilms();
      final events = await eventsRepo.getEvents();
      if (mounted) {
        setState(() {
          _films = films;
          _events = events;
          _loading = false;
          _loadError = null;
        });
        _startHeroAutoPlay();
      }
    } catch (e, st) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Impossible de charger les données. '
              'Démarrez le serveur (port 8090) et appliquez les seeds (server/database/apply_seed.ps1).';
        });
      }
      debugPrint('HomePage _loadData error: $e\n$st');
    }
  }

  @override
  void dispose() {
    _heroAutoPlayTimer?.cancel();
    _entranceController.dispose();
    _heroPulseController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    if (!_fabPositionInitialized && screenSize.width > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_fabPositionInitialized) {
          setState(() {
            _popcornFabPosition = Offset(screenSize.width - 76, screenSize.height * 0.35);
            _fabPositionInitialized = true;
          });
        }
      });
    }
    return Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  _buildAppBar(context),
                ],
                body: AnimatedBuilder(
                  animation: _entranceAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _entranceAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - _entranceAnimation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildHero(context),
                      if (_loadError != null) _buildErrorBanner(context),
                      SliverToBoxAdapter(child: _buildQuickAccess(context)),
                      _buildSectionTitle('Films à l\'affiche'),
                      _buildFilmCarousel(_films),
                      _buildSectionTitle('Événements à venir'),
                      _buildEventCarousel(_events),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
              ),
              _DraggablePopcornFab(
                position: _popcornFabPosition,
                onPositionChanged: (offset) {
                  final w = screenSize.width;
                  final h = screenSize.height;
                  const padding = 56.0;
                  setState(() {
                    _popcornFabPosition = Offset(
                      offset.dx.clamp(padding, w - padding - 56),
                      offset.dy.clamp(padding, h - padding - 120),
                    );
                  });
                },
                onTap: () => Scaffold.of(context).openDrawer(),
              ),
            ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0d0d0d),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, size: 26),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: _NeonAppTitle(text: kAppName),
      centerTitle: true,
    );
  }

  Widget _buildHero(BuildContext context) {
    final hasPosters = !_loading && _heroItemCount > 0;
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _heroPulseController,
        builder: (context, child) {
          final glow = 0.2 + 0.08 * math.sin(_heroPulseController.value * math.pi * 2);
          return Container(
            height: 420,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: AppColors.neon.withValues(alpha: glow),
                  blurRadius: 28,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: AppColors.neon.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fond dégradé rouge / noir (ambiance cinéma)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.4),
                      AppColors.primaryDark.withValues(alpha: 0.3),
                      Colors.black,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            if (!hasPosters)
              _heroPlaceholder()
            else
              PageView.builder(
                controller: _heroPageController,
                itemCount: _heroItemCount,
                itemBuilder: (context, index) {
                  if (index < _films.length) {
                    final film = _films[index];
                    return GestureDetector(
                      onTap: () => context.push('/films/${film.id}'),
                      child: _HeroPosterItem(film: film),
                    );
                  } else {
                    final event = _events[index - _films.length];
                    return GestureDetector(
                      onTap: () => context.push('/events/${event.id}'),
                      child: _HeroEventPosterItem(event: event),
                    );
                  }
                },
              ),
            // Overlay dégradé rouge/noir pour lisibilité du texte
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      AppColors.primaryDark.withValues(alpha: 0.8),
                      Colors.black.withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Billets cinéma & événements',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        AppColors.neon.withValues(alpha: 0.95),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: const Text(
                      'L\'expérience cinéma et vos événements préférés vous attendent.\nRéservez vos billets en quelques secondes — simple et sécurisé.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context) {
    final msg = _loadError!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Material(
          color: AppColors.primary.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.neon, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    msg,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroPlaceholder() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFc41e3a),
              const Color(0xFF8b1529),
              const Color(0xFF2d1515),
            ],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white70),
        ),
      );

  Widget _buildQuickAccess(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _QuickAccessCard(
              icon: Icons.movie_rounded,
              label: 'Films',
              color: AppColors.primary,
              neonBorder: true,
              onTap: () => context.go('/films'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickAccessCard(
              icon: Icons.event_rounded,
              label: 'Événements',
              color: const Color(0xFF2d2d2d),
              neonBorder: true,
              onTap: () => context.go('/events'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickAccessCard(
              icon: Icons.confirmation_number_rounded,
              label: 'Mes billets',
              color: AppColors.accent,
              neonBorder: true,
              onTap: () => context.go('/billets'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, AppColors.neon.withValues(alpha: 0.7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilmCarousel(List<Film> films) {
    if (_loading && films.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 168,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.neon),
          ),
        ),
      );
    }
    if (films.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'Aucun film à l\'affiche',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 265,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1),
              duration: Duration(milliseconds: 400 + (index * 80)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: _FilmCard(
                film: film,
                onTap: () => context.push('/films/${film.id}'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventCarousel(List<Evenement> events) {
    if (_loading && events.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 168,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.neon),
          ),
        ),
      );
    }
    if (events.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'Aucun événement à venir',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 265,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1),
              duration: Duration(milliseconds: 400 + (index * 80)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: _EventCard(
                event: event,
                onTap: () => context.push('/events/${event.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Titre "CinePass" en haut : police distinctive, plus grand, effet néon.
class _NeonAppTitle extends StatelessWidget {
  const _NeonAppTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.orbitron(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.5,
    );
    return Stack(
      children: [
        // Glow néon derrière
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..color = AppColors.neon.withValues(alpha: 0.6)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
          ),
        ),
        // Texte principal avec dégradé néon
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.white,
              AppColors.neon.withValues(alpha: 0.95),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(text, style: style),
        ),
      ],
    );
  }
}

/// Affiche de film pour le carousel hero. Ratio poster cinéma 2:3.
class _HeroPosterItem extends StatelessWidget {
  const _HeroPosterItem({required this.film});

  final Film film;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: film.affiche != null && film.affiche!.isNotEmpty
          ? Container(
              color: const Color(0xFF1a1f2e),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    film.affiche!,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF1a1f2e),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: AppColors.neon,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _placeholder(),
                  ),
                ),
              ),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF1a1f2e),
        child: Center(
          child: Icon(Icons.movie_rounded, color: Colors.white24, size: 64),
        ),
      );
}

/// Affiche d'événement pour le carousel hero.
class _HeroEventPosterItem extends StatelessWidget {
  const _HeroEventPosterItem({required this.event});

  final Evenement event;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: event.affiche != null && event.affiche!.isNotEmpty
          ? Container(
              color: const Color(0xFF1a1f2e),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    event.affiche!,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF1a1f2e),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: AppColors.neon,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _eventPlaceholder(),
                  ),
                ),
              ),
            )
          : _eventPlaceholder(),
    );
  }

  Widget _eventPlaceholder() => Container(
        color: const Color(0xFF1a1f2e),
        child: Center(
          child: Icon(Icons.event_rounded, color: AppColors.accent.withValues(alpha: 0.7), size: 64),
        ),
      );
}

class _QuickAccessCard extends StatefulWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.neonBorder = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool neonBorder;

  @override
  State<_QuickAccessCard> createState() => _QuickAccessCardState();
}

class _QuickAccessCardState extends State<_QuickAccessCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = widget.color == AppColors.accent;
    final fg = isLight ? Colors.black87 : Colors.white;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            border: widget.neonBorder
                ? Border.all(color: AppColors.neon.withValues(alpha: 0.5), width: 1)
                : null,
            boxShadow: widget.neonBorder
                ? [BoxShadow(color: AppColors.neon.withValues(alpha: 0.15), blurRadius: 12, spreadRadius: 0)]
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: fg, size: 32),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilmCard extends StatefulWidget {
  const _FilmCard({required this.film, required this.onTap});

  final Film film;
  final VoidCallback onTap;

  @override
  State<_FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<_FilmCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.film;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: Material(
            color: const Color(0xFF1a1f2e),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.neon.withValues(alpha: 0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neon.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 195,
                    width: 130,
                    child: f.affiche != null && f.affiche!.isNotEmpty
                        ? Image.network(
                            f.affiche!,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) => _filmPlaceholder(),
                          )
                        : _filmPlaceholder(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.titre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (f.genre != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            f.genre!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filmPlaceholder() => Container(
        color: AppColors.primary.withValues(alpha: 0.4),
        child: const Center(child: Icon(Icons.movie_rounded, color: Colors.white38, size: 40)),
      );
}

/// Bouton rond déplaçable avec icône popcorn : un tap ouvre le drawer.
/// FAB déplaçable avec glow néon pulsé.
class _DraggablePopcornFab extends StatefulWidget {
  const _DraggablePopcornFab({
    required this.position,
    required this.onPositionChanged,
    required this.onTap,
  });

  final Offset position;
  final ValueChanged<Offset> onPositionChanged;
  final VoidCallback onTap;

  @override
  State<_DraggablePopcornFab> createState() => _DraggablePopcornFabState();
}

class _DraggablePopcornFabState extends State<_DraggablePopcornFab>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late AnimationController _glowController;

  Offset get _displayPosition => widget.position + _dragOffset;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _displayPosition.dx,
      top: _displayPosition.dy,
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          final glow = 0.15 + 0.12 * math.sin(_glowController.value * math.pi * 2);
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  blurRadius: 14,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.neon.withValues(alpha: glow),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() => _dragOffset += details.delta);
          },
          onPanEnd: (_) {
            widget.onPositionChanged(_displayPosition);
            setState(() => _dragOffset = Offset.zero);
          },
          onTap: widget.onTap,
          child: Material(
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.5),
            shape: const CircleBorder(),
            color: AppColors.primary,
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: const Text('🍿', style: TextStyle(fontSize: 28), textScaler: TextScaler.linear(1.0)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animation de popcorn en arrière-plan dans le hero.
class _PopcornBackgroundAnimation extends StatefulWidget {
  const _PopcornBackgroundAnimation({this.opacity = 1.0});

  final double opacity;

  @override
  State<_PopcornBackgroundAnimation> createState() => _PopcornBackgroundAnimationState();
}

class _PopcornBackgroundAnimationState extends State<_PopcornBackgroundAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  static const _positions = <Offset>[
    Offset(0.1, 0.15),
    Offset(0.25, 0.7),
    Offset(0.5, 0.25),
    Offset(0.7, 0.6),
    Offset(0.85, 0.2),
    Offset(0.15, 0.55),
    Offset(0.4, 0.75),
    Offset(0.6, 0.35),
    Offset(0.9, 0.5),
    Offset(0.3, 0.4),
    Offset(0.75, 0.8),
    Offset(0.05, 0.45),
    Offset(0.55, 0.1),
    Offset(0.2, 0.85),
    Offset(0.8, 0.3),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            return Stack(
              children: List.generate(_positions.length, (i) {
                final pos = _positions[i];
                final bounce = 6 * math.sin((t * math.pi * 2) + (i * 0.5));
                final baseOpacity = 0.2 + 0.25 * math.sin((t * math.pi * 2) + i).abs();
                final opacity = (baseOpacity.clamp(0.0, 1.0) * widget.opacity);
                return Positioned(
                  left: w * pos.dx - 14,
                  top: h * pos.dy - 14 + bounce,
                  child: Opacity(
                    opacity: opacity,
                    child: const Text(
                      '🍿',
                      style: TextStyle(fontSize: 28),
                      textScaler: TextScaler.linear(1.0),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}

/// Carte événement (style similaire aux films, icône événement).
class _EventCard extends StatefulWidget {
  const _EventCard({required this.event, required this.onTap});

  final Evenement event;
  final VoidCallback onTap;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: Material(
            color: const Color(0xFF1a1f2e),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.neon.withValues(alpha: 0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neon.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 195,
                    width: 130,
                    child: e.affiche != null && e.affiche!.isNotEmpty
                        ? Image.network(
                            e.affiche!,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) => _eventPlaceholder(),
                          )
                        : _eventPlaceholder(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.titre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ...[
                          const SizedBox(height: 2),
                          Text(
                            e.lieuDisplay,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventPlaceholder() => Container(
        color: AppColors.accent.withValues(alpha: 0.25),
        child: const Center(child: Icon(Icons.event_rounded, color: AppColors.accent, size: 40)),
      );
}
