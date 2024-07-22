

class Article {
  final String content;
  final String description;
  final String image;
  final DateTime publishedAt;
  final Map<String, dynamic> source;
  final String title;
  final String url;
  final String? summary;
  final String? impact;
  final String? degreeOfImpact;
  final String? mostAffectedCountry;
  final String? consequences;
  final String? benefitsOfAction;
  final String? id;
  final String responsibility ;
  final String? urgency ;
  final String? responsibilityDetail ;
  final String? rippleEffect ;
  final String? urgencyDetail ;


  Article({
    required this.content,
    required this.description,
    required this.image,
    required this.publishedAt,
    required this.source,
    required this.title,
    required this.url,
    required this.summary,
    required this.impact,
    required this.degreeOfImpact,
    required this.mostAffectedCountry,
    required this.consequences,
    required this.benefitsOfAction,
    required this.responsibility,
    required this.urgency,
    required this.id,
    required this.responsibilityDetail,
    required this.rippleEffect,
    required this.urgencyDetail,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      content: json['content'] ?? '', // Provide default values if null
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      source: json['source'] ?? {},
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      summary: json['summary']?? '',
      impact: json['impact']?? '',
      degreeOfImpact: json['degreeOfImpact']?? '',
      mostAffectedCountry: json['mostAffectedCountry']?? '',
      consequences: json['consequences']?? '',
      benefitsOfAction: json['benefitsOfAction']?? '',
      urgency: json['urgency']?? '',
      responsibility: json['responsibility'] ?? '',
      id: json['id']?? '',
      responsibilityDetail: json['responsibilityDetail']?? '',
      rippleEffect: json['rippleEffect']?? '',
      urgencyDetail: json['urgencyDetail']?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'description': description,
      'image': image,
      'publishedAt': publishedAt.toIso8601String(),
      'source': source,
      'title': title,
      'url': url,
      'summary': summary,
      'impact': impact,
      'degreeOfImpact': degreeOfImpact,
      'mostAffectedCountry': mostAffectedCountry,
      'consequences': consequences,
      'benefitsOfAction': benefitsOfAction,
      'responsibility' : responsibility,
    };
  }
}