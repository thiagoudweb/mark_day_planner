enum PeriodoMeta { semanal, mensal, anual }

enum StatusMeta { atingida, parcial, naoAtingida }

enum Categoria { estudo, trabalho, saude, financas, pessoal, lazer }

extension LabelPeriodoMeta on PeriodoMeta {
  String get label {
    switch (this) {
      case PeriodoMeta.semanal:
        return 'Semanal';
      case PeriodoMeta.mensal:
        return 'Mensal';
      case PeriodoMeta.anual:
        return 'Anual';
    }
  }
}

extension LabelStatusMeta on StatusMeta {
  String get label {
    switch (this) {
      case StatusMeta.atingida:
        return 'Atingida';
      case StatusMeta.parcial:
        return 'Parcial';
      case StatusMeta.naoAtingida:
        return 'Não atingida';
    }
  }
}

extension LabelCategoria on Categoria {
  String get label {
    switch (this) {
      case Categoria.estudo:
        return 'Estudo';
      case Categoria.trabalho:
        return 'Trabalho';
      case Categoria.saude:
        return 'Saúde';
      case Categoria.financas:
        return 'Finanças';
      case Categoria.pessoal:
        return 'Pessoal';
      case Categoria.lazer:
        return 'Lazer';
    }
  }
}
