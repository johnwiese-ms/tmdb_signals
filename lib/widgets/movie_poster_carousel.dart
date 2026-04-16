import 'package:flutter/material.dart';
import 'package:tmdb_signals/config/app_config.dart';
import 'package:tmdb_signals/models/movie.dart';

/// The movie poster carousel widget.
class MoviePosterCarousel extends StatefulWidget {
  /// Creates the movie poster carousel widget.
  const MoviePosterCarousel({
    required this.movies,
    required this.onPageChanged,
    super.key,
  });

  /// The list of movies to display.
  final List<Movie> movies;

  /// The callback to invoke when the selected page (movie) changes.
  final ValueChanged<int> onPageChanged;

  @override
  State<MoviePosterCarousel> createState() => _MoviePosterCarouselState();
}

class _MoviePosterCarouselState extends State<MoviePosterCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: widget.onPageChanged,
      itemCount: widget.movies.length,
      clipBehavior: Clip.none,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            var value = 1.0;
            if (_pageController.position.haveDimensions) {
              value = _pageController.page! - index;
              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
            } else {
              value = index == 0 ? 1.0 : 0.7;
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: Curves.easeOut.transform(1 - value) * 40,
                ),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.movies[index].posterPath.isNotEmpty
                  ? Image.network(
                      '${AppConfig.imageBaseUrl}${widget.movies[index].posterPath}',
                      fit: BoxFit.cover,
                    )
                  : const ColoredBox(
                      color: Colors.grey,
                      child: Center(
                        child: Icon(Icons.movie, size: 50),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
