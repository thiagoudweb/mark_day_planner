import 'package:uuid/uuid.dart';
import 'enums.dart';

class Tarefa {
  final String id;
  final String titulo;
  final String descricao;
  final Categoria categoria;
  final bool concluida;
  final DateTime dataCriacao;
  final DateTime? dataConclusao;
  final DateTime? dataLimite;
  final TurnoDia turno;

  Tarefa({
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.turno,
    this.concluida = false,
    String? id,
    DateTime? dataCriacao,
    this.dataConclusao,
    this.dataLimite,
  }) : id = id ?? const Uuid().v4(),
       dataCriacao = dataCriacao ?? DateTime.now() {
    if (titulo.isEmpty) {
      throw ArgumentError('Título não pode ser vazio');
    }

    if (dataLimite != null && dataLimite!.isBefore(this.dataCriacao)) {
      throw ArgumentError(
        'Data limite não pode ser anterior à data de criação',
      );
    }
  }

  Tarefa copyWith({
    String? titulo,
    String? descricao,
    Categoria? categoria,
    bool? concluida,
    DateTime? dataConclusao,
    DateTime? dataLimite,
    TurnoDia? turno,
  }) {
    return Tarefa(
      id: id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      concluida: concluida ?? this.concluida,
      dataCriacao: dataCriacao,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      dataLimite: dataLimite ?? this.dataLimite,
      turno: turno ?? this.turno,
    );
  }

  bool get estaVencida {
    if (dataLimite == null || concluida) return false;
    return DateTime.now().isAfter(dataLimite!);
  }

  int? get diasRestantes {
    if (dataLimite == null) return null;
    final diferenca = dataLimite!.difference(DateTime.now()).inDays;
    return diferenca < 0 ? 0 : diferenca;
  }

  @override
  String toString() {
    return 'Tarefa(id: $id, titulo: $titulo, categoria: ${categoria.label}, '
        'turno: ${turno.label}, concluida: $concluida, '
        'dataCriacao: $dataCriacao, dataLimite: $dataLimite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tarefa && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      categoria: Categoria.values[map['categoria'] as int],
      concluida: map['concluida'] as bool,
      turno: TurnoDia.values[map['turno'] as int],
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      dataConclusao: map['dataConclusao'] != null
          ? DateTime.parse(map['dataConclusao'] as String)
          : null,
      dataLimite: map['dataLimite'] != null
          ? DateTime.parse(map['dataLimite'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria.index,
      'concluida': concluida,
      'turno': turno.index,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataConclusao': dataConclusao?.toIso8601String(),
      'dataLimite': dataLimite?.toIso8601String(),
    };
  }
}
