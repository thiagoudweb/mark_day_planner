import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tarefa.dart';
import '../models/enums.dart';
import '../state/tarefa_store.dart';

class EditarTarefaPage extends StatefulWidget {
  final Tarefa? tarefa;
  const EditarTarefaPage({super.key, this.tarefa});

  @override
  State<EditarTarefaPage> createState() => _EditarTarefaPageState();
}

class _EditarTarefaPageState extends State<EditarTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late Categoria _categoria;
  late TurnoDia _turno;
  late DateTime? _dataLimite;

  @override
  void initState() {
    super.initState();
    final tarefa = widget.tarefa;
    _tituloController = TextEditingController(text: tarefa?.titulo ?? '');
    _descricaoController = TextEditingController(text: tarefa?.descricao ?? '');
    _categoria = tarefa?.categoria ?? Categoria.pessoal;
    _turno = tarefa?.turno ?? TurnoDia.manha;
    _dataLimite = tarefa?.dataLimite;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<TarefaStore>();
    final isEditando = widget.tarefa != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditando ? 'Editar Tarefa' : 'Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Categoria>(
                value: _categoria,
                decoration: const InputDecoration(
                  labelText: 'Categoria *',
                  border: OutlineInputBorder(),
                ),
                items: Categoria.values
                    .map(
                      (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _categoria = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TurnoDia>(
                value: _turno,
                decoration: const InputDecoration(
                  labelText: 'Turno *',
                  border: OutlineInputBorder(),
                ),
                items: TurnoDia.values
                    .map(
                      (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _turno = value);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Definir data limite'),
                value: _dataLimite != null,
                onChanged: (value) {
                  setState(() {
                    _dataLimite = value
                        ? DateTime.now().add(const Duration(days: 7))
                        : null;
                  });
                },
              ),
              if (_dataLimite != null) ...[
                const SizedBox(height: 8),
                ListTile(
                  title: Text(
                    'Data limite: ${_formatarData(_dataLimite!)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selecionarData,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _salvarTarefa(store),
                child: Text(isEditando ? 'Atualizar Tarefa' : 'Criar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }

  Future<void> _selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataLimite ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null && mounted) {
      setState(() => _dataLimite = dataSelecionada);
    }
  }

  void _salvarTarefa(TarefaStore store) {
    if (_formKey.currentState!.validate()) {
      final novaTarefa = Tarefa(
        id: widget.tarefa?.id,
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        categoria: _categoria,
        turno: _turno,
        dataLimite: _dataLimite,
      );
      if (widget.tarefa != null) {
        final idx = store.tarefas.indexWhere((t) => t.id == widget.tarefa!.id);
        if (idx != -1) {
          store.updateAt(idx, novaTarefa);
        }
      } else {
        store.add(novaTarefa);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
