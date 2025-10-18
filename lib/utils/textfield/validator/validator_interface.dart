abstract class Ivalidators {
  String? someText;
  Ivalidators({this.someText});
  String? obrigatorio(String? text);

  String? email(String? text);

  String? specialCharacters(String text);

  String? nome(String? text);

  String? cpf(String? text);

  String? cnpj(String? text);

  String? creditCard(String? text);

  String? phone(String? text);

  String? date(String? text);

  String? creditCardDate(String? text);

  String? cvv(String? text);

  String? password(String? text);

  String? confirmaPassword(String? text);

  String? validatorCode(String? text);

  String? confirmaCampo(String? text);
}
