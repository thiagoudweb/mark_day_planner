import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/meta_store.dart';
import '../models/meta.dart';
import '../models/enums.dart';

class EditarMetaPage extends StatefulWidget {
  final Meta? meta;

  const EditarMetaPage({super.key, this.meta});

  @override
  EditarMetaPageState createState() => EditarMetaPageState();
}

class EditarMetaPageState extends State<EditarMetaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late PeriodoMeta _periodo;
  late Categoria _categoria;
  late StatusMeta _status;
  late DateTime? _dataLimite;

  @override
  void initState() {
    super.initState();
    final meta = widget.meta;

    _tituloController = TextEditingController(text: meta?.titulo ?? '');
    _descricaoController = TextEditingController(text: meta?.descricao ?? '');
    _periodo = meta?.periodo ?? PeriodoMeta.semanal;
    _categoria = meta?.categoria ?? Categoria.pessoal;
    _status = meta?.status ?? StatusMeta.naoAtingida;
    _dataLimite = meta?.dataLimite;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<MetaStore>();
    final isEditando = widget.meta != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditando ? 'Editar Meta' : 'Nova Meta'),
        actions: [
          if (isEditando)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmarExclusao(store),
            ),
        ],
      ),
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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<PeriodoMeta>(
                      value: _periodo,
                      decoration: const InputDecoration(
                        labelText: 'Período *',
                        border: OutlineInputBorder(),
                      ),
                      items: PeriodoMeta.values
                          .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.label),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _periodo = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<Categoria>(
                      value: _categoria,
                      decoration: const InputDecoration(
                        labelText: 'Categoria *',
                        border: OutlineInputBorder(),
                      ),
                      items: Categoria.values
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.label),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _categoria = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<StatusMeta>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: StatusMeta.values
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.label),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Definir data limite'),
                value: _dataLimite != null,
                onChanged: (value) {
                  setState(() {
                    _dataLimite = value ? DateTime.now().add(const Duration(days: 7)) : null;
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
                onPressed: () => _salvarMeta(store),
                child: Text(isEditando ? 'Atualizar Meta' : 'Criar Meta'),
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

  void _salvarMeta(MetaStore store) {
    if (_formKey.currentState!.validate()) {
      final novaMeta = Meta(
        id: widget.meta?.id,
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        periodo: _periodo,
        categoria: _categoria,
        status: _status,
        dataLimite: _dataLimite,
      );

      if (widget.meta != null) {
        store.update(widget.meta!.id, novaMeta);
      } else {
        store.add(novaMeta);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _confirmarExclusao(MetaStore store) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true && mounted) {
      store.remove(widget.meta!.id);
      Navigator.pop(context);
    }
  }
}