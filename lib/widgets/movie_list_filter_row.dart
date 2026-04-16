import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// A filter row widget for selecting movie categories.
class MovieListFilterRow extends StatelessWidget {
  /// Creates a movie list filter row.
  const MovieListFilterRow({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    super.key,
  });

  /// The list of category labels.
  final List<String> categories;

  /// The signal tracking the currently selected category index.
  final Signal<int> selectedIndex;

  /// Callback when a category is selected.
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 4,
        children: List<Widget>.generate(
          categories.length,
          (index) {
            final label = categories[index];
            return Watch(
              (context) => OutlinedButton(
                onPressed: selectedIndex.value == index
                    ? null
                    : () {
                        onCategorySelected(index);
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  visualDensity: VisualDensity.compact,
                  overlayColor: Colors.transparent,
                  side: BorderSide(
                    color: selectedIndex.value == index ? Colors.transparent : Colors.white.withValues(alpha: 0.5),
                  ),
                  backgroundColor: selectedIndex.value == index ? const Color(0xff90cea1).withValues(alpha: 0.2) : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
