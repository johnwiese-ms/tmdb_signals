import 'package:signals_flutter/signals_flutter.dart';
import 'package:tmdb_signals/models/movie.dart';

/// Global state for the application.
class AppState {
  /// The currently selected movie.
  static final Signal<Movie?> selectedMovie = signal(null);
}
