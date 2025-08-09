import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/meta_store.dart';
import '../models/enums.dart';
import '../models/meta.dart';
import 'meta_card.dart';

class MetasPage extends StatelessWidget {
  const MetasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MetaStore>();
    final grouped = store.metasPorPeriodo;

    const ordem = [PeriodoMeta.semanal, PeriodoMeta.mensal, PeriodoMeta.anual];

    final children = <Widget>[];
    for (final periodo in ordem) {
      final lista = grouped[periodo] ?? const <Meta>[];
      children.add(_SectionHeader(title: periodo.label));
      if (lista.isEmpty) {
        children.add(const _EmptySectionHint());
      } else {
        for (final meta in lista) {
          children.add(MetaCard(meta: meta));
        }
      }
      // Espaço entre seções
      children.add(const SizedBox(height: 8));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas por Período'),
        actions: [
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirDialogAdicionar(context),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Meta'),
      ),
    );
  }

  Future<void> _abrirDialogAdicionar(BuildContext context) async {
    final store = context.read<MetaStore>();
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    PeriodoMeta periodo = PeriodoMeta.semanal;
    Categoria categoria = Categoria.pessoal;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Meta (rápida)'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<PeriodoMeta>(
                      value: periodo,
                      decoration: const InputDecoration(labelText: 'Período'),
                      items: [
                        for (final p in PeriodoMeta.values)
                          DropdownMenuItem(value: p, child: Text(p.label)),
                      ],
                      onChanged: (v) => periodo = v ?? PeriodoMeta.semanal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<Categoria>(
                      value: categoria,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: [
                        for (final c in Categoria.values)
                          DropdownMenuItem(value: c, child: Text(c.label)),
                      ],
                      onChanged: (v) => categoria = v ?? Categoria.pessoal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            child: const Text('Adicionar'),
            onPressed: () {
              if (tituloCtrl.text.trim().isEmpty) return;
              store.add(
                Meta(
                  titulo: tituloCtrl.text.trim(),
                  descricao: descCtrl.text.trim(),
                  periodo: periodo,
                  categoria: categoria,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
