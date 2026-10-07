import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../categories/presentation/providers/categories_providers.dart';
import '../../../categories/presentation/widgets/category_grid.dart';

class AllServicesScreen extends ConsumerWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(
        title: 'All services',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: categoriesAsync.when(
          data: (categories) => CategoryGrid(categories: categories),
          loading: () => const CategoryGridSkeleton(count: 12),
          error: (err, stack) =>
              const Center(child: Text('Couldn\'t load services')),
        ),
      ),
    );
  }
}
