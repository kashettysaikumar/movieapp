import 'package:flutter/material.dart';
import 'package:movieapp/Screens/search_screen.dart';
import 'package:movieapp/services_api/api_services.dart';
import 'package:movieapp/utils.dart';

import '../model/upcoming_model.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel>upcomingFuture;
  late Future<UpcomingMovieModel>NowplayingMovies;

  ApiServices apiServices =ApiServices();

  @override
  void initState(){
    super.initState();
    netWorkcalls();
  }

  void netWorkcalls(){
    setState(() {
      upcomingFuture=apiServices.getUpcomingMovies();
      NowplayingMovies=apiServices.getUpcomingMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: kBackgoundColor,
        title: Text(
          "Movies",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                  ),
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black
                ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(
               height: 350,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: MovieCard(
                    future: upcomingFuture, headlineText: "Popular Movies"),
               ),
             ),
            SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MovieCard(
                    future: NowplayingMovies, headlineText: "Now playing"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
