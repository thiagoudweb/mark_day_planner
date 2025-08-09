import 'package:flutter/foundation.dart';
import '../models/meta.dart';
import '../models/enums.dart';

class MetaStore extends ChangeNotifier {
  final List<Meta> _metas = [];

  List<Meta> get metas => List.unmodifiable(_metas);

  bool get isEmpty => _metas.isEmpty;

  void add(Meta meta) {
    _metas.add(meta);
    notifyListeners();
  }

  void updateAt(int index, Meta updated) {
    if (index < 0 || index >= _metas.length) return;
    _metas[index] = updated;
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _metas.length) return;
    _metas.removeAt(index);
    notifyListeners();
  }

  /// Limpa todas as metas (útil para testes).
  void clear() {
    _metas.clear();
    notifyListeners();
  }

  /// Agrupa metas por período, sempre retornando as três chaves.
  Map<PeriodoMeta, List<Meta>> get metasPorPeriodo {
    final mapa = {
      PeriodoMeta.semanal: <Meta>[],
      PeriodoMeta.mensal: <Meta>[],
      PeriodoMeta.anual: <Meta>[],
    };
    for (final m in _metas) {
      mapa[m.periodo]!.add(m);
    }
    return Map.unmodifiable(mapa);
  }

  /// Dados de exemplo para facilitar o teste visual.
  void seedMockData() {
    if (_metas.isNotEmpty) return;
    _metas.addAll([
      Meta(
        titulo: 'Ler 2 artigos',
        descricao: 'Artigos de Flutter esta semana',
        periodo: PeriodoMeta.semanal,
        categoria: Categoria.estudo,
      ),
      Meta(
        titulo: 'Correr 50 km',
        descricao: 'Meta de corrida do mês',
        periodo: PeriodoMeta.mensal,
        categoria: Categoria.saude,
      ),
      Meta(
        titulo: 'Guardar 10% da renda',
        descricao: 'Planejamento financeiro anual',
        periodo: PeriodoMeta.anual,
        categoria: Categoria.financas,
      ),
      Meta(
        titulo: 'Revisar projeto',
        descricao: 'Organizar backlog mensal',
        periodo: PeriodoMeta.mensal,
        categoria: Categoria.trabalho,
      ),
    ]);
    notifyListeners();
  }
}
