import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../models/meta.dart';
import '../state/meta_store.dart';
import '../models/enums.dart';

class EstatisticasPage extends StatelessWidget {
  const EstatisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MetaStore>();
    final metas = store.metas;

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas e Relatórios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResumoGeral(metas),
            const SizedBox(height: 24),
            _buildProgressoPorCategoria(metas),
            const SizedBox(height: 24),
            _buildProgressoPorPeriodo(metas),
            const SizedBox(height: 24),
            _buildMetasVencidas(store.getMetasVencidas()),
            const SizedBox(height: 24),
            _buildDistribuicaoStatus(metas),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoGeral(List<Meta> metas) {
    final total = metas.length;
    final concluidas = metas
        .where((m) => m.status == StatusMeta.atingida)
        .length;
    final parciais = metas.where((m) => m.status == StatusMeta.parcial).length;
    final percentualConcluidas = total > 0 ? (concluidas / total * 100) : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo Geral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetrica('Total', total.toString()),
                _buildMetrica('Concluídas', concluidas.toString()),
                _buildMetrica('Parciais', parciais.toString()),
                _buildMetrica(
                  'Taxa de Sucesso',
                  '${percentualConcluidas.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetrica(String titulo, String valor) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildProgressoPorCategoria(List<Meta> metas) {
    final categorias = Categoria.values;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categorias.map((categoria) {
              final metasCategoria = metas
                  .where((m) => m.categoria == categoria)
                  .toList();
              final total = metasCategoria.length;
              final concluidas = metasCategoria
                  .where((m) => m.status == StatusMeta.atingida)
                  .length;
              final percentual = total > 0 ? (concluidas / total * 100) : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(categoria.label),
                        Text('${percentual.toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentual / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCorCategoria(categoria),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$concluidas de $total metas concluídas',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressoPorPeriodo(List<Meta> metas) {
    final periodos = PeriodoMeta.values;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso por Período',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...periodos.map((periodo) {
              final metasPeriodo = metas
                  .where((m) => m.periodo == periodo)
                  .toList();
              final total = metasPeriodo.length;
              final concluidas = metasPeriodo
                  .where((m) => m.status == StatusMeta.atingida)
                  .length;
              final percentual = total > 0 ? (concluidas / total * 100) : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(periodo.label),
                        Text('${percentual.toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentual / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCorPeriodo(periodo),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$concluidas de $total metas concluídas',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetasVencidas(List<Meta> metasVencidas) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metas Vencidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (metasVencidas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Nenhuma meta vencida!',
                  style: TextStyle(color: Colors.green),
                ),
              )
            else
              ...metasVencidas.map(
                (meta) => ListTile(
                  title: Text(meta.titulo),
                  subtitle: Text(
                    'Venceu em ${meta.dataLimite?.toString().substring(0, 10)}',
                  ),
                  leading: Icon(Icons.warning, color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistribuicaoStatus(List<Meta> metas) {
    final statusCount = groupBy(metas, (meta) => meta.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição por Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: StatusMeta.values.map((status) {
                final count = statusCount[status]?.length ?? 0;
                final percentual = metas.isNotEmpty
                    ? (count / metas.length * 100)
                    : 0;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: percentual / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getCorStatus(status),
                            ),
                          ),
                        ),
                        Text('${percentual.toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(status.label, style: const TextStyle(fontSize: 12)),
                    Text(
                      '$count metas',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCorCategoria(Categoria categoria) {
    switch (categoria) {
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

  Color _getCorPeriodo(PeriodoMeta periodo) {
    switch (periodo) {
      case PeriodoMeta.semanal:
        return const Color(0xFF3B82F6);
      case PeriodoMeta.mensal:
        return const Color(0xFF10B981);
      case PeriodoMeta.anual:
        return const Color(0xFFF59E0B);
    }
  }

  Color _getCorStatus(StatusMeta status) {
    switch (status) {
      case StatusMeta.atingida:
        return Colors.green;
      case StatusMeta.parcial:
        return Colors.orange;
      case StatusMeta.naoAtingida:
        return Colors.red;
    }
  }
}
