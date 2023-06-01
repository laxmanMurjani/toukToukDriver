enum UserModuleType { TAXI, DELIVERY, BOTH }

extension StringToUserModuleType on String {
  UserModuleType get userModuleType {
    switch (this) {
      case 'TAXI':
        return UserModuleType.TAXI;
      case 'DELIVERY':
        return UserModuleType.DELIVERY;
      case 'BOTH':
        return UserModuleType.BOTH;
    }
    return UserModuleType.BOTH;
  }
}

extension UserModuleTypeString on UserModuleType {
  String get name {
    switch (this) {
      case UserModuleType.TAXI:
        return "TAXI";
      case UserModuleType.DELIVERY:
        return "DELIVERY";
      case UserModuleType.BOTH:
        return "BOTH";
    }
    return "BOTH";
  }
}
