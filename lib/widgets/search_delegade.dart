import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> filteredRecipes = snapshot.data!.docs
              .where((recipe) =>
                  recipe['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              DocumentSnapshot recipe = filteredRecipes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(recipe["image"]),
                ),
                title: Text(recipe['name']),
                // Add more recipe details as needed
              );
            },
          );
        } else {
          return const Center(
            child: SpinKitFadingCube(
              color: Color(0xff68D0D6),
              size: 30,
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipe').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> filteredRecipes = snapshot.data!.docs
              .where((recipe) =>
                  recipe['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              DocumentSnapshot recipe = filteredRecipes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(recipe["image"]),
                ),
                title: Text(recipe['name']),
                // Add more recipe details as needed
              );
            },
          );
        } else {
          return const Center(
            child: SpinKitFadingCube(
              color: Color(0xff68D0D6),
              size: 30,
            ),
          );
        }
      },
    );
  }
}
