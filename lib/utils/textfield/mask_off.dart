class MaskOff {
  static String pullMask(String txt) {
    String rightText = '';
    for (var i = 0; i < txt.length; i++) {
      if (verifyCharacter(txt[i])) {
        rightText += txt[i];
      }
    }
    
    return rightText;
  }

  static bool verifyCharacter(letra) {
    var listCharacters = ['(', ')', '.', '-', '/', ' ', "\$", ":", "R"];
    for (var j = 0; j < listCharacters.length; j++) {
      if (letra == listCharacters[j]) {
        return false;
      }
    }
    return true;
  }
}
