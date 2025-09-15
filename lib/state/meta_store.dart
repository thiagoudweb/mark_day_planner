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

  void update(String id, Meta updated) {
    final index = _metas.indexWhere((meta) => meta.id == id);
    if (index == -1) return;
    _metas[index] = updated;
    notifyListeners();
  }

  void remove(String id) {
    _metas.removeWhere((meta) => meta.id == id);
    notifyListeners();
  }

  Meta findById(String id) {
    return _metas.firstWhere((meta) => meta.id == id);
  }

  List<Meta> getMetasPorStatus(StatusMeta status) {
    return _metas.where((meta) => meta.status == status).toList();
  }

  List<Meta> getMetasPorCategoria(Categoria categoria) {
    return _metas.where((meta) => meta.categoria == categoria).toList();
  }

  List<Meta> getMetasVencidas() {
    return _metas.where((meta) => meta.estaVencida).toList();
  }

  void clear() {
    _metas.clear();
    notifyListeners();
  }

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

  void seedMockData() {
    if (_metas.isNotEmpty) return;
    _metas.addAll([
      Meta(
        titulo: 'Ler 2 artigos',
        descricao: 'Artigos de Flutter esta semana',
        periodo: PeriodoMeta.semanal,
        categoria: Categoria.estudo,
        turno: TurnoDia.manha,
        tipoDuracao: TipoDuracao.meiaHora,
        dataLimite: DateTime.now().add(const Duration(days: 7)),
      ),
      Meta(
        titulo: 'Correr 50 km',
        descricao: 'Meta de corrida do mês',
        periodo: PeriodoMeta.mensal,
        categoria: Categoria.saude,
        turno: TurnoDia.tarde,
        tipoDuracao: TipoDuracao.umaHora,
        dataLimite: DateTime.now().add(const Duration(days: 30)),
      ),
      Meta(
        titulo: 'Guardar 10% da renda',
        descricao: 'Planejamento financeiro anual',
        periodo: PeriodoMeta.anual,
        categoria: Categoria.financas,
        turno: TurnoDia.noite,
        tipoDuracao: TipoDuracao.turno,
        dataLimite: DateTime.now().add(const Duration(days: 365)),
      ),
      Meta(
        titulo: 'Revisar projeto',
        descricao: 'Organizar backlog mensal',
        periodo: PeriodoMeta.mensal,
        categoria: Categoria.trabalho,
        turno: TurnoDia.tarde,
        tipoDuracao: TipoDuracao.umaHora,
        dataLimite: DateTime.now().add(const Duration(days: 30)),
      ),
    ]);
    notifyListeners();
  }

  PeriodoMeta? _filtroPeriodo;
  Categoria? _filtroCategoria;
  StatusMeta? _filtroStatus;

  PeriodoMeta? get filtroPeriodo => _filtroPeriodo;
  Categoria? get filtroCategoria => _filtroCategoria;
  StatusMeta? get filtroStatus => _filtroStatus;

  void setFiltroPeriodo(PeriodoMeta? periodo) {
    _filtroPeriodo = periodo;
    notifyListeners();
  }

  void setFiltroCategoria(Categoria? categoria) {
    _filtroCategoria = categoria;
    notifyListeners();
  }

  void setFiltroStatus(StatusMeta? status) {
    _filtroStatus = status;
    notifyListeners();
  }

  void limparFiltros() {
    _filtroPeriodo = null;
    _filtroCategoria = null;
    _filtroStatus = null;
    notifyListeners();
  }

  List<Meta> get metasFiltradas {
    return _metas.where((meta) {
      final periodoMatch =
          _filtroPeriodo == null || meta.periodo == _filtroPeriodo;
      final categoriaMatch =
          _filtroCategoria == null || meta.categoria == _filtroCategoria;
      final statusMatch = _filtroStatus == null || meta.status == _filtroStatus;

      return periodoMatch && categoriaMatch && statusMatch;
    }).toList();
  }

  Map<PeriodoMeta, List<Meta>> get metasFiltradasPorPeriodo {
    final metasFiltradas = this.metasFiltradas;
    final mapa = {
      PeriodoMeta.semanal: <Meta>[],
      PeriodoMeta.mensal: <Meta>[],
      PeriodoMeta.anual: <Meta>[],
    };

    for (final m in metasFiltradas) {
      mapa[m.periodo]!.add(m);
    }

    return Map.unmodifiable(mapa);
  }
}
