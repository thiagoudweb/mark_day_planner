import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/meta_store.dart';
import '../models/enums.dart';

class FiltrosBar extends StatelessWidget {
  const FiltrosBar({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MetaStore>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _FiltroDropdown<PeriodoMeta>(
            value: store.filtroPeriodo,
            items: PeriodoMeta.values,
            label: 'Período',
            onChanged: (value) => store.setFiltroPeriodo(value),
          ),
          const SizedBox(width: 8),

          _FiltroDropdown<Categoria>(
            value: store.filtroCategoria,
            items: Categoria.values,
            label: 'Categoria',
            onChanged: (value) => store.setFiltroCategoria(value),
          ),
          const SizedBox(width: 8),

          _FiltroDropdown<StatusMeta>(
            value: store.filtroStatus,
            items: StatusMeta.values,
            label: 'Status',
            onChanged: (value) => store.setFiltroStatus(value),
          ),
          const SizedBox(width: 8),

          if (store.filtroPeriodo != null ||
              store.filtroCategoria != null ||
              store.filtroStatus != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: store.limparFiltros,
              tooltip: 'Limpar filtros',
            ),
        ],
      ),
    );
  }
}

class _FiltroDropdown<T extends Enum> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String label;
  final ValueChanged<T?> onChanged;

  const _FiltroDropdown({
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            isExpanded: true,
            hint: Text('Todos', style: TextStyle(fontSize: 14)),
            items: [
              DropdownMenuItem<T>(
                value: null,
                child: Text('Todos', style: TextStyle(fontSize: 14)),
              ),
              ...items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(_getLabel(item), style: TextStyle(fontSize: 14)),
                );
              }),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  String _getLabel(T item) {
    if (item is PeriodoMeta) return item.label;
    if (item is Categoria) return item.label;
    if (item is StatusMeta) return item.label;
    return item.toString().split('.').last;
  }
}