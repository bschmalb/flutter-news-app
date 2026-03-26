enum HomepageContentItemType {
  freeHtml('free-html'),
  unknown(null)
  ;

  const HomepageContentItemType(this.wireValue);

  final String? wireValue;

  static HomepageContentItemType fromWire(String? wireValue) => HomepageContentItemType.values.firstWhere(
    (value) => value.wireValue == wireValue,
    orElse: () => HomepageContentItemType.unknown,
  );
}

enum HomepagePageContentItemType {
  teaserCluster('teaser-cluster'),
  freeHtml('free-html'),
  unknown(null)
  ;

  const HomepagePageContentItemType(this.wireValue);

  final String? wireValue;

  static HomepagePageContentItemType fromWire(String? wireValue) => HomepagePageContentItemType.values.firstWhere(
    (value) => value.wireValue == wireValue,
    orElse: () => HomepagePageContentItemType.unknown,
  );
}

enum HomepageLayout {
  homeAufmacher3('home_aufmacher_3'),
  homemix('homemix'),
  abc('abc'),
  singleTopbox('single_topbox'),
  abAbCde('ab_ab_cde'),
  abAc('ab_ac'),
  abcdEfgh('abcd_efgh'),
  unknown(null)
  ;

  const HomepageLayout(this.wireValue);

  final String? wireValue;

  static HomepageLayout fromWire(String? wireValue) => HomepageLayout.values.firstWhere(
    (value) => value.wireValue == wireValue,
    orElse: () => HomepageLayout.unknown,
  );
}
