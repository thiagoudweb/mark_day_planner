import '../models/meta.dart';
import '../models/tarefa.dart';
import '../models/enums.dart';

class DadosRelatorio {
  final DateTime inicio;
  final DateTime fim;
  final PeriodoMeta periodo;

  final int totalMetas;
  final int metasAtingidas;
  final int metasParciais;
  final int metasNaoAtingidas;

  final int totalTarefas;
  final int tarefasConcluidas;

  final Map<Categoria, int> categoriasMetas;
  final Map<Categoria, int> categoriasTarefas;

  final Map<TurnoDia, int> tarefasPorTurno;

  final Map<int, int> metasPorSemana;
  final Map<int, int> tarefasPorSemana;
  final Map<int, int> metasPorMes;
  final Map<int, int> tarefasPorMes;

  final int? semanaMaisProdutiva;
  final int? mesMaisProdutivo;
  final TurnoDia? turnoMaisProdutivo;

  DadosRelatorio({
    required this.inicio,
    required this.fim,
    required this.periodo,
    required this.totalMetas,
    required this.metasAtingidas,
    required this.metasParciais,
    required this.metasNaoAtingidas,
    required this.totalTarefas,
    required this.tarefasConcluidas,
    required this.categoriasMetas,
    required this.categoriasTarefas,
    required this.tarefasPorTurno,
    required this.metasPorSemana,
    required this.tarefasPorSemana,
    required this.metasPorMes,
    required this.tarefasPorMes,
    required this.semanaMaisProdutiva,
    required this.mesMaisProdutivo,
    required this.turnoMaisProdutivo,
  });

  double get porcentagemMetasAtingidas =>
      totalMetas > 0 ? (metasAtingidas / totalMetas) * 100 : 0;

  double get porcentagemMetasParciais =>
      totalMetas > 0 ? (metasParciais / totalMetas) * 100 : 0;

  double get porcentagemMetasNaoAtingidas =>
      totalMetas > 0 ? (metasNaoAtingidas / totalMetas) * 100 : 0;

  double get porcentagemTarefasConcluidas =>
      totalTarefas > 0 ? (tarefasConcluidas / totalTarefas) * 100 : 0;

  List<Categoria> get categoriasMetasOrdenadas {
    final lista = categoriasMetas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return lista.map((e) => e.key).toList();
  }

  List<Categoria> get categoriasTarefasOrdenadas {
    final lista = categoriasTarefas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return lista.map((e) => e.key).toList();
  }
}
