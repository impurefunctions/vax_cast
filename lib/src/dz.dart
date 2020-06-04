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
  static const Dz unknown = Dz._('unknown');

  static Dz parse(String ag) {
    switch (ag) {
      case 'Cholera':
        return cholera;
      case 'Diphtheria':
        return diphtheria;
      case 'HepA':
        return hep_a;
      case 'HepB':
        return hep_b;
      case 'Hib':
        return hib;
      case 'HPV':
        return hpv;
      case 'Influenza':
        return influenza;
      case 'Japanese Encephalitis':
        return japanese_encephalitis;
      case 'Meningococcal':
        return meningococcal;
      case 'Meningococcal B':
        return meningococcal_b;
      case 'Measles':
        return measles;
      case 'Mumps':
        return mumps;
      case 'Pertussis':
        return pertussis;
      case 'Pneumococcal':
        return pneumococcal;
      case 'Polio':
        return polio;
      case 'Rabies':
        return rabies;
      case 'Rotavirus':
        return rotavirus;
      case 'Rubella':
        return rubella;
      case 'Tetanus':
        return tetanus;
      case 'Typhoid':
        return typhoid;
      case 'Varicella':
        return varicella;
      case 'Yellow Fever':
        return yellow_fever;
      case 'Zoster':
        return zoster;
      default:
        return unknown;
    }
  }
}
