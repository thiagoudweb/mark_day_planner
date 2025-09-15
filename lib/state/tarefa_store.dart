import 'package:flutter/foundation.dart';
import '../models/tarefa.dart';
import '../models/enums.dart';

class TarefaStore extends ChangeNotifier {
  final List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => List.unmodifiable(_tarefas);

  bool get isEmpty => _tarefas.isEmpty;

  void add(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void updateAt(int index, Tarefa updated) {
    if (index < 0 || index >= _tarefas.length) return;
    _tarefas[index] = updated;
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _tarefas.length) return;
    _tarefas.removeAt(index);
    notifyListeners();
  }

  void marcarConcluida(int index, [DateTime? dataConclusao]) {
    if (index < 0 || index >= _tarefas.length) return;

    final tarefa = _tarefas[index];
    _tarefas[index] = tarefa.copyWith(
      concluida: true,
      dataConclusao: dataConclusao ?? DateTime.now(),
    );
    notifyListeners();
  }

  void clear() {
    _tarefas.clear();
    notifyListeners();
  }

  Map<TurnoDia, List<Tarefa>> get tarefasPorTurno {
    final mapa = {
      TurnoDia.manha: <Tarefa>[],
      TurnoDia.tarde: <Tarefa>[],
      TurnoDia.noite: <Tarefa>[],
    };
    for (final t in _tarefas) {
      mapa[t.turno]!.add(t);
    }
    return Map.unmodifiable(mapa);
  }

  List<Tarefa> get tarefasConcluidas =>
      _tarefas.where((t) => t.concluida).toList();

  List<Tarefa> get tarefasPendentes =>
      _tarefas.where((t) => !t.concluida).toList();

  void seedMockData() {
    if (_tarefas.isNotEmpty) return;
    _tarefas.addAll([
      Tarefa(
        titulo: 'Estudar Flutter',
        descricao: 'Revisar widgets básicos',
        categoria: Categoria.estudo,
        turno: TurnoDia.manha,
      ),
      Tarefa(
        titulo: 'Reunião de equipe',
        descricao: 'Discussão sobre novos projetos',
        categoria: Categoria.trabalho,
        turno: TurnoDia.tarde,
        concluida: true,
        dataConclusao: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Tarefa(
        titulo: 'Treino de corrida',
        descricao: '5km no parque',
        categoria: Categoria.saude,
        turno: TurnoDia.tarde,
      ),
      Tarefa(
        titulo: 'Organizar despesas',
        descricao: 'Atualizar planilha mensal',
        categoria: Categoria.financas,
        turno: TurnoDia.noite,
      ),
    ]);
    notifyListeners();
  }
}
