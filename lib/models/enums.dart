import 'dart:ui';

enum TipoDuracao { meiaHora, umaHora, turno }

extension TipoDuracaoLabel on TipoDuracao {
  String get label {
    switch (this) {
      case TipoDuracao.meiaHora:
        return 'Meia hora';
      case TipoDuracao.umaHora:
        return 'Uma hora';
      case TipoDuracao.turno:
        return 'Turno do dia';
    }
  }
}

enum PeriodoMeta { semanal, mensal, anual }

enum StatusMeta { atingida, parcial, naoAtingida }

enum Categoria { estudo, trabalho, saude, financas, pessoal, lazer }

enum TurnoDia { manha, tarde, noite }

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

extension CorCategoria on Categoria {
  Color get cor {
    switch (this) {
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
}

extension LabelTurnoDia on TurnoDia {
  String get label {
    switch (this) {
      case TurnoDia.manha:
        return 'Manhã';
      case TurnoDia.tarde:
        return 'Tarde';
      case TurnoDia.noite:
        return 'Noite';
    }
  }

  static TurnoDia fromDateTime(DateTime dateTime) {
    final hora = dateTime.hour;
    if (hora >= 5 && hora < 12) {
      return TurnoDia.manha;
    } else if (hora >= 12 && hora < 18) {
      return TurnoDia.tarde;
    } else {
      return TurnoDia.noite;
    }
  }
}