import 'enums.dart';

class Meta {
  final String titulo;
  final String descricao;
  final PeriodoMeta periodo;
  final Categoria categoria;
  final StatusMeta status;

  Meta({
    required this.titulo,
    required this.descricao,
    required this.periodo,
    required this.categoria,
    this.status = StatusMeta.naoAtingida,
  });

  Meta copyWith({
    String? titulo,
    String? descricao,
    PeriodoMeta? periodo,
    Categoria? categoria,
    StatusMeta? status,
  }) {
    return Meta(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      periodo: periodo ?? this.periodo,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Meta(titulo: $titulo, periodo: ${periodo.label}, categoria: ${categoria.label}, status: ${status.label})';
  }

  /*
  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      periodo: PeriodoMeta.values[map['periodo'] as int],
      categoria: Categoria.values[map['categoria'] as int],
      status: StatusMeta.values[map['status'] as int],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'periodo': periodo.index,
      'categoria': categoria.index,
      'status': status.index,
    };
  }
  */
}
