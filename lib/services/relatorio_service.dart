import '../models/meta.dart';
import '../models/tarefa.dart';
import '../models/enums.dart';
import '../models/relatorio.dart';
import '../state/meta_store.dart';
import '../state/tarefa_store.dart';

class RelatorioService {
  final MetaStore metaStore;
  final TarefaStore tarefaStore;

  RelatorioService({required this.metaStore, required this.tarefaStore});

  DadosRelatorio gerarRelatorio(
    PeriodoMeta periodo, {
    DateTime? dataReferencia,
  }) {
    final hoje = dataReferencia ?? DateTime.now();

    DateTime inicio;
    DateTime fim = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

    switch (periodo) {
      case PeriodoMeta.semanal:
        final diaDaSemana = hoje.weekday;
        inicio = hoje.subtract(Duration(days: diaDaSemana - 1));
        inicio = DateTime(inicio.year, inicio.month, inicio.day);
        break;
      case PeriodoMeta.mensal:
        inicio = DateTime(hoje.year, hoje.month, 1);
        break;
      case PeriodoMeta.anual:
        inicio = DateTime(hoje.year, 1, 1);
        break;
    }

    final metas = metaStore.metas.where((meta) {
      return meta.dataCriacao.isAfter(inicio) && meta.dataCriacao.isBefore(fim);
    }).toList();

    final tarefas = tarefaStore.tarefas.where((tarefa) {
      return tarefa.dataCriacao.isAfter(inicio) &&
          tarefa.dataCriacao.isBefore(fim);
    }).toList();

    int metasAtingidas = 0;
    int metasParciais = 0;
    int metasNaoAtingidas = 0;

    final categoriasMetas = <Categoria, int>{};
    final categoriasTarefas = <Categoria, int>{};

    final metasPorSemana = <int, int>{};
    final tarefasPorSemana = <int, int>{};
    final metasPorMes = <int, int>{};
    final tarefasPorMes = <int, int>{};

    final tarefasPorTurno = <TurnoDia, int>{
      TurnoDia.manha: 0,
      TurnoDia.tarde: 0,
      TurnoDia.noite: 0,
    };

    for (final meta in metas) {
      switch (meta.status) {
        case StatusMeta.atingida:
          metasAtingidas++;
          break;
        case StatusMeta.parcial:
          metasParciais++;
          break;
        case StatusMeta.naoAtingida:
          metasNaoAtingidas++;
          break;
      }

      categoriasMetas[meta.categoria] =
          (categoriasMetas[meta.categoria] ?? 0) + 1;

      final semana = _obterNumeroSemana(meta.dataCriacao);
      final mes = meta.dataCriacao.month;

      metasPorSemana[semana] = (metasPorSemana[semana] ?? 0) + 1;
      metasPorMes[mes] = (metasPorMes[mes] ?? 0) + 1;
    }

    int tarefasConcluidas = 0;

    for (final tarefa in tarefas) {
      if (tarefa.concluida) {
        tarefasConcluidas++;
      }

      categoriasTarefas[tarefa.categoria] =
          (categoriasTarefas[tarefa.categoria] ?? 0) + 1;

      final semana = _obterNumeroSemana(tarefa.dataCriacao);
      final mes = tarefa.dataCriacao.month;

      tarefasPorSemana[semana] = (tarefasPorSemana[semana] ?? 0) + 1;
      tarefasPorMes[mes] = (tarefasPorMes[mes] ?? 0) + 1;

      tarefasPorTurno[tarefa.turno] = (tarefasPorTurno[tarefa.turno] ?? 0) + 1;
    }

    int? semanaMaisProdutiva;
    int maxProdutividadeSemana = 0;

    for (final semana in {...metasPorSemana.keys, ...tarefasPorSemana.keys}) {
      final produtividade =
          (metasPorSemana[semana] ?? 0) + (tarefasPorSemana[semana] ?? 0);

      if (produtividade > maxProdutividadeSemana) {
        maxProdutividadeSemana = produtividade;
        semanaMaisProdutiva = semana;
      }
    }

    int? mesMaisProdutivo;
    int maxProdutividadeMes = 0;

    for (final mes in {...metasPorMes.keys, ...tarefasPorMes.keys}) {
      final produtividade = (metasPorMes[mes] ?? 0) + (tarefasPorMes[mes] ?? 0);

      if (produtividade > maxProdutividadeMes) {
        maxProdutividadeMes = produtividade;
        mesMaisProdutivo = mes;
      }
    }

    TurnoDia? turnoMaisProdutivo;
    int maxProdutividadeTurno = 0;

    for (final entry in tarefasPorTurno.entries) {
      if (entry.value > maxProdutividadeTurno) {
        maxProdutividadeTurno = entry.value;
        turnoMaisProdutivo = entry.key;
      }
    }

    return DadosRelatorio(
      inicio: inicio,
      fim: fim,
      periodo: periodo,
      totalMetas: metas.length,
      metasAtingidas: metasAtingidas,
      metasParciais: metasParciais,
      metasNaoAtingidas: metasNaoAtingidas,
      totalTarefas: tarefas.length,
      tarefasConcluidas: tarefasConcluidas,
      categoriasMetas: categoriasMetas,
      categoriasTarefas: categoriasTarefas,
      tarefasPorTurno: tarefasPorTurno,
      metasPorSemana: metasPorSemana,
      tarefasPorSemana: tarefasPorSemana,
      metasPorMes: metasPorMes,
      tarefasPorMes: tarefasPorMes,
      semanaMaisProdutiva: semanaMaisProdutiva,
      mesMaisProdutivo: mesMaisProdutivo,
      turnoMaisProdutivo: turnoMaisProdutivo,
    );
  }

  int _obterNumeroSemana(DateTime data) {
    final primeiroDiaDoAno = DateTime(data.year, 1, 1);
    final diasDesdeInicio = data.difference(primeiroDiaDoAno).inDays;
    return ((diasDesdeInicio + primeiroDiaDoAno.weekday - 1) / 7).ceil();
  }
}
