import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: const Color(0xFF081B19), // Dark Hero Background
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Picker
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Set your location',
                        style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 16),
                    ],
                  ),
                  Text(
                    'See businesses near you',
                    style: AppTextStyles.labelSm.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Greeting
          Text(
            'Hi there,',
            style: AppTextStyles.headlineLg.copyWith(color: Colors.white),
          ),
          Text(
            'what are we celebrating?',
            style: AppTextStyles.headlineLg.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: 24),
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search 'venues'",
              hintStyle: const TextStyle(color: Colors.black38),
              prefixIcon: const Icon(Icons.search, color: Colors.black38),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9999),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          // Plan by occasion
          Text(
            'Plan by occasion',
            style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 195,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildOccasionCard('Wedding', '16 services', 'assets/images/design/EventOn_-_Mobile_Home.png'), // Placeholder image
                const SizedBox(width: 12),
                _buildOccasionCard('Engagement', '14 services', 'assets/images/design/EventOn_-_Mobile_Home.png'),
                const SizedBox(width: 12),
                _buildOccasionCard('Birthday', '11 services', 'assets/images/design/EventOn_-_Mobile_Home.png'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOccasionCard(String title, String subtitle, String imagePath) {
    return Container(
      width: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[800], // fallback
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image placeholder, using a solid color for now since images might not be loaded in pubspec
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(color: Colors.grey[700]), // TODO: Use Image.asset(imagePath) when assets are configured
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.black26, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSm.copyWith(color: Colors.white70),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -24.0, 0.0),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceBase,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Browse by service',
                style: AppTextStyles.headlineSm.copyWith(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () => context.go('/home/all-services'),
                child: Text(
                  'See all',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            childAspectRatio: 0.75,
            children: [
              _buildServiceIcon(Icons.location_city, 'Venues'),
              _buildServiceIcon(Icons.restaurant, 'Catering'),
              _buildServiceIcon(Icons.camera_alt, 'Photography\n&...'),
              _buildServiceIcon(Icons.celebration, 'Decoration &\nstage'),
              _buildServiceIcon(Icons.face, 'Bridal\nmakeup &...'),
              _buildServiceIcon(Icons.color_lens, 'Mehendi\nartists'),
              _buildServiceIcon(Icons.music_note, 'Traditional\nperformers'),
              _buildServiceIcon(Icons.cake, 'Cakes &\ndesserts'),
            ],
          ),
          const SizedBox(height: 24),
          _buildPlanningWeddingBanner(),
          const SizedBox(height: 32),
          _buildPopularNearYou(),
          const SizedBox(height: 32),
          _buildTrustBadges(),
          const SizedBox(height: 32),
          _buildPartnerCTA(),
        ],
      ),
    );
  }

  Widget _buildPlanningWeddingBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF2DF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PLANNING A WEDDING?',
                style: AppTextStyles.labelSm.copyWith(
                  color: const Color(0xFFB87616),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore curated vendors',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9822B),
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularNearYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular near you',
              style: AppTextStyles.headlineSm.copyWith(color: AppColors.textPrimary),
            ),
            Text(
              'See all',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All', isSelected: true),
              const SizedBox(width: 8),
              _buildFilterChip('Top rated'),
              const SizedBox(width: 8),
              _buildFilterChip('Under ₹25k'),
              const SizedBox(width: 8),
              _buildFilterChip('New'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildVendorCard('Royal Wedding Cars', 'Vehicle rental', 'From ₹6,500'),
              const SizedBox(width: 16),
              _buildVendorCard('Spice Route Catering', 'Catering', 'From ₹650'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF122824) : Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: isSelected ? const Color(0xFF122824) : AppColors.borderSubtle),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildVendorCard(String title, String category, String price) {
    return Container(
      width: 275,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 176,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.success, size: 14),
                        const SizedBox(width: 4),
                        Text('Verified', style: AppTextStyles.labelSm.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineSm),
                const SizedBox(height: 2),
                Text(category, style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text(price, style: AppTextStyles.labelLg.copyWith(color: const Color(0xFF0C6B55), fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.verified_outlined, color: AppColors.primary, size: 20),
                ),
                const SizedBox(height: 10),
                Text('Verified businesses', style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w800)),
                Text('Every business checked', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(height: 60, width: 1, color: AppColors.borderSubtle),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                ),
                const SizedBox(height: 10),
                Text('Help next door', style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w800)),
                Text('A local partner near you', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCTA() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF091F1C),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.storefront, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Run an event business?', style: AppTextStyles.labelLg.copyWith(color: Colors.white)),
                Text('List it on EventOn — it\'s free to join', style: AppTextStyles.labelSm.copyWith(color: Colors.white70)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78DDBE),
              foregroundColor: const Color(0xFF052922),
              minimumSize: const Size(60, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surfaceMintPill,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSm.copyWith(color: AppColors.textPrimary),
          maxLines: 2,
        ),
      ],
    );
  }
}
