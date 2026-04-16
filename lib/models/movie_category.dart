import 'package:tmdb_signals/models/movie.dart';

/// Represents a movie category with its label and fetcher function.
class MovieCategory {
  /// Creates a movie category.
  const MovieCategory(this.label, this.fetcher);

  /// The display label for the category.
  final String label;

  /// The function to fetch movies for this category.
  final Future<List<Movie>> Function() fetcher;
}
