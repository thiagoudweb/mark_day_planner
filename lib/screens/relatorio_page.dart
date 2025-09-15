import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/relatorio.dart';
import '../models/enums.dart';
import '../services/relatorio_service.dart';
import '../state/meta_store.dart';
import '../state/tarefa_store.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({Key? key}) : super(key: key);

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  PeriodoMeta _periodoSelecionado = PeriodoMeta.semanal;
  DadosRelatorio? _relatorio;

  @override
  void initState() {
    super.initState();
    _gerarRelatorio();
  }

  void _gerarRelatorio() {
    final metaStore = context.read<MetaStore>();
    final tarefaStore = context.read<TarefaStore>();

    final relatorioService = RelatorioService(
      metaStore: metaStore,
      tarefaStore: tarefaStore,
    );

    final relatorio = relatorioService.gerarRelatorio(_periodoSelecionado);
    setState(() {
      _relatorio = relatorio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Período do Relatório',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<PeriodoMeta>(
                      segments: const [
                        ButtonSegment(
                          value: PeriodoMeta.semanal,
                          label: Text('Semanal'),
                        ),
                        ButtonSegment(
                          value: PeriodoMeta.mensal,
                          label: Text('Mensal'),
                        ),
                        ButtonSegment(
                          value: PeriodoMeta.anual,
                          label: Text('Anual'),
                        ),
                      ],
                      selected: {_periodoSelecionado},
                      onSelectionChanged: (Set<PeriodoMeta> selection) {
                        setState(() {
                          _periodoSelecionado = selection.first;
                        });
                        _gerarRelatorio();
                      },
                    ),
                    if (_relatorio != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'De ${DateFormat('dd/MM/yyyy').format(_relatorio!.inicio)} '
                        'até ${DateFormat('dd/MM/yyyy').format(_relatorio!.fim)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _relatorio == null
                ? const Center(child: CircularProgressIndicator())
                : _relatorioContent(),
          ),
        ],
      ),
    );
  }

  Widget _relatorioContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionCard(
          title: 'Metas',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: ${_relatorio!.totalMetas}'),
              const SizedBox(height: 8),
              _buildProgressRow(
                'Atingidas',
                _relatorio!.metasAtingidas,
                _relatorio!.totalMetas,
                Colors.green,
              ),
              _buildProgressRow(
                'Parciais',
                _relatorio!.metasParciais,
                _relatorio!.totalMetas,
                Colors.orange,
              ),
              _buildProgressRow(
                'Não atingidas',
                _relatorio!.metasNaoAtingidas,
                _relatorio!.totalMetas,
                Colors.red,
              ),
              if (_relatorio!.categoriasMetas.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Categorias mais realizadas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  _relatorio!.categoriasMetasOrdenadas.length > 3
                      ? 3
                      : _relatorio!.categoriasMetasOrdenadas.length,
                  (index) {
                    final categoria =
                        _relatorio!.categoriasMetasOrdenadas[index];
                    final count = _relatorio!.categoriasMetas[categoria] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${index + 1}. ${categoria.label}: $count',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Tarefas',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: ${_relatorio!.totalTarefas}'),
              const SizedBox(height: 8),
              _buildProgressRow(
                'Concluídas',
                _relatorio!.tarefasConcluidas,
                _relatorio!.totalTarefas,
                Colors.blue,
              ),
              if (_relatorio!.categoriasTarefas.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Categorias mais realizadas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  _relatorio!.categoriasTarefasOrdenadas.length > 3
                      ? 3
                      : _relatorio!.categoriasTarefasOrdenadas.length,
                  (index) {
                    final categoria =
                        _relatorio!.categoriasTarefasOrdenadas[index];
                    final count = _relatorio!.categoriasTarefas[categoria] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${index + 1}. ${categoria.label}: $count',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    );
                  },
                ),
              ],
              if (_relatorio!.tarefasPorTurno.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Distribuição por turnos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTurnoChart(_relatorio!.tarefasPorTurno),
                if (_relatorio!.turnoMaisProdutivo != null)
                  Text(
                    'Turno mais produtivo: ${_relatorio!.turnoMaisProdutivo!.label}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Destaques de Produtividade',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_relatorio!.semanaMaisProdutiva != null)
                Text(
                  'Semana mais produtiva: Semana ${_relatorio!.semanaMaisProdutiva}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              if (_relatorio!.mesMaisProdutivo != null)
                Text(
                  'Mês mais produtivo: ${_obterNomeMes(_relatorio!.mesMaisProdutivo!)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _obterNomeMes(int mes) {
    final date = DateTime(2022, mes, 1);
    return DateFormat('MMMM', 'pt_BR').format(date);
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(String label, int value, int total, Color color) {
    final percent = total > 0 ? (value / total) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('$value/$total (${percent.toStringAsFixed(1)}%)'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: total > 0 ? value / total : 0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnoChart(Map<TurnoDia, int> tarefasPorTurno) {
    final total = tarefasPorTurno.values.fold(0, (a, b) => a + b);
    if (total == 0) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: TurnoDia.values.map((turno) {
          final value = tarefasPorTurno[turno] ?? 0;
          final percent = total > 0 ? (value / total) * 100 : 0.0;

          return Expanded(
            flex: value > 0 ? value : 1,
            child: Column(
              children: [
                Container(height: 24, color: _getTurnoColor(turno)),
                const SizedBox(height: 4),
                Text(turno.label, style: const TextStyle(fontSize: 12)),
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getTurnoColor(TurnoDia turno) {
    switch (turno) {
      case TurnoDia.manha:
        return Colors.amber;
      case TurnoDia.tarde:
        return Colors.deepOrange;
      case TurnoDia.noite:
        return Colors.indigo;
    }
  }
}
