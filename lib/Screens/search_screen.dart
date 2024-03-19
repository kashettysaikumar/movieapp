import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  SearchModel? searchModel;

  void search(String query) {
    apiServices.getSearchMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
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
           searchModel==null?
               SizedBox.shrink()
            :GridView.builder(
              shrinkWrap: true,
              itemCount: searchModel?.results.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 5,
                childAspectRatio: 1.2/2),
              itemBuilder: (context,index){
                return Column(
                  children: [
                    CachedNetworkImage(imageUrl: "$imageUrl${searchModel!.results[index].backdropPath}",
                    height: 170),
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
