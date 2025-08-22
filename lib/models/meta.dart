import 'package:uuid/uuid.dart';
import 'enums.dart';

class Meta {
  final String id;
  final String titulo;
  final String descricao;
  final PeriodoMeta periodo;
  final Categoria categoria;
  final StatusMeta status;
  final DateTime dataCriacao;
  final DateTime? dataConclusao;
  final DateTime? dataLimite;

  Meta({
    required this.titulo,
    required this.descricao,
    required this.periodo,
    required this.categoria,
    this.status = StatusMeta.naoAtingida,
    String? id,
    DateTime? dataCriacao,
    this.dataConclusao,
    this.dataLimite,
  }) :
        id = id ?? const Uuid().v4(),
        dataCriacao = dataCriacao ?? DateTime.now() {

    if (titulo.isEmpty) {
      throw ArgumentError('Título não pode ser vazio');
    }

    if (dataLimite != null && dataLimite!.isBefore(dataCriacao ?? DateTime.now())) {
      throw ArgumentError('Data limite não pode ser anterior à data de criação');
    }
  }

  Meta copyWith({
    String? id,
    String? titulo,
    String? descricao,
    PeriodoMeta? periodo,
    Categoria? categoria,
    StatusMeta? status,
    DateTime? dataCriacao,
    DateTime? dataConclusao,
    DateTime? dataLimite,
  }) {
    return Meta(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      periodo: periodo ?? this.periodo,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataConclusao: dataConclusao ?? this.dataConclusao,
      dataLimite: dataLimite ?? this.dataLimite,
    );
  }

  bool get estaVencida {
    if (dataLimite == null) return false;
    return DateTime.now().isAfter(dataLimite!);
  }

  int? get diasRestantes {
    if (dataLimite == null) return null;
    final diferenca = dataLimite!.difference(DateTime.now());
    return diferenca.inDays;
  }

  double get progresso {
    switch (status) {
      case StatusMeta.naoAtingida:
        return 0.0;
      case StatusMeta.parcial:
        return 0.5;
      case StatusMeta.atingida:
        return 1.0;
    }
  }

  @override
  String toString() {
    return 'Meta(id: $id, titulo: $titulo, periodo: ${periodo.label}, '
        'categoria: ${categoria.label}, status: ${status.label}, '
        'dataCriacao: $dataCriacao, dataLimite: $dataLimite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meta && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      periodo: PeriodoMeta.values[map['periodo'] as int],
      categoria: Categoria.values[map['categoria'] as int],
      status: StatusMeta.values[map['status'] as int],
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
      'periodo': periodo.index,
      'categoria': categoria.index,
      'status': status.index,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataConclusao': dataConclusao?.toIso8601String(),
      'dataLimite': dataLimite?.toIso8601String(),
    };
  }
}