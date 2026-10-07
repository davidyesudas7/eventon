import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import 'category_grid_tile.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.categories, this.limit});

  final List<Category> categories;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final displayCategories = limit != null && limit! < categories.length
        ? categories.take(limit!).toList()
        : categories;

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        return CategoryGridTile(category: displayCategories[index]);
      },
    );
  }
}

class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key, this.count = 8});

  final int count;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 40, height: 10, color: Colors.grey[200]),
        ],
      ),
    );
  }
}
