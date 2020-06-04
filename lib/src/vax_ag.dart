import 'package:json_annotation/json_annotation.dart';

class Dz {
  final String _name;

  const Dz._(this._name);

  String toString() => _name;

  static const Dz cholera = Dz._('Cholera');
  static const Dz diphtheria = Dz._('Diphtheria');
  static const Dz hep_a = Dz._('HepA');
  static const Dz hep_b = Dz._('HepB');
  static const Dz hib = Dz._('Hib');
  static const Dz hpv = Dz._('HPV');
  static const Dz influenza = Dz._('Influenza');
  static const Dz japanese_encephalitis = Dz._('Japanese Encephalitis');
  static const Dz meningococcal = Dz._('Meningococcal');
  static const Dz meningococcal_b = Dz._('Meningococcal B');
  static const Dz measles = Dz._('Measles');
  static const Dz mumps = Dz._('Mumps');
  static const Dz pertussis = Dz._('Pertussis');
  static const Dz pneumococcal = Dz._('Pneumococcal');
  static const Dz polio = Dz._('Polio');
  static const Dz rabies = Dz._('Rabies');
  static const Dz rotavirus = Dz._('Rotavirus');
  static const Dz rubella = Dz._('Rubella');
  static const Dz tetanus = Dz._('Tetanus');
  static const Dz typhoid = Dz._('Typhoid');
  static const Dz varicella = Dz._('Varicella');
  static const Dz yellow_fever = Dz._('Yellow Fever');
  static const Dz zoster = Dz._('Zoster');
}

enum VaxAg {
  @JsonValue('Cholera')
  cholera,
  @JsonValue('Diphtheria')
  diphtheria,
  @JsonValue('HepA')
  hep_a,
  @JsonValue('HepB')
  hep_b,
  @JsonValue('Hib')
  hib,
  @JsonValue('HPV')
  hpv,
  @JsonValue('Influenza')
  influenza,
  @JsonValue('Japanese Encephalitis')
  japanese_encephalitis,
  @JsonValue('Meningococcal')
  meningococcal,
  @JsonValue('Meningococcal B')
  meningococcal_b,
  @JsonValue('Measles')
  measles,
  @JsonValue('Mumps')
  mumps,
  @JsonValue('Pertussis')
  pertussis,
  @JsonValue('Pneumococcal')
  pneumococcal,
  @JsonValue('Polio')
  polio,
  @JsonValue('Rabies')
  rabies,
  @JsonValue('Rotavirus')
  rotavirus,
  @JsonValue('Rubella')
  rubella,
  @JsonValue('Tetanus')
  tetanus,
  @JsonValue('Typhoid')
  typhoid,
  @JsonValue('Varicella')
  varicella,
  @JsonValue('Yellow Fever')
  yellow_fever,
  @JsonValue('Zoster')
  zoster,
  @JsonValue('Unknown')
  unknown,
}

VaxAg getVaxAg(String ag) {
  switch (ag) {
  }
  return VaxAg.unknown;
}

String agString(VaxAg ag) {
  switch (ag) {
    case VaxAg.cholera:
      return 'Cholera';
    case VaxAg.diphtheria:
      return 'Diphtheria';
    case VaxAg.hep_a:
      return 'HepA';
    case VaxAg.hep_b:
      return 'HepB';
    case VaxAg.hib:
      return 'Hib';
    case VaxAg.hpv:
      return 'HPV';
    case VaxAg.influenza:
      return 'Influenza';
    case VaxAg.japanese_encephalitis:
      return 'Japanese Encephalitis';
    case VaxAg.meningococcal:
      return 'Meningococcal';
    case VaxAg.meningococcal_b:
      return 'Meningococcal B';
    case VaxAg.measles:
      return 'Measles';
    case VaxAg.mumps:
      return 'Mumps';
    case VaxAg.pertussis:
      return 'Pertussis';
    case VaxAg.pneumococcal:
      return 'Pneumococcal';
    case VaxAg.polio:
      return 'Polio';
    case VaxAg.rabies:
      return 'Rabies';
    case VaxAg.rotavirus:
      return 'Rotavirus';
    case VaxAg.rubella:
      return 'Rubella';
    case VaxAg.tetanus:
      return 'Tetanus';
    case VaxAg.typhoid:
      return 'Typhoid';
    case VaxAg.varicella:
      return 'Varicella';
    case VaxAg.yellow_fever:
      return 'Yellow Fever';
    case VaxAg.zoster:
      return 'Zoster';
    case VaxAg.unknown:
      return 'unknown';
  }
  return 'unknown';
}
