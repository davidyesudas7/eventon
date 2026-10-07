class AppUser {
  final String id;
  final String? email;
  final String fullName;
  final List<String> roles;
  final String? phone;
  final bool? phoneSignIn;
  final String? businessName;
  final String? bio;
  final String? profilePhotoUrl;
  final String? territoryId;
  final String? basePincode;
  final String? lsgId;

  const AppUser({
    required this.id,
    this.email,
    required this.fullName,
    required this.roles,
    this.phone,
    this.phoneSignIn,
    this.businessName,
    this.bio,
    this.profilePhotoUrl,
    this.territoryId,
    this.basePincode,
    this.lsgId,
  });
}
