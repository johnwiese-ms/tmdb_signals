import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:tmdb_signals/models/movie.dart';
import 'package:tmdb_signals/repositories/tmdb_repository.dart';
import 'package:tmdb_signals/widgets/movie_details.dart';
import 'package:tmdb_signals/widgets/movie_list_filter_row.dart';
import 'package:tmdb_signals/widgets/movie_poster_carousel.dart';

/// The home view.
class HomeView extends StatefulWidget {
  /// Creates the home view.
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _repository = TmdbRepository();
  late final List<Future<List<Movie>> Function()> _movieFetchers;
  late final FutureSignal<List<Movie>> _moviesSignal;
  final Signal<int> _selectedCategoryIndex = signal<int>(0);
  final Signal<int> _currentIndexSignal = signal<int>(0);

  static const List<String> _categoryLabels = [
    'Trending',
    'Now Playing',
    'Popular',
    'Top Rated',
    'Upcoming',
  ];

  @override
  void initState() {
    super.initState();
    _movieFetchers = [
      _repository.getTrendingMovies,
      _repository.getNowPlayingMovies,
      _repository.getPopularMovies,
      _repository.getTopRatedMovies,
      _repository.getUpcomingMovies,
    ];
    _moviesSignal = futureSignal(
      () => _movieFetchers[_selectedCategoryIndex.value](),
      dependencies: [_selectedCategoryIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/tmdb_long.svg',
          height: 24,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      body: Watch((context) {
        final state = _moviesSignal.value;

        if (state.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.hasError && state.value == null) {
          return Center(
            child: Text('Error: ${state.error}'),
          );
        }

        final movies = state.value ?? [];

        if (movies.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        final activeIndex = _currentIndexSignal.value;
        final safeIndex = activeIndex < movies.length ? activeIndex : 0;
        final activeMovie = movies[safeIndex];

        return Stack(
          fit: StackFit.expand,
          children: [
            if (activeMovie.posterPath.isNotEmpty)
              Image.network(
                'https://image.tmdb.org/t/p/w500${activeMovie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Colors.black87),
              )
            else
              const ColoredBox(color: Colors.black87),

            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const ColoredBox(color: Colors.black54),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  MovieListFilterRow(
                    categories: _categoryLabels,
                    selectedIndex: _selectedCategoryIndex,
                    onCategorySelected: (index) {
                      setState(() {
                        _selectedCategoryIndex.value = index;
                        _currentIndexSignal.value = 0;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 350,
                    child: MoviePosterCarousel(
                      movies: movies,
                      onPageChanged: (index) {
                        _currentIndexSignal.value = index;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  MovieDetails(movie: activeMovie),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
