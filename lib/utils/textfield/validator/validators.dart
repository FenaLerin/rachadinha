import 'package:flux_validator_dart/flux_validator_dart.dart' as flux_validator;
import 'package:rachadinha/utils/textfield/mask_off.dart';

import '../my_ddd.dart';
import 'validator_interface.dart';

class Validators extends Ivalidators {
  Validators({someText}) : super(someText: someText);

  @override
  String? obrigatorio(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    return null;
  }

  @override
  String? email(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    if (!text.contains('@')) return "E-Mail inválido";
    return null;
  }

  @override
  String? specialCharacters(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validCharacters.hasMatch(text)) {
      return "O campo não pode conter simbolos ou números";
    }
    return null;
  }

  @override
  String? nome(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    final validCharacters =
        RegExp(r'^[a-zA-Z-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+$');
    if (!validCharacters.hasMatch(text)) {
      return "O campo não pode conter símbolos ou números";
    }
    return null;
  }

  @override
  String? cpf(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    text = MaskOff.pullMask(text);
    if (flux_validator.validatorCpf(text)) return "CPF inválido";
    return null;
  }

  @override
  String? cnpj(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    text = MaskOff.pullMask(text);
    if (flux_validator.validatorCnpj(text)) return "CNPJ inválido";
    return null;
  }

  @override
  String? creditCard(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    text = MaskOff.pullMask(text);
    final validCharacters = RegExp(r'^[0-9]+$');
    if (!validCharacters.hasMatch(text)) return "Somente números";
    if (text.length < 14 || text.length > 16) {
      return "Número do cartão inválido";
    }
    return null;
  }

  @override
  String? phone(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    if (DDD.checkDDD(text)) return "DDD Inválido";
    String textSemMask = MaskOff.pullMask(text);
    if (textSemMask.length < 10 || textSemMask.length > 11) {
      return "Telefone inválido";
    }
    return null;
  }

  @override
  String? date(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    String textSemMask = MaskOff.pullMask(text);
    if (textSemMask.length != 8) return "Formato de DD/MM/AAAA";
    String dia = textSemMask.substring(0, 2);
    String mes = textSemMask.substring(2, 4);
    int diaInt = int.parse(dia);
    int mesInt = int.parse(mes);
    if (diaInt == 0 || mesInt == 0) return "Data inválida";
    return null;
  }

  @override
  String? creditCardDate(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    var textSemMask = MaskOff.pullMask(text);
    if (textSemMask.length != 4) return "Formato de MM/AA";
    String mes = textSemMask.substring(0, 2);
    int mesInt = int.parse(mes);
    if (mesInt > 12 || mesInt < 1) return "Data inválida";
    return null;
  }

  @override
  String? cvv(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    if (text.length < 3 || text.length > 4) return "Campo de 3 a 4 dígitos";
    return null;
  }

  @override
  String? password(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    if (text.length < 6) return "Mínimo de 6 dígitos";
    return null;
  }

  @override
  String? confirmaPassword(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";

    if (text.length < 6) return "Mínimo de 6 dígitos";

    if (text != someText) return "As senhas não são iguais";

    return null;
  }

  @override
  String? confirmaCampo(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";

    if (text != someText) return "Campo errado";

    return null;
  }

  @override
  String? validatorCode(String? text) {
    if ((text == null) || text.isEmpty) return "";
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validCharacters.hasMatch(text)) return "";
    return null;
  }

  String? validatorCEP(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    text = MaskOff.pullMask(text);
    final validCharacters = RegExp(r'^\d{5}\d{3}$');
    if (!validCharacters.hasMatch(text)) return "CEP inválido";
    return null;
  }

  String? validatorNumero(String? text) {
    if ((text == null) || text.isEmpty) return "Campo vazio";
    final validCharacters = RegExp(r'^[0-9]+$');
    if (!validCharacters.hasMatch(text)) return "Somente números";
    return null;
  }
}
