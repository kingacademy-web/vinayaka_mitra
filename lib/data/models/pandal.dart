class Pandal {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String type; // 'pandal' or 'immersion'
  final String idolHeight;
  final String specialAttraction;
  final String? contact;
  final String? imageUrl;

  Pandal({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.type,
    required this.idolHeight,
    required this.specialAttraction,
    this.contact,
    this.imageUrl,
  });

  factory Pandal.fromMap(Map<String, dynamic> m, [String? fallbackId]) => Pandal(
    id: m['id'] ?? fallbackId ?? '',
    name: m['name'] ?? '',
    address: m['address'] ?? '',
    lat: (m['lat'] as num?)?.toDouble() ?? 0.0,
    lng: (m['lng'] as num?)?.toDouble() ?? 0.0,
    type: m['type'] ?? 'pandal',
    idolHeight: m['idolHeight'] ?? 'Normal',
    specialAttraction: m['specialAttraction'] ?? '',
    contact: m['contact'],
    imageUrl: m['imageUrl'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'address': address,
    'lat': lat,
    'lng': lng,
    'type': type,
    'idolHeight': idolHeight,
    'specialAttraction': specialAttraction,
    'contact': contact,
    'imageUrl': imageUrl,
  };
}
