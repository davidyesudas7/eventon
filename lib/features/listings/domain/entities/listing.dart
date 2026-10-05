class ListingPackage {
  const ListingPackage({
    required this.name,
    required this.price,
    this.duration,
    this.features = const [],
    this.excludedFeatures = const [],
  });

  final String name;
  final int price;
  final String? duration;
  final List<String> features;
  final List<String> excludedFeatures;
}

class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.providerName,
    required this.startingPrice,
    required this.about,
    required this.isNew,
    this.details = const {},
    this.packages = const [],
  });

  final String id;
  final String title;
  final String category;
  final String providerName;
  final int startingPrice;
  final String about;
  final bool isNew;
  final Map<String, String> details;
  final List<ListingPackage> packages;
}

const List<Listing> mockListings = [
  Listing(
    id: 'l_001',
    title: 'Royal Wedding Cars',
    category: 'Vehicle rental',
    providerName: 'Demo Provider',
    startingPrice: 6500,
    about: 'Chauffeur-driven sedans and vintage cars for weddings and photoshoots across the city.',
    isNew: true,
    details: {
      'Vehicle type': 'vintage',
      'Seating capacity': '4 seats',
      'Comes with a driver': 'Yes',
      'Event decoration available': 'Yes',
      'Max travel distance': '60 km',
    },
    packages: [
      ListingPackage(
        name: '4-hour rental',
        duration: '4 hours',
        price: 6500,
        features: ['Driver included'],
        excludedFeatures: ['Fuel not included'],
      ),
    ],
  ),
  Listing(
    id: 'l_002',
    title: 'Spice Route Catering',
    category: 'Catering',
    providerName: 'Spice Route',
    startingPrice: 650,
    about: 'Authentic traditional sadhya and multi-cuisine buffet for weddings and corporate events.',
    isNew: false,
    details: {
      'Cuisine types': 'Kerala, North Indian, Chinese',
      'Min guests': '50',
      'Max guests': '5000+',
    },
    packages: [
      ListingPackage(
        name: 'Standard Sadhya',
        price: 650,
        features: ['24 items', 'Banana leaf setup', 'Service staff included'],
      ),
    ],
  ),
  Listing(
    id: 'l_003',
    title: 'Elite Beat DJs & Sound',
    category: 'DJ & entertainment',
    providerName: 'Elite Productions',
    startingPrice: 15000,
    about: 'Premium sound systems, lighting setups and DJ services for live celebrations.',
    isNew: false,
    details: {
      'Genre': 'Bollywood, EDM, Commercial',
      'Equipment included': 'Yes',
      'Setup time': '2 hours',
    },
    packages: [
      ListingPackage(
        name: 'Standard DJ set',
        duration: '3 hours',
        price: 20000,
        features: ['2 Tops, 2 Bass', 'Basic lighting', 'DJ Artist'],
      ),
    ],
  ),
];

Listing? findListingById(String id) {
  for (final l in mockListings) {
    if (l.id == id) return l;
  }
  return null;
}
