import 'package:signals_flutter/signals_flutter.dart';
import 'package:tmdb_signals/models/movie.dart';
import 'package:tmdb_signals/models/movie_category.dart';
import 'package:tmdb_signals/repositories/tmdb_repository.dart';

/// Controller for the home view using signals.
class HomeController {
  /// Creates the home controller.
  HomeController(this.repository) {
    moviesSignal = futureSignal(
      () => categories[selectedCategoryIndex.value].fetcher(),
      dependencies: [selectedCategoryIndex],
    );
  }

  /// The TMDB repository.
  final TmdbRepository repository;

  /// The selected category index.
  final Signal<int> selectedCategoryIndex = signal(0);

  /// The current movie index in the carousel.
  final Signal<int> currentIndex = signal(0);

  /// The signal for the list of movies.
  late final FutureSignal<List<Movie>> moviesSignal;

  /// Gets the available movie categories.
  List<MovieCategory> get categories => [
    MovieCategory('Trending', repository.getTrendingMovies),
    MovieCategory('Now Playing', repository.getNowPlayingMovies),
    MovieCategory('Popular', repository.getPopularMovies),
    MovieCategory('Top Rated', repository.getTopRatedMovies),
    MovieCategory('Upcoming', repository.getUpcomingMovies),
  ];

  /// Selects a category by index.
  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    currentIndex.value = 0;
  }
}
