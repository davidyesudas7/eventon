import 'package:flutter/material.dart';

class OccasionService {
  const OccasionService({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class Occasion {
  const Occasion({
    required this.id,
    required this.title,
    required this.tagline,
    required this.services,
  });

  final String id;
  final String title;
  final String tagline;
  final List<OccasionService> services;
}

const List<Occasion> mockOccasions = [
  Occasion(
    id: 'wedding',
    title: 'Wedding',
    tagline: 'Everything for the big day',
    services: [
      OccasionService(
        title: 'Bridal makeup & styling',
        description: 'Makeup artists and hair stylists for brides, grooms and the family.',
        icon: Icons.face_retouching_natural,
      ),
      OccasionService(
        title: 'Bridal wear & costumes',
        description: 'Wedding sarees, lehengas, gowns and sherwanis — to buy, tailor or rent.',
        icon: Icons.checkroom,
      ),
      OccasionService(
        title: 'Cakes & desserts',
        description: 'Wedding and birthday cakes, dessert tables and sweets.',
        icon: Icons.cake,
      ),
      OccasionService(
        title: 'Catering',
        description: 'Grand feast, traditional sadhya, multi-cuisine buffets and live counters.',
        icon: Icons.room_service,
      ),
      OccasionService(
        title: 'Photography & videography',
        description: 'Candid photographers, cinematic reels, traditional videography and albums.',
        icon: Icons.camera_alt,
      ),
    ],
  ),
];

Occasion? findOccasionById(String id) {
  for (final o in mockOccasions) {
    if (o.id == id) return o;
  }
  return null;
}
