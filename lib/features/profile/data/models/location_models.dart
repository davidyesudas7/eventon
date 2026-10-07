class PincodeDetails {
  final String pincode;
  final String district;
  final String state;
  final String officeName;

  PincodeDetails({
    required this.pincode,
    required this.district,
    required this.state,
    required this.officeName,
  });

  factory PincodeDetails.fromJson(Map<String, dynamic> json) {
    return PincodeDetails(
      pincode: json['pincode'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      officeName: json['officeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pincode': pincode,
      'district': district,
      'state': state,
      'officeName': officeName,
    };
  }
}

class LsgDetails {
  final String id;
  final String name;
  final String type;
  final String district;
  final String state;

  LsgDetails({
    required this.id,
    required this.name,
    required this.type,
    required this.district,
    required this.state,
  });

  factory LsgDetails.fromJson(Map<String, dynamic> json) {
    return LsgDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'district': district,
      'state': state,
    };
  }
}

class HomeLocation {
  final PincodeDetails pincodeDetails;
  final LsgDetails? lsgDetails;

  HomeLocation({
    required this.pincodeDetails,
    this.lsgDetails,
  });

  factory HomeLocation.fromJson(Map<String, dynamic> json) {
    return HomeLocation(
      pincodeDetails: PincodeDetails.fromJson(json['pincodeDetails'] as Map<String, dynamic>),
      lsgDetails: json['lsgDetails'] != null ? LsgDetails.fromJson(json['lsgDetails'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pincodeDetails': pincodeDetails.toJson(),
      'lsgDetails': lsgDetails?.toJson(),
    };
  }
}
