import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/sort_option.dart';
import '../bloc/product_bloc.dart';

class FilterBottomSheet {
  static void show(BuildContext blocContext) {
    showModalBottomSheet(
      context: blocContext,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.sortBy,
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildSortOption(
                title: AppString.priceHighToLow,
                onTap: () {
                  blocContext.read<ProductBloc>().add(SortProducts(SortOption.priceHighLow));
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                title: AppString.priceLowToHigh,
                onTap: () {
                  blocContext.read<ProductBloc>().add(SortProducts(SortOption.priceLowHigh));
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                title: AppString.rating,
                onTap: () {
                  blocContext.read<ProductBloc>().add(SortProducts(SortOption.rating));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSortOption({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
      ),
    ),
    );
  }
}
