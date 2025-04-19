// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String name;
  String description;
  String image;
  Category({
    required this.name,
    required this.description,
    required this.image,
  });
  Category copyWith({
    String? name,
    String? description,
    String? image,
  }) {
    return Category(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map ['image'] as String,
    );
  }
  
}
