import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:reservation_billet_cinema/core/network/serverpod_provider.dart';

// ============================================================
// PROVIDERS RÉELS
// ============================================================
final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.read(serverpodClientProvider);
  final String jsonResult = await client.adminDashboard.getDashboardStats();
  return jsonDecode(jsonResult);
});

// ============================================================
// PAGE DASHBOARD ADMIN
// ============================================================
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
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

  void _refresh() => ref.refresh(dashboardStatsProvider);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final asyncStats = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF080810),
      body: Row(
        children: [
          if (isWide) _AdminSidebar(expanded: _sidebarExpanded),
          Expanded(
            child: FadeTransition(
              opacity: _entranceAnim,
              child: Column(
                children: [
                  _TopBar(
                    onMenuTap: () => setState(() => _sidebarExpanded = !_sidebarExpanded),
                  ),
                  Expanded(
                    child: asyncStats.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE5193C))),
                      error: (err, _) => Center(child: Text('Erreur: $err', style: const TextStyle(color: Colors.red))),
                      data: (stats) => SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _PeriodSelector(
                              selected: _selectedPeriod,
                              onChanged: (v) => setState(() => _selectedPeriod = v),
                            ),
                            const SizedBox(height: 20),
                            _KpiGrid(period: _selectedPeriod, stats: stats),
                            const SizedBox(height: 24),
                            _buildMainRow(stats),
                            const SizedBox(height: 24),
                            _buildBottomRow(stats),
                          ],
                        ),
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

  Widget _buildMainRow(Map<String, dynamic> stats) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _VentesChart(chartData: stats['graphique'])),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _FilmsPopulaires(films: stats['filmsPopulaires'])),
            ],
          );
        }
        return Column(children: [
          _VentesChart(chartData: stats['graphique']),
          const SizedBox(height: 16),
          _FilmsPopulaires(films: stats['filmsPopulaires']),
        ]);
      },
    );
  }

  Widget _buildBottomRow(Map<String, dynamic> stats) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SeancesJour(seances: stats['seancesJour'])),
              const SizedBox(width: 16),
              const Expanded(flex: 2, child: _ActivitesStatiques()),
            ],
          );
        }
        return Column(children: [
          _SeancesJour(seances: stats['seancesJour']),
          const SizedBox(height: 16),
          const _ActivitesStatiques(),
        ]);
      },
    );
  }
}

// ============================================================
// WIDGETS KPI
// ============================================================
class _KpiGrid extends StatelessWidget {
  final int period;
  final Map<String, dynamic> stats;
  const _KpiGrid({required this.period, required this.stats});

  @override
  Widget build(BuildContext context) {
    final revenus = stats['revenus'];
    final counts = stats['counts'];
    
    double montant = 0;
    String sub = "";
    if (period == 0) { montant = (revenus['jour'] as num).toDouble(); sub = "Aujourd'hui"; }
    else if (period == 1) { montant = (revenus['semaine'] as num).toDouble(); sub = "7 derniers jours"; }
    else { montant = (revenus['mois'] as num).toDouble(); sub = "Mois en cours"; }

    final kpis = [
      _KpiData(label: 'Revenus', value: '${montant.toStringAsFixed(0)} MAD', subtitle: sub, icon: Icons.payments_outlined, color: const Color(0xFF4ADE80)),
      _KpiData(label: 'Billets today', value: revenus['billetsJour'].toString(), subtitle: 'Confirmés', icon: Icons.confirmation_number_outlined, color: const Color(0xFF60A5FA)),
      _KpiData(label: 'Utilisateurs', value: counts['utilisateurs'].toString(), subtitle: 'Inscrits total', icon: Icons.people_outline, color: const Color(0xFFA78BFA)),
      _KpiData(label: 'Films actifs', value: counts['filmsActifs'].toString(), subtitle: 'En affiche', icon: Icons.movie_outlined, color: const Color(0xFFE5193C)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: kpis.length,
      itemBuilder: (ctx, i) => _KpiCard(data: kpis[i]),
    );
  }
}

class _KpiData {
  final String label, value, subtitle;
  final IconData icon;
  final Color color;
  const _KpiData({required this.label, required this.value, required this.subtitle, required this.icon, required this.color});
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF0D0D1A), borderRadius: BorderRadius.circular(16), border: Border.all(color: data.color.withOpacity(0.15))),
    child: Row(children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: data.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(data.icon, color: data.color, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(data.label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
        Text(data.value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        Text(data.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10)),
      ])),
    ]),
  );
}

// ============================================================
// CHART
// ============================================================
class _VentesChart extends StatelessWidget {
  final List<dynamic> chartData;
  const _VentesChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) return const SizedBox(height: 200, child: Center(child: Text("Pas de données", style: TextStyle(color: Colors.white24))));
    
    final maxVal = chartData.map((d) => (d['montant'] as num).toDouble()).reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0D0D1A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1A1A2E))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Ventes — 7 derniers jours', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        SizedBox(height: 160, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: chartData.map((d) {
          final val = (d['montant'] as num).toDouble();
          final ratio = maxVal > 0 ? val / maxVal : 0.0;
          return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Flexible(child: FractionallySizedBox(heightFactor: ratio.clamp(0.05, 1.0), child: Container(decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFE5193C), Color(0xFF1A1A2E)]), borderRadius: BorderRadius.circular(4))))),
            const SizedBox(height: 8),
            Text(d['jour'], style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
          ])));
        }).toList())),
      ]),
    );
  }
}

// ============================================================
// FILMS POPULAIRES
// ============================================================
class _FilmsPopulaires extends StatelessWidget {
  final List<dynamic> films;
  const _FilmsPopulaires({required this.films});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0D0D1A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1A1A2E))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Films populaires', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        if (films.isEmpty) const Text("Aucune vente", style: TextStyle(color: Colors.white24, fontSize: 12)),
        ...films.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            Expanded(child: Text(f['titre'], style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
            Text('${f['billets']} billets', style: const TextStyle(color: Color(0xFFE5193C), fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
        )),
      ]),
    );
  }
}

// ============================================================
// SÉANCES JOUR
// ============================================================
class _SeancesJour extends StatelessWidget {
  final List<dynamic> seances;
  const _SeancesJour({required this.seances});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0D0D1A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1A1A2E))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Séances du jour", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        if (seances.isEmpty) const Text("Aucune séance aujourd'hui", style: TextStyle(color: Colors.white24, fontSize: 12)),
        ...seances.take(5).map((s) {
          final vendus = (s['places'] as num).toInt();
          final total = (s['total'] as num).toInt();
          final taux = total > 0 ? (vendus / total) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Expanded(flex: 3, child: Text(s['film'], style: const TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 1, child: Text(s['heure'], style: const TextStyle(color: Colors.white54, fontSize: 11))),
              Expanded(flex: 2, child: LinearProgressIndicator(value: taux, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation(Color(0xFFE5193C)), minHeight: 4)),
            ]),
          );
        }),
      ]),
    );
  }
}

// ============================================================
// SIDEBAR
// ============================================================
class _AdminSidebar extends StatelessWidget {
  final bool expanded;
  const _AdminSidebar({required this.expanded});
  @override
  Widget build(BuildContext context) {
    final w = expanded ? 220.0 : 64.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250), width: w,
      decoration: const BoxDecoration(color: Color(0xFF0D0D1A), border: Border(right: BorderSide(color: Color(0xFF1A1A2E)))),
      child: Column(children: [
        Container(height: 64, padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFE5193C), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.movie_filter_rounded, color: Colors.white, size: 18)),
          if (expanded) const Padding(padding: EdgeInsets.only(left: 10), child: Text('CinePass', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800))),
        ])),
        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 8), children: [
          _SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/admin/dashboard', expanded: expanded, active: true),
          _SidebarItem(icon: Icons.movie_creation_outlined, label: 'Films', route: '/admin/films', expanded: expanded),
          _SidebarItem(icon: Icons.event_rounded, label: 'Séances', route: '/admin/seances', expanded: expanded),
          _SidebarItem(icon: Icons.weekend_outlined, label: 'Salles', route: '/admin/salles', expanded: expanded),
          _SidebarItem(icon: Icons.confirmation_number_outlined, label: 'Réservations', route: '/admin/reservations', expanded: expanded),
          _SidebarItem(icon: Icons.people_outline, label: 'Utilisateurs', route: '/admin/users', expanded: expanded),
          
          const Divider(color: Colors.white10, height: 20),
          
          // Nouveaux boutons pour implémentation future
          _SidebarItem(icon: Icons.local_offer_outlined, label: 'Promotions', route: '/admin/promos', expanded: expanded),
          _SidebarItem(icon: Icons.bar_chart_rounded, label: 'Rapports', route: '/admin/rapports', expanded: expanded),
          _SidebarItem(icon: Icons.support_agent_outlined, label: 'Support Client', route: '/admin/support', expanded: expanded),
          
          const Spacer(),
          const Divider(color: Colors.white10, height: 20),
          
          // Bouton pour revenir à l'application
          _SidebarItem(icon: Icons.exit_to_app_rounded, label: 'Retour App', route: '/', expanded: expanded),
          const SizedBox(height: 10),
        ])),
      ]),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon; final String label, route; final bool expanded, active;
  const _SidebarItem({required this.icon, required this.label, required this.route, required this.expanded, this.active = false});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 2), decoration: BoxDecoration(color: active ? const Color(0xFFE5193C).withOpacity(0.15) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
    child: InkWell(onTap: () => context.go(route), borderRadius: BorderRadius.circular(10), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Row(children: [
      Icon(icon, size: 20, color: active ? const Color(0xFFE5193C) : Colors.white.withOpacity(0.5)),
      if (expanded) Padding(padding: const EdgeInsets.only(left: 10), child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.white.withOpacity(0.6), fontSize: 13))),
    ]))),
  );
}

class _TopBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  const _TopBar({required this.onMenuTap});
  @override
  Widget build(BuildContext context) => Container(
    height: 64, padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: const BoxDecoration(color: Color(0xFF0D0D1A), border: Border(bottom: BorderSide(color: Color(0xFF1A1A2E)))),
    child: Row(children: [
      IconButton(icon: const Icon(Icons.menu_rounded, color: Colors.white54), onPressed: onMenuTap),
      const Text('Tableau de bord', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
      const Spacer(),
      const Icon(Icons.notifications_outlined, color: Colors.white54),
    ]),
  );
}

class _PeriodSelector extends StatelessWidget {
  final int selected; final ValueChanged<int> onChanged;
  const _PeriodSelector({required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Expanded(child: Text('Vue d\'ensemble', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
    Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(12)), child: Row(children: [
      _PeriodBtn(label: "Jour", index: 0, selected: selected, onTap: onChanged),
      _PeriodBtn(label: 'Semaine', index: 1, selected: selected, onTap: onChanged),
      _PeriodBtn(label: 'Mois', index: 2, selected: selected, onTap: onChanged),
    ])),
  ]);
}

class _PeriodBtn extends StatelessWidget {
  final String label; final int index, selected; final ValueChanged<int> onTap;
  const _PeriodBtn({required this.label, required this.index, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () => onTap(index), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: index == selected ? const Color(0xFFE5193C) : Colors.transparent, borderRadius: BorderRadius.circular(8)), child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))));
}

class _ActivitesStatiques extends StatelessWidget {
  const _ActivitesStatiques();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF0D0D1A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1A1A2E))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Dernières ventes', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 16),
      _actItem(Icons.confirmation_number_outlined, "Nouvelle réservation", "Il y a 5 min", Colors.blue),
      _actItem(Icons.payments_outlined, "Paiement reçu", "Il y a 12 min", Colors.green),
      _actItem(Icons.person_add_outlined, "Nouvel inscrit", "Il y a 40 min", Colors.purple),
    ]),
  );
  Widget _actItem(IconData icon, String msg, String time, Color col) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
    Icon(icon, size: 16, color: col), const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(msg, style: const TextStyle(color: Colors.white, fontSize: 12)), Text(time, style: const TextStyle(color: Colors.white24, fontSize: 10))])),
  ]));
}
