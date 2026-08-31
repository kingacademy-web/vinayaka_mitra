class Recipe {
  final String id;
  final String nameTe;
  final String nameEn;
  final String description;
  final String prepTime;
  final String cookTime;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String significance;
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.nameTe,
    required this.nameEn,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.significance,
    this.imageUrl,
  });

  factory Recipe.fromMap(Map<String, dynamic> m, [String? fallbackId]) => Recipe(
    id: m['id'] ?? fallbackId ?? '',
    nameTe: m['nameTe'] ?? '',
    nameEn: m['nameEn'] ?? '',
    description: m['description'] ?? '',
    prepTime: m['prepTime'] ?? '15 mins',
    cookTime: m['cookTime'] ?? '20 mins',
    servings: m['servings'] ?? 4,
    ingredients: (m['ingredients'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    instructions: (m['instructions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    significance: m['significance'] ?? '',
    imageUrl: m['imageUrl'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nameTe': nameTe,
    'nameEn': nameEn,
    'description': description,
    'prepTime': prepTime,
    'cookTime': cookTime,
    'servings': servings,
    'ingredients': ingredients,
    'instructions': instructions,
    'significance': significance,
    'imageUrl': imageUrl,
  };
}
