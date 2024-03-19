import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/model/movie_rec_model.dart';
import 'package:movieapp/model/search_model.dart';
import 'package:movieapp/services_api/api_services.dart';
import 'package:movieapp/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();

  late Future<MovieRecommendationModel> populatMovies;

  SearchModel? searchModel;

  void search(String query) {
    apiServices.getSearchMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    populatMovies=apiServices.getPopularMovies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
          children: [
            CupertinoSearchTextField(
              padding: EdgeInsets.all(15),
              controller: searchController,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              style: TextStyle(color: Colors.black),
              backgroundColor: Colors.blue.withOpacity(0.3),
              onChanged: (value) {
                if (value.isEmpty) {
                } else {
                  search(searchController.text);
                }
              },
            ),
            searchController.text.isEmpty?
            FutureBuilder(
               future: populatMovies,
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
                     SizedBox(height: 30),
                     Text(
                       "Popular Movies ",
                       style: TextStyle(
                         fontSize: 25,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     SizedBox(height: 10),
                     ListView.builder(
                       padding: EdgeInsets.all(5),
                       itemCount: data!.length,
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       itemBuilder: (context, index) {
                         return Container(
                           height: 170,
                           padding: EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child:
                           Row(
                             children: [
                               SizedBox(width: 15),
                               Image.network("$imageUrl${data[index].posterPath}"),
                               SizedBox(width: 20),
                               SizedBox(
                                 height: 300,
                                 child: Container(
                                   alignment: Alignment.center,
                                   child: Text(data[index].title,
                                   maxLines: 2,
                                   overflow: TextOverflow.ellipsis,),
                                 ),
                               )
                             ],
                           ),
                         );
                       },
                     ),
                   ],
                 );
               }
           ):
           searchModel==null?
               SizedBox.shrink()
            :GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchModel?.results.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 5,
                childAspectRatio: 1.2/2),
              itemBuilder: (context,index){
                return Column(
                  children: [
                    searchModel!.results[index].backdropPath==null?Image.asset("assets/movie.jpg",height: 170,)
                    :CachedNetworkImage(imageUrl: "$imageUrl${searchModel!.results[index].backdropPath}",
                    height: 170),
                    SizedBox(
                      width:100,
                      child: Text(searchModel!.results[index].originalTitle,
                      maxLines: 2,
                      overflow:TextOverflow.ellipsis,
                      style: TextStyle(fontSize:14),),
                    )
                  ],
                );
              },
              ),
          ],
        ),
      ),
      ),
    );
  }
}
