class Images {
  final int id;
  final String src;
  final String alt;

  Images({
    required this.id,
    required this.src,
    required this.alt,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: json["id"] as int,
        src: json["src"]['portrait'] as String,
        alt: json["alt"] as String,
      );

  Images.emptyConstructor({
    this.id = 0,
    this.src = "",
    this.alt = "",
  });
}
