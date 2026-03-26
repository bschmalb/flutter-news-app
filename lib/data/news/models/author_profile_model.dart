class AuthorProfileModel {
  const AuthorProfileModel({
    required this.id,
    required this.urlPath,
    required this.prename,
    required this.surname,
    required this.bio,
  });

  factory AuthorProfileModel.fromJson(Map<String, dynamic> json) {
    return AuthorProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      urlPath: json['urlPath'] as String?,
      prename: json['prename'] as String?,
      surname: json['surname'] as String?,
      bio: json['bio'] as String?,
    );
  }

  final int id;
  final String? urlPath;
  final String? prename;
  final String? surname;
  final String? bio;

  String get displayName {
    final fullName = [prename, surname].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ').trim();

    return fullName.isEmpty ? 'KSTA Redaktion' : fullName;
  }
}
