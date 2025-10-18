import 'package:rachadinha/utils/textfield/mask_off.dart';

class DDD {
  static bool checkDDD(String text) {
    String aux = MaskOff.pullMask(text);
    String ddd = aux[0];
    ddd += aux[1];
    if (listDDD.contains(ddd.toString())) {
      return false;
    } else {
      return true;
    }
  }

  static List listDDD = [
    ...[
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '21',
      '22',
      '24',
      '27'
    ],
    ...[
      '32',
      '33',
      '34',
      '35',
      '37',
      '38',
      '41',
      '42',
      '43',
      '44',
      '45',
      '28',
      '31'
    ],
    ...[
      '51',
      '53',
      '54',
      '55',
      '61',
      '62',
      '63',
      '64',
      '65',
      '66',
      '67',
      '46',
      '47'
    ],
    ...[
      '74',
      '75',
      '77',
      '79',
      '81',
      '82',
      '83',
      '84',
      '85',
      '86',
      '87',
      '88',
      '89'
    ],
    ...[
      '48',
      '49',
      '68',
      '69',
      '71',
      '73',
      '91',
      '92',
      '93',
      '94',
      '95',
      '96',
      '97',
      '98',
      '99'
    ]
  ];
}
