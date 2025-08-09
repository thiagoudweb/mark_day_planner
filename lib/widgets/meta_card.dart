import 'package:flutter/material.dart';
import '../models/meta.dart';
import '../models/enums.dart';

class MetaCard extends StatelessWidget {
  final Meta meta;
  final VoidCallback? onTap;

  const MetaCard({super.key, required this.meta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final catColor = _corDaCategoria(meta.categoria);
    final statusChip = _statusChip(meta.status, context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 56,
                margin: const EdgeInsets.only(right: 12, top: 4),
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            meta.titulo,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        statusChip,
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (meta.descricao.trim().isNotEmpty)
                      Text(
                        meta.descricao,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: -6,
                      children: [
                        _infoPill(
                          icon: Icons.calendar_today_outlined,
                          label: meta.periodo.label,
                          context: context,
                        ),
                        _infoPill(
                          icon: Icons.label_outline,
                          label: meta.categoria.label,
                          context: context,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(StatusMeta status, BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case StatusMeta.atingida:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        icon = Icons.verified_rounded;
        break;
      case StatusMeta.parcial:
        bg = Colors.amber.shade50;
        fg = Colors.amber.shade800;
        icon = Icons.change_circle_outlined;
        break;
      case StatusMeta.naoAtingida:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        icon = Icons.close_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoPill({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.primary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  Color _corDaCategoria(Categoria c) {
    switch (c) {
      case Categoria.estudo:
        return const Color(0xFF7C3AED);
      case Categoria.trabalho:
        return const Color(0xFF2563EB);
      case Categoria.saude:
        return const Color(0xFF059669);
      case Categoria.financas:
        return const Color(0xFFEA580C);
      case Categoria.pessoal:
        return const Color(0xFFDC2626);
      case Categoria.lazer:
        return const Color(0xFFEAB308);
    }
  }
}
