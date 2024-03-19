import 'package:flutter/material.dart';
import 'package:movieapp/utils.dart';

import '../model/upcoming_model.dart';

class MovieCard extends StatelessWidget {
  final Future<UpcomingMovieModel> future;
  final String headlineText;

  const MovieCard(
      {super.key, required this.future, required this.headlineText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshort) {

            var data = snapshort.data?.results;
            if(data == null){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headlineText,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: data!.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                            Image.network("$imageUrl${data[index].posterPath}"),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        );
  }
}
