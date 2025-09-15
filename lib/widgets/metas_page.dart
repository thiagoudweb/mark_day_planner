import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/meta_store.dart';
import '../models/meta.dart';
import '../models/enums.dart';
import 'meta_card.dart';
import 'editar_meta_page.dart';
import 'filtros_bar.dart';

class MetasPage extends StatelessWidget {
  const MetasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MetaStore>();
    final grouped = store.metasFiltradasPorPeriodo;

    const ordem = [PeriodoMeta.semanal, PeriodoMeta.mensal, PeriodoMeta.anual];

    final children = <Widget>[const FiltrosBar(), const SizedBox(height: 16)];

    if (store.filtroPeriodo != null ||
        store.filtroCategoria != null ||
        store.filtroStatus != null) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              const Icon(Icons.filter_alt, size: 16, color: Colors.blue),
              const Text(
                'Filtros ativos:',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (store.filtroPeriodo != null)
                _FiltroAtivoChip(
                  label: 'Período: ${store.filtroPeriodo!.label}',
                  onClear: () => store.setFiltroPeriodo(null),
                ),
              if (store.filtroCategoria != null)
                _FiltroAtivoChip(
                  label: 'Categoria: ${store.filtroCategoria!.label}',
                  onClear: () => store.setFiltroCategoria(null),
                ),
              if (store.filtroStatus != null)
                _FiltroAtivoChip(
                  label: 'Status: ${store.filtroStatus!.label}',
                  onClear: () => store.setFiltroStatus(null),
                ),
            ],
          ),
        ),
      );
    }

    for (final periodo in ordem) {
      final lista = grouped[periodo] ?? const <Meta>[];

      if (lista.isNotEmpty ||
          (store.filtroPeriodo == null &&
              store.filtroCategoria == null &&
              store.filtroStatus == null)) {
        children.add(_SectionHeader(title: periodo.label));
      }

      if (lista.isEmpty) {
        children.add(const _EmptySectionHint());
      } else {
        for (final meta in lista) {
          children.add(
            MetaCard(meta: meta, onTap: () => _abrirTelaEdicao(context, meta)),
          );
        }
      }
      children.add(const SizedBox(height: 8));
    }

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Adicionar exemplos',
                    onPressed: store.seedMockData,
                    icon: const Icon(Icons.auto_awesome),
                  ),
                  IconButton(
                    tooltip: 'Limpar',
                    onPressed: store.clear,
                    icon: const Icon(Icons.delete_sweep_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                itemCount: children.length,
                itemBuilder: (context, index) => children[index],
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _abrirTelaNovaMeta(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Meta'),
          ),
        ),
      ],
    );
  }

  void _abrirTelaEdicao(BuildContext context, Meta meta) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarMetaPage(meta: meta)),
    );
  }

  void _abrirTelaNovaMeta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditarMetaPage()),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
      child: Row(
        children: [
          Icon(Icons.flag, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const Expanded(child: Divider(indent: 12, thickness: 0.8)),
        ],
      ),
    );
  }
}

class _EmptySectionHint extends StatelessWidget {
  const _EmptySectionHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'Sem metas neste período.',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class _FiltroAtivoChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const _FiltroAtivoChip({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onClear,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
