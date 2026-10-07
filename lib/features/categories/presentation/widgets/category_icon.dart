import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String? iconName;
  final String? iconUrl;
  final double size;
  final Color? color;

  const CategoryIcon({
    super.key,
    this.iconName,
    this.iconUrl,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      return Image.network(
        iconUrl!,
        width: size,
        height: size,
        color: color,
        errorBuilder: (context, error, stackTrace) => _buildIcon(),
      );
    }
    return _buildIcon();
  }

  Widget _buildIcon() {
    final Map<String, IconData> lucideToMaterial = {
      'sparkles': Icons.auto_awesome,
      'shirt': Icons.checkroom,
      'cake': Icons.cake,
      'utensils': Icons.restaurant,
      'music-2': Icons.music_note,
      'flower-2': Icons.local_florist,
      'clipboard-list': Icons.assignment,
      'mail': Icons.mail,
      'party-popper': Icons.celebration,
      'hand-heart': Icons.back_hand,
      'tent': Icons.holiday_village,
      'camera': Icons.camera_alt,
      'gift': Icons.card_giftcard,
      'speaker': Icons.speaker,
      'drum': Icons.music_video,
      'car': Icons.directions_car,
      'building-2': Icons.location_city,
    };

    final iconData =
        (iconName != null && lucideToMaterial.containsKey(iconName))
        ? lucideToMaterial[iconName]!
        : Icons.category;

    return Icon(iconData, size: size, color: color);
  }
}
