/// A model class representing a Movie
///
/// This class includes properties such as [id], [title], [overview],
/// [posterPath], and [voteAverage]. It also includes a factory constructor
/// to create a [Movie] instance from a JSON map.
class Movie {
  /// Constructs a [Movie] instance with the given properties.
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  /// The unique identifier for the movie
  final int id;

  /// The title of the movie
  final String title;

  /// A brief overview or description of the movie
  final String overview;

  /// The path to the movie's poster image
  final String posterPath;

  /// The average vote score for the movie
  final double voteAverage;

  /// Factory constructor to create a [Movie] instance from a JSON map
  // ignore: sort_constructors_first
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'No Title',
      overview: json['overview'] as String? ?? 'No Overview',
      posterPath: json['poster_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
