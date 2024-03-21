import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/movie_rec_model.dart';
import '../model/search_model.dart';
import '../services_api/api_services.dart';
import '../utils.dart';
import 'movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  SearchModel? searchedMovie;
  late Future<MovieRecommendationModel> popularMovies;

  void search(String query) {
    apiServices.getSearchMovie(query).then((results) {
      setState(() {
        searchedMovie = results;
      });
    });
  }


  @override
  void initState() {
    popularMovies = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CupertinoSearchTextField(
                controller: searchController,
                padding: const EdgeInsets.all(10.0),
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: Colors.black,
                ),
                suffixIcon: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
                style: const TextStyle(color: Colors.black),
                backgroundColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  if (value.isEmpty) {
                  } else {
                    search(searchController.text);
                  }
                },
              ),
              searchController.text.isEmpty
                  ? FutureBuilder<MovieRecommendationModel>(
                      future: popularMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data?.results;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    "Popular Searches",
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(left: 20),
                                  scrollDirection: Axis.vertical,
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                movieId: data[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                '$imageUrl${data[index].posterPath}',
                                                fit: BoxFit.fitHeight,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(data[index].title,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ]);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : searchedMovie == null
                      ? const SizedBox.shrink()
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchedMovie?.results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 5,
                            childAspectRatio: 1.2 / 2,
                          ),
                          itemBuilder: (context, index) {
                            return searchedMovie!.results[index].backdropPath ==
                                    null
                                ? Column(
                                    children: [
                                      Image.asset(
                                        "assets/movie.jpg",
                                        height: 170,
                                      ),
                                      Text(
                                        searchedMovie!.results[index].title,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                      movieId: searchedMovie!
                                                          .results[index].id),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '$imageUrl${searchedMovie?.results[index].backdropPath}',
                                          height: 170,
                                        ),
                                      ),
                                      Text(
                                        searchedMovie!.results[index].title,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        )
            ],
          ),
        ),
      ),
    );
  }
}
