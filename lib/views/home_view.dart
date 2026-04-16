import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:tmdb_signals/config/app_config.dart';
import 'package:tmdb_signals/controllers/home_controller.dart';
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
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(TmdbRepository());
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
        final state = _controller.moviesSignal.value;

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

        final activeIndex = _controller.currentIndex.value;
        final safeIndex = activeIndex < movies.length ? activeIndex : 0;
        final activeMovie = movies[safeIndex];

        return Stack(
          fit: StackFit.expand,
          children: [
            if (activeMovie.posterPath.isNotEmpty)
              Image.network(
                '${AppConfig.imageBaseUrl}${activeMovie.posterPath}',
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
                    categories: _controller.categories.map((c) => c.label).toList(),
                    selectedIndex: _controller.selectedCategoryIndex,
                    onCategorySelected: _controller.selectCategory,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 350,
                    child: MoviePosterCarousel(
                      movies: movies,
                      onPageChanged: (index) {
                        _controller.currentIndex.value = index;
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
