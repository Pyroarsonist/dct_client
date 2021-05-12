enum Sex { female, male }

extension SexExtenstion on Sex {
  String get name {
    switch (this) {
      case Sex.female:
        return 'female';
      case Sex.male:
        return 'male';
      default:
        return 'unknown';
    }
  }
}
