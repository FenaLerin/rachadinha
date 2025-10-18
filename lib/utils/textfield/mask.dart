import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// abstract class Mask{
//   List<TextInputFormatter> phone();
// }
enum MaskType {
  phone,
  cpf,
  cnpj,
  placa,
  time,
  inscricaoEstadual,
  data,
  dataCard,
  cep,
  dataHora,
  cardNumber,
  cvv,
}

class CustomMask {
  String setMask(String text, MaskType maskType) {
    try {
      if (text == "") return "";
      String mask = "";

      text = text.replaceAll(RegExp(r'[-/._(): ]'), "");

      switch (maskType) {
        case MaskType.phone:
          if (text.length == 11) {
            mask = "(##) #####-####";
          } else if (text.length == 10) {
            mask = "(##) ####-####";
          } else {
            return text;
          }
          break;
        case MaskType.cpf:
          mask = "###.###.###-##";
          break;
        case MaskType.cnpj:
          mask = "##.###.###/####-##";
          break;
        case MaskType.dataCard:
          mask = "##/##";
          break;
        case MaskType.cep:
          mask = "#####-###";
          break;
        case MaskType.placa:
          mask = "###-####";
          break;
        case MaskType.time:
          mask = "##:##";
          break;
        default:
          return text;
      }

      String outpuut = '';

      int countText = 0;
      for (var i = 0; i < mask.length; i++) {
        try {
          if (mask[i] == '#') {
            outpuut += text[countText];
            countText++;
          } else {
            outpuut += mask[i];
          }
        } catch (e) {
          // ignore: avoid_print
          print('numero de telefone contem somente ${text.length} caracteres');
        }
      }
      return outpuut;
    } catch (e) {
      return text;
    }
  }

  List<TextInputFormatter> getMask(MaskType maskType) {
    switch (maskType) {
      case MaskType.phone:
        return [
          MaskTextInputFormatter(
              mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.cpf:
        return [
          MaskTextInputFormatter(
              mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.cnpj:
        return [
          MaskTextInputFormatter(
              mask: "##.###.###/####-##", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.placa:
        return [
          MaskTextInputFormatter(
              mask: "###-####", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.time:
        return [
          MaskTextInputFormatter(mask: "##:##", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.inscricaoEstadual:
        return [
          MaskTextInputFormatter(
              mask: "###.###.###.###", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.data:
        return [
          MaskTextInputFormatter(
              mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.dataCard:
        return [
          MaskTextInputFormatter(mask: "##/##", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.cep:
        return [
          MaskTextInputFormatter(
              mask: "#####-###", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.dataHora:
        return [
          MaskTextInputFormatter(
              mask: "##/##/#### ##:##", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.cardNumber:
        return [
          MaskTextInputFormatter(
              mask: "####-####-####-####", filter: {"#": RegExp(r'[0-9]')})
        ];
      case MaskType.cvv:
        return [
          MaskTextInputFormatter(mask: "####", filter: {"#": RegExp(r'[0-9]')})
        ];
    }
  }
}
