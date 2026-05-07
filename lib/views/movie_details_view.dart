import 'dart:ui' as ui;

import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:tmdb_signals/config/app_config.dart';
import 'package:tmdb_signals/controllers/app_state.dart';
import 'package:tmdb_signals/widgets/movie_details.dart';

/// The detailed view of a selected movie.
class MovieDetailsView extends StatelessWidget {
  /// Creates the movie details view.
  const MovieDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final movie = AppState.selectedMovie.value;

      if (movie == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: const Center(
            child: Text('No movie selected'),
          ),
        );
      }

      return Cue.onMount(
        motion: const CueMotion.gentle(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Actor(
              acts: const [.fadeIn(), .scale(from: 0.8)],
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
          ),
          body: Stack(
          fit: StackFit.expand,
          children: [
            Actor(
              acts: const [
                .scale(from: 1.15),
                .fadeIn(),
              ],
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      '${AppConfig.imageBaseUrl}${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Colors.black87),
                    )
                  : const ColoredBox(color: Colors.black87),
            ),

            Actor(
              delay: const Duration(milliseconds: 50),
              acts: const [.fadeIn()],
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const ColoredBox(color: Colors.black54),
              ),
            ),

            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                  Actor(
                    delay: const Duration(milliseconds: 80),
                    acts: const [
                      .fadeIn(),
                      .slideY(from: 0.15),
                      .scale(from: 0.90),
                      .rotate3D(
                        from: Rotation3D(x: 15),
                        perspective: 0.001,
                      ),
                    ],
                    child: Container(
                      height: 350,
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
                      child: movie.posterPath.isNotEmpty
                          ? Image.network(
                              '${AppConfig.imageBaseUrl}${movie.posterPath}',
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
                  const SizedBox(height: 40),
                  Expanded(
                    child: Actor(
                      delay: const Duration(milliseconds: 160),
                      acts: const [
                        .fadeIn(),
                        .slideY(from: 0.15),
                      ],
                      child: MovieDetails(movie: movie),
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  });
  }
}
