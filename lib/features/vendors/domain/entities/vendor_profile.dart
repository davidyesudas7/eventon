class VendorProfile {
  final String id;
  final String fullName;
  final String? businessName;
  final String? bio;
  final String? profilePhotoUrl;
  final double? ratingAvg;
  final int? ratingCount;

  const VendorProfile({
    required this.id,
    required this.fullName,
    this.businessName,
    this.bio,
    this.profilePhotoUrl,
    this.ratingAvg,
    this.ratingCount,
  });

  /// Display name to show as primary heading.
  /// If businessName is present, prefer it; otherwise fallback to fullName.
  String get displayName {
    if (businessName != null && businessName!.trim().isNotEmpty) {
      return businessName!.trim();
    }
    return fullName.trim();
  }

  /// Subtitle below name.
  /// If businessName is present, fullName is shown as subtitle (e.g. "Vendor Lijo").
  /// If businessName is null/same, and there are no reviews, "New on EventOn" can be shown.
  String? get subtitle {
    if (businessName != null &&
        businessName!.trim().isNotEmpty &&
        fullName.trim().isNotEmpty &&
        fullName.trim() != businessName!.trim()) {
      return fullName.trim();
    }
    return null;
  }

  VendorProfile copyWith({
    String? id,
    String? fullName,
    String? businessName,
    String? bio,
    String? profilePhotoUrl,
    double? ratingAvg,
    int? ratingCount,
  }) {
    return VendorProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      businessName: businessName ?? this.businessName,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}
