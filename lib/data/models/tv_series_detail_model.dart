import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
  const TvSeriesDetailResponse({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  final bool adult;
  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String originalName;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final List<SeasonModel> seasons;
  final int numberOfEpisodes;
  final int numberOfSeasons;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        adult: json['adult'] ?? false,
        backdropPath: json['backdrop_path'],
        genres: List<GenreModel>.from(
          (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
        ),
        id: json['id'],
        originalName: json['original_name'] ?? json['name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'] ?? '',
        firstAirDate: json['first_air_date'] ?? '',
        name: json['name'] ?? '',
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        voteCount: json['vote_count'] ?? 0,
        seasons: List<SeasonModel>.from(
          (json['seasons'] as List? ?? []).map((x) => SeasonModel.fromJson(x)),
        ),
        numberOfEpisodes: json['number_of_episodes'] ?? 0,
        numberOfSeasons: json['number_of_seasons'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'backdrop_path': backdropPath,
        'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
        'id': id,
        'original_name': originalName,
        'overview': overview,
        'poster_path': posterPath,
        'first_air_date': firstAirDate,
        'name': name,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
        'number_of_episodes': numberOfEpisodes,
        'number_of_seasons': numberOfSeasons,
      };

  TvSeriesDetail toEntity() => TvSeriesDetail(
        adult: adult,
        backdropPath: backdropPath,
        genres: genres.map((e) => e.toEntity()).toList(),
        id: id,
        originalName: originalName,
        overview: overview,
        posterPath: posterPath,
        firstAirDate: firstAirDate,
        name: name,
        voteAverage: voteAverage,
        voteCount: voteCount,
        seasons: seasons.map((e) => e.toEntity()).toList(),
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
      );

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        originalName,
        overview,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
        seasons,
        numberOfEpisodes,
        numberOfSeasons,
      ];
}
