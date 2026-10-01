import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All services', style: AppTextStyles.headlineMd),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
          children: [
            _buildServiceIcon(Icons.face_retouching_natural, 'Bridal makeup\n& styling'),
            _buildServiceIcon(Icons.checkroom, 'Bridal wear\n& costumes'),
            _buildServiceIcon(Icons.cake, 'Cakes &\ndesserts'),
            _buildServiceIcon(Icons.room_service, 'Catering'),
            _buildServiceIcon(Icons.headphones, 'DJ &\nentertainment'),
            _buildServiceIcon(Icons.celebration, 'Decoration &\nstage'),
            _buildServiceIcon(Icons.event_available, 'Event &\nwedding...'),
            _buildServiceIcon(Icons.mail, 'Invitations &\nprinting'),
            _buildServiceIcon(Icons.child_care, 'Kids\' party\nentertainment'),
            _buildServiceIcon(Icons.pan_tool, 'Mehendi\nartists'),
            _buildServiceIcon(Icons.holiday_village, 'Pandal, tent\n& furniture'),
            _buildServiceIcon(Icons.camera_alt, 'Photography\n& videography'),
            _buildServiceIcon(Icons.car_rental, 'Travel &\ntransport'),
            _buildServiceIcon(Icons.location_city, 'Venues'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surfaceMintPill,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(icon, color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSm.copyWith(color: AppColors.textPrimary, fontSize: 11.5),
          maxLines: 2,
        ),
      ],
    );
  }
}
