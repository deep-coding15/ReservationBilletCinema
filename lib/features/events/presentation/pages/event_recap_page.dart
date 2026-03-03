import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/reservation/data/models/recap_data.dart';

/// Récap réservation ÉVÉNEMENT : un type + options par billet (même logique que cinéma).
class EventRecapPage extends StatefulWidget {
  const EventRecapPage({super.key, this.recapData});

  final EventRecapData? recapData;

  @override
  State<EventRecapPage> createState() => _EventRecapPageState();
}

class _EventRecapPageState extends State<EventRecapPage> {
  late List<TicketLine> _lines;

  @override
  void initState() {
    super.initState();
    _lines = widget.recapData != null
        ? widget.recapData!.lines.map((l) => TicketLine(typeBillet: l.typeBillet, options: List.from(l.options))).toList()
        : [];
  }

  void _updateLine(int index, TicketLine line) {
    setState(() {
      if (index >= 0 && index < _lines.length) _lines[index] = line;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.recapData;
    if (data == null || data.numberOfTickets == 0) {
      return Scaffold(
        backgroundColor: const Color(0xFF0d0d0d),
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
          title: const Text('Récapitulatif'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Données manquantes.', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    if (_lines.length != data.numberOfTickets) {
      _lines = List.generate(data.numberOfTickets, (_) => const TicketLine());
    }

    final totalData = EventRecapData(
      eventId: data.eventId,
      titre: data.titre,
      prixUnitaire: data.prixUnitaire,
      placesDisponibles: data.placesDisponibles,
      numberOfTickets: data.numberOfTickets,
      lines: _lines,
    );
    final total = totalData.total;

    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: const Text('Récapitulatif — type & options par billet'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF1f1f1f),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.titre, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '${data.prixUnitaire.toStringAsFixed(0)} DH / billet • ${data.numberOfTickets} billet(s)',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choisir le type et les options pour chaque billet',
              style: TextStyle(color: AppColors.neon, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...List.generate(_lines.length, (i) {
              return _EventBilletCard(
                billetNum: i + 1,
                line: _lines[i],
                basePrix: data.prixUnitaire,
                onChanged: (l) => _updateLine(i, l),
              );
            }),
            const SizedBox(height: 24),
            Card(
              color: AppColors.neon.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.neon),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      '${total.toStringAsFixed(0)} DH',
                      style: const TextStyle(color: AppColors.neon, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final payload = data.copyWith(lines: _lines);
                  context.push('/reservation-event/paiement', extra: payload);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.neon,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Procéder au paiement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventBilletCard extends StatelessWidget {
  const _EventBilletCard({
    required this.billetNum,
    required this.line,
    required this.basePrix,
    required this.onChanged,
  });

  final int billetNum;
  final TicketLine line;
  final double basePrix;
  final void Function(TicketLine) onChanged;

  @override
  Widget build(BuildContext context) {
    final opts = line.typeBillet == 'VIP' ? TicketLine.vipIncludedOptions : line.options;
    final lineTotal = basePrix * TicketLine.modifierFor(line.typeBillet) +
        opts.fold<double>(0, (s, o) => s + (kOptionPrices[o] ?? 0));

    return Card(
      color: const Color(0xFF252525),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Billet $billetNum', style: const TextStyle(color: AppColors.neon, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${lineTotal.toStringAsFixed(0)} DH', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Type de billet', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: TicketLine.typeNames.map((t) {
                final selected = line.typeBillet == t;
                return ChoiceChip(
                  label: Text(t, style: TextStyle(color: selected ? Colors.black87 : Colors.white70, fontSize: 12)),
                  selected: selected,
                  onSelected: (_) {
                    final newOpts = t == 'VIP' ? List<String>.from(TicketLine.vipIncludedOptions) : <String>[];
                    onChanged(line.copyWith(typeBillet: t, options: newOpts));
                  },
                  selectedColor: AppColors.neon,
                  backgroundColor: const Color(0xFF1f1f1f),
                  side: BorderSide(color: selected ? AppColors.neon : Colors.white24),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              line.typeBillet == 'VIP' ? 'Options incluses (VIP)' : 'Options supplémentaires',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: kOptionPrices.keys.map((name) {
                final price = kOptionPrices[name] ?? 0;
                final effectiveOpts = line.typeBillet == 'VIP' ? TicketLine.vipIncludedOptions : line.options;
                final selected = effectiveOpts.contains(name);
                return FilterChip(
                  label: Text('$name +${price.toStringAsFixed(0)} DH', style: const TextStyle(fontSize: 11)),
                  selected: selected,
                  onSelected: line.typeBillet == 'VIP' ? null : (v) {
                    final opts = List<String>.from(line.options);
                    if (v) opts.add(name); else opts.remove(name);
                    onChanged(line.copyWith(options: opts));
                  },
                  selectedColor: AppColors.neon.withValues(alpha: 0.4),
                  backgroundColor: const Color(0xFF1f1f1f),
                  checkmarkColor: Colors.black87,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
