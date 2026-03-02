import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ============================================================
// DONNÉES MOCKÉES DASHBOARD
// ============================================================
class _DashboardData {
  // Ventes
  static const double ventesAujourdhui = 12450.0;
  static const double ventesSemaine = 78300.0;
  static const double ventesMois = 284500.0;
  static const int billetsVendusAujourdhui = 87;
  static const int billetsVendusMois = 1243;

  // Taux de remplissage
  static const double tauxRemplissageMoyen = 73.4;

  // Utilisateurs
  static const int totalUtilisateurs = 3847;
  static const int nouveauxCeMois = 142;

  // Films actifs
  static const int filmsEnAffiche = 8;
  static const int seancesAujourdhui = 24;

  // Graphique ventes 7 derniers jours
  static const List<Map<String, dynamic>> ventesHebdo = [
    {'jour': 'Lun', 'montant': 9200.0, 'billets': 64},
    {'jour': 'Mar', 'montant': 11400.0, 'billets': 79},
    {'jour': 'Mer', 'montant': 8700.0, 'billets': 61},
    {'jour': 'Jeu', 'montant': 13200.0, 'billets': 92},
    {'jour': 'Ven', 'montant': 18500.0, 'billets': 128},
    {'jour': 'Sam', 'montant': 22100.0, 'billets': 154},
    {'jour': 'Dim', 'montant': 12450.0, 'billets': 87},
  ];

  // Films populaires
  static const List<Map<String, dynamic>> filmsPopulaires = [
    {'titre': 'Dune: Deuxième Partie', 'billets': 342, 'taux': 89.0, 'recette': 48230.0},
    {'titre': 'Oppenheimer', 'billets': 287, 'taux': 76.0, 'recette': 38450.0},
    {'titre': 'Le Comte de Monte-Cristo', 'billets': 241, 'taux': 68.0, 'recette': 31820.0},
    {'titre': 'Avatar 3', 'billets': 198, 'taux': 54.0, 'recette': 28900.0},
    {'titre': 'Gladiator 2', 'billets': 175, 'taux': 48.0, 'recette': 24500.0},
  ];

  // Séances du jour
  static const List<Map<String, dynamic>> seancesJour = [
    {'film': 'Dune 2', 'heure': '10h00', 'salle': 'Salle 1', 'places': 45, 'total': 120, 'taux': 37.5},
    {'film': 'Oppenheimer', 'heure': '12h30', 'salle': 'Salle 2', 'places': 98, 'total': 110, 'taux': 89.1},
    {'film': 'Monte-Cristo', 'heure': '14h00', 'salle': 'Salle VIP', 'places': 28, 'total': 30, 'taux': 93.3},
    {'film': 'Dune 2', 'heure': '16h30', 'salle': 'Salle 1', 'places': 67, 'total': 120, 'taux': 55.8},
    {'film': 'Avatar 3', 'heure': '19h00', 'salle': 'IMAX', 'places': 112, 'total': 150, 'taux': 74.7},
    {'film': 'Gladiator 2', 'heure': '21h30', 'salle': 'Salle 3', 'places': 88, 'total': 100, 'taux': 88.0},
  ];

  // Activités récentes
  static const List<Map<String, dynamic>> activitesRecentes = [
    {'type': 'reservation', 'message': 'Nouvelle réservation — Dune 2 · 2 billets', 'temps': 'Il y a 3 min', 'icon': 'ticket'},
    {'type': 'paiement', 'message': 'Paiement reçu — 84,00 MAD', 'temps': 'Il y a 8 min', 'icon': 'payment'},
    {'type': 'annulation', 'message': 'Annulation — Oppenheimer · 1 billet', 'temps': 'Il y a 15 min', 'icon': 'cancel'},
    {'type': 'inscription', 'message': 'Nouvel utilisateur inscrit', 'temps': 'Il y a 22 min', 'icon': 'user'},
    {'type': 'reservation', 'message': 'Nouvelle réservation — Monte-Cristo · 4 billets', 'temps': 'Il y a 31 min', 'icon': 'ticket'},
    {'type': 'support', 'message': 'Nouvelle demande de support #1247', 'temps': 'Il y a 45 min', 'icon': 'support'},
  ];
}

// ============================================================
// PAGE DASHBOARD ADMIN
// ============================================================
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late Animation<double> _entranceAnim;
  int _selectedPeriod = 2; // 0=jour, 1=semaine, 2=mois
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _entranceAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOutCubic,
    );
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────────
          if (isWide) _AdminSidebar(expanded: _sidebarExpanded),

          // ── Main content ────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _entranceAnim,
              child: Column(
                children: [
                  _TopBar(
                    onMenuTap: () =>
                        setState(() => _sidebarExpanded = !_sidebarExpanded),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Période selector
                          _PeriodSelector(
                            selected: _selectedPeriod,
                            onChanged: (v) =>
                                setState(() => _selectedPeriod = v),
                          ),
                          const SizedBox(height: 20),
                          // KPI Cards
                          _KpiGrid(period: _selectedPeriod),
                          const SizedBox(height: 24),
                          // Graphique + Films populaires
                          _buildMainRow(),
                          const SizedBox(height: 24),
                          // Séances du jour + Activités
                          _buildBottomRow(),
                        ],
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

  Widget _buildMainRow() {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _VentesChart()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _FilmsPopulaires()),
            ],
          );
        }
        return Column(children: [
          _VentesChart(),
          const SizedBox(height: 16),
          _FilmsPopulaires(),
        ]);
      },
    );
  }

  Widget _buildBottomRow() {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SeancesJour()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _ActivitesRecentes()),
            ],
          );
        }
        return Column(children: [
          _SeancesJour(),
          const SizedBox(height: 16),
          _ActivitesRecentes(),
        ]);
      },
    );
  }
}

// ============================================================
// SIDEBAR ADMIN
// ============================================================
class _AdminSidebar extends StatelessWidget {
  final bool expanded;
  const _AdminSidebar({required this.expanded});

  @override
  Widget build(BuildContext context) {
    final w = expanded ? 220.0 : 64.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: w,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D1A),
        border: Border(right: BorderSide(color: Color(0xFF1A1A2E))),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5193C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.movie_filter_rounded,
                      color: Colors.white, size: 18),
                ),
                if (expanded) ...[
                  const SizedBox(width: 10),
                  const Text(
                    'CinePass',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5193C).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Admin',
                        style: TextStyle(
                            color: Color(0xFFE5193C),
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Color(0xFF1A1A2E), height: 1),
          const SizedBox(height: 8),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  route: '/admin/dashboard',
                  expanded: expanded,
                  active: true,
                ),
                _SidebarItem(
                  icon: Icons.movie_creation_outlined,
                  label: 'Films',
                  route: '/admin/films',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.event_rounded,
                  label: 'Séances',
                  route: '/admin/seances',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.weekend_outlined,
                  label: 'Salles',
                  route: '/admin/salles',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Réservations',
                  route: '/admin/reservations',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.people_outline,
                  label: 'Utilisateurs',
                  route: '/admin/users',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.local_offer_outlined,
                  label: 'Promotions',
                  route: '/admin/promos',
                  expanded: expanded,
                ),
                const SizedBox(height: 8),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text('RAPPORTS',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2)),
                  ),
                _SidebarItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Rapports',
                  route: '/admin/rapports',
                  expanded: expanded,
                ),
                _SidebarItem(
                  icon: Icons.support_agent_outlined,
                  label: 'Support',
                  route: '/admin/support',
                  expanded: expanded,
                ),
              ],
            ),
          ),

          // Bottom
          const Divider(color: Color(0xFF1A1A2E), height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _SidebarItem(
              icon: Icons.home_outlined,
              label: 'Retour app',
              route: '/',
              expanded: expanded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool expanded;
  final bool active;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.expanded,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFE5193C).withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon,
                  size: 20,
                  color: active
                      ? const Color(0xFFE5193C)
                      : Colors.white.withOpacity(0.5)),
              if (expanded) ...[
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight:
                    active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TOP BAR
// ============================================================
class _TopBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _TopBar({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    final dateStr = '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]} ${now.year}';

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D1A),
        border: Border(bottom: BorderSide(color: Color(0xFF1A1A2E))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white54),
            onPressed: onMenuTap,
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tableau de bord',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              Text(dateStr,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 12)),
            ],
          ),
          const Spacer(),
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white54),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5193C),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Avatar admin
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5193C),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('A',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Admin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PERIOD SELECTOR
// ============================================================
class _PeriodSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _PeriodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vue d\'ensemble',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                'Statistiques et performances en temps réel',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _PeriodBtn(label: "Aujourd'hui", index: 0, selected: selected, onTap: onChanged),
              _PeriodBtn(label: 'Semaine', index: 1, selected: selected, onTap: onChanged),
              _PeriodBtn(label: 'Mois', index: 2, selected: selected, onTap: onChanged),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodBtn extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;
  const _PeriodBtn({required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE5193C) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// KPI CARDS GRID
// ============================================================
class _KpiGrid extends StatelessWidget {
  final int period;
  const _KpiGrid({required this.period});

  @override
  Widget build(BuildContext context) {
    final montant = period == 0
        ? _DashboardData.ventesAujourdhui
        : period == 1
        ? _DashboardData.ventesSemaine
        : _DashboardData.ventesMois;

    final billets = period == 0
        ? _DashboardData.billetsVendusAujourdhui
        : period == 2
        ? _DashboardData.billetsVendusMois
        : 612;

    final kpis = [
      _KpiData(
        label: 'Revenus',
        value: '${_formatMontant(montant)} MAD',
        subtitle: period == 0 ? 'Aujourd\'hui' : period == 1 ? 'Cette semaine' : 'Ce mois',
        icon: Icons.payments_outlined,
        color: const Color(0xFF4ADE80),
        trend: '+12.4%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Billets vendus',
        value: billets.toString(),
        subtitle: 'Réservations confirmées',
        icon: Icons.confirmation_number_outlined,
        color: const Color(0xFF60A5FA),
        trend: '+8.7%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Taux remplissage',
        value: '${_DashboardData.tauxRemplissageMoyen}%',
        subtitle: 'Moyenne toutes salles',
        icon: Icons.event_seat_outlined,
        color: const Color(0xFFF59E0B),
        trend: '+3.2%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Utilisateurs',
        value: _formatNombre(_DashboardData.totalUtilisateurs),
        subtitle: '+${_DashboardData.nouveauxCeMois} ce mois',
        icon: Icons.people_outline,
        color: const Color(0xFFA78BFA),
        trend: '+5.1%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Films en affiche',
        value: _DashboardData.filmsEnAffiche.toString(),
        subtitle: 'Films actifs',
        icon: Icons.movie_outlined,
        color: const Color(0xFFE5193C),
        trend: '2 nouveaux',
        trendUp: true,
      ),
      _KpiData(
        label: 'Séances today',
        value: _DashboardData.seancesAujourdhui.toString(),
        subtitle: 'Séances programmées',
        icon: Icons.schedule_outlined,
        color: const Color(0xFF34D399),
        trend: 'Normal',
        trendUp: true,
      ),
    ];

    return LayoutBuilder(
      builder: (ctx, constraints) {
        int crossAxisCount = constraints.maxWidth > 900
            ? 3
            : constraints.maxWidth > 600
            ? 2
            : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: kpis.length,
          itemBuilder: (ctx, i) => _KpiCard(data: kpis[i]),
        );
      },
    );
  }

  String _formatMontant(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  String _formatNombre(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toString();
  }
}

class _KpiData {
  final String label, value, subtitle, trend;
  final IconData icon;
  final Color color;
  final bool trendUp;
  const _KpiData({
    required this.label, required this.value, required this.subtitle,
    required this.icon, required this.color, required this.trend,
    required this.trendUp,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.label,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12)),
                const SizedBox(height: 2),
                Text(data.value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(data.subtitle,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (data.trendUp ? Colors.green : Colors.red)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data.trend,
                        style: TextStyle(
                          color: data.trendUp
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GRAPHIQUE VENTES
// ============================================================
class _VentesChart extends StatelessWidget {
  const _VentesChart();

  @override
  Widget build(BuildContext context) {
    final data = _DashboardData.ventesHebdo;
    final maxVal = data.map((d) => d['montant'] as double).reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Ventes — 7 derniers jours',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              _ChartLegend(color: const Color(0xFFE5193C), label: 'Revenus (MAD)'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final ratio = (d['montant'] as double) / maxVal;
                final isMax = (d['montant'] as double) == maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isMax)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5193C),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${((d['montant'] as double) / 1000).toStringAsFixed(1)}K',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: ratio,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isMax
                                      ? [const Color(0xFFE5193C), const Color(0xFF8B0E21)]
                                      : [const Color(0xFF2A2A4E), const Color(0xFF1A1A2E)],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(d['jour'] as String,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      ],
    );
  }
}

// ============================================================
// FILMS POPULAIRES
// ============================================================
class _FilmsPopulaires extends StatelessWidget {
  const _FilmsPopulaires();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Films populaires',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/admin/films'),
                child: Text('Voir tout',
                    style: TextStyle(color: const Color(0xFFE5193C), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._DashboardData.filmsPopulaires.asMap().entries.map((entry) {
            final i = entry.key;
            final film = entry.value;
            final taux = film['taux'] as double;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? const Color(0xFFE5193C).withOpacity(0.2)
                          : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: TextStyle(
                              color: i == 0 ? const Color(0xFFE5193C) : Colors.white54,
                              fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(film['titre'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: taux / 100,
                                  backgroundColor: const Color(0xFF1A1A2E),
                                  valueColor: AlwaysStoppedAnimation(
                                    taux > 75 ? const Color(0xFF4ADE80) : const Color(0xFF60A5FA),
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${taux.toStringAsFixed(0)}%',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${film['billets']}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
// SÉANCES DU JOUR
// ============================================================
class _SeancesJour extends StatelessWidget {
  const _SeancesJour();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Séances d'aujourd'hui",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/admin/seances'),
                child: Text('Gérer',
                    style: TextStyle(color: const Color(0xFFE5193C), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                _TableHeader('Film', flex: 3),
                _TableHeader('Heure', flex: 2),
                _TableHeader('Salle', flex: 2),
                _TableHeader('Remplissage', flex: 3),
              ],
            ),
          ),
          const Divider(color: Color(0xFF1A1A2E), height: 1),
          const SizedBox(height: 8),
          ..._DashboardData.seancesJour.map((s) {
            final taux = s['taux'] as double;
            Color tauxColor = taux > 80
                ? const Color(0xFF4ADE80)
                : taux > 50
                ? const Color(0xFFF59E0B)
                : Colors.red.shade400;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(s['film'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(s['heure'] as String,
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(s['salle'] as String,
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: taux / 100,
                              backgroundColor: const Color(0xFF1A1A2E),
                              valueColor: AlwaysStoppedAnimation(tauxColor),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('${taux.toStringAsFixed(0)}%',
                            style: TextStyle(color: tauxColor, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;
  const _TableHeader(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(text,
          style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5)),
    );
  }
}

// ============================================================
// ACTIVITÉS RÉCENTES
// ============================================================
class _ActivitesRecentes extends StatelessWidget {
  const _ActivitesRecentes();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activité récente',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ..._DashboardData.activitesRecentes.map((a) {
            final type = a['type'] as String;
            Color color;
            IconData icon;
            switch (type) {
              case 'reservation': color = const Color(0xFF60A5FA); icon = Icons.confirmation_number_outlined; break;
              case 'paiement': color = const Color(0xFF4ADE80); icon = Icons.payments_outlined; break;
              case 'annulation': color = Colors.red.shade400; icon = Icons.cancel_outlined; break;
              case 'inscription': color = const Color(0xFFA78BFA); icon = Icons.person_add_outlined; break;
              case 'support': color = const Color(0xFFF59E0B); icon = Icons.support_agent_outlined; break;
              default: color = Colors.white54; icon = Icons.info_outline;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['message'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(a['temps'] as String,
                            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}