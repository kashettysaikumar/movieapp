import 'dart:convert';
import 'dart:developer';
import 'package:movieapp/utils.dart';

import '../model/movie_rec_model.dart';
import '../model/search_model.dart';
import '../model/upcoming_model.dart';
import 'package:http/http.dart'as http;

const baseUrl ="https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endpoint;

//popular movies

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endpoint = "movie/upcoming";
    final url = "$baseUrl$endpoint$key";
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      log("success");
      //log("success response:${response.body}");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  // now playing

  Future<UpcomingMovieModel> NowplayingMovies() async {
    endpoint = "movie/now_playing";
    final url = "$baseUrl$endpoint$key";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log("success");
      //log("success response:${response.body}");
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load now playing movies");
  }

  //searching

  Future<SearchModel> getSearchMovie(String searchText) async {
    endpoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endpoint";
    print("search url is $url");
    final response = await http.get(Uri.parse(url),
        headers:{
      'Authorization':"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MDAwODI3Y2RhN2MxOGY0ZTc5NTQzYzNkN2E0Mzg1YiIsInN1YiI6IjY1Zjg0NzNmNTk0Yzk0MDE3YzNhNDM3OSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.iQ4Ar-aW1C-szIHLXxwyOW1Z9RLy34fxSXShmsBoXZo"
        } );
    if (response.statusCode == 200) {
      log(" Search success");
      //log("success response:${response.body}");
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load searched movie");
  }

  Future<MovieRecommendationModel> getPopularMovies() async {
    endpoint = 'movie/popular';
    final url = '$baseUrl$endpoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

}