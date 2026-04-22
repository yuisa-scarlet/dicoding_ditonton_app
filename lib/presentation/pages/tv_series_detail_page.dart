import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';

  const TvSeriesDetailPage({required this.id, super.key});

  final int id;

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailCubit>().fetchTvSeriesDetail(widget.id);
      context.read<TvSeriesDetailCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailCubit, TvSeriesDetailState>(
        builder: (context, state) {
          if (state.tvSeriesState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesState == RequestState.Loaded &&
              state.tvSeries != null) {
            final tvSeries = state.tvSeries!;
            return SafeArea(
              child: TvSeriesDetailContent(
                tvSeries: tvSeries,
                recommendations: state.tvSeriesRecommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(state.message);
          }
        },
      ),
    );
  }
}

class TvSeriesDetailContent extends StatelessWidget {
  const TvSeriesDetailContent({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedWatchlist,
    super.key,
  });

  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$BASE_IMAGE_URL${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tvSeries.name, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await context
                                      .read<TvSeriesDetailCubit>()
                                      .addWatchlist(tvSeries);
                                } else {
                                  await context
                                      .read<TvSeriesDetailCubit>()
                                      .removeFromWatchlist(tvSeries);
                                }

                                final message = context
                                    .read<TvSeriesDetailCubit>()
                                    .state
                                    .watchlistMessage;

                                if (message ==
                                        TvSeriesDetailCubit
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvSeriesDetailCubit
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(content: Text(message)),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tvSeries.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text('Season & Episode', style: kHeading6),
                            Text(
                              'Seasons: ${tvSeries.numberOfSeasons} | Episodes: ${tvSeries.numberOfEpisodes}',
                            ),
                            const SizedBox(height: 8),
                            _buildSeasonList(tvSeries.seasons),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            BlocBuilder<TvSeriesDetailCubit,
                                TvSeriesDetailState>(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.Loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state.recommendationState ==
                                    RequestState.Error) {
                                  return Text(state.message);
                                } else if (state.recommendationState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final item = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvSeriesDetailPage.routeName,
                                                arguments: item.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$BASE_IMAGE_URL${item.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 4,
                        width: 48,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) return result;
    return result.substring(0, result.length - 2);
  }

  Widget _buildSeasonList(List<Season> seasons) {
    if (seasons.isEmpty) return const Text('-');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: seasons
          .map(
            (season) => Text(
              'S${season.seasonNumber}: ${season.name} (${season.episodeCount} eps)',
            ),
          )
          .toList(),
    );
  }
}
