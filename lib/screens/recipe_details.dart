import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens.dart';
import 'package:recipe_app/widgets/infobox.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetails extends StatefulWidget {
  final RecipeModel recipeModel;
  const RecipeDetails({super.key, required this.recipeModel});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isBookmarked = false;
  late String videoUrl;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    videoUrl = widget.recipeModel.link;
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ));
    checkIfBookmarked();
    super.initState();
  }

  Future<void> checkIfBookmarked() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(widget.recipeModel.id)
          .get();

      if (doc.exists) {
        setState(() {
          isBookmarked = true;
        });
      }
    }
  }

  Future<void> toggleBookmark() async {
    final user = _auth.currentUser;
    if (user != null) {
      final bookmarkRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(widget.recipeModel.id);

      if (isBookmarked) {
        // Remove from bookmarks (delete the document)
        await bookmarkRef.delete();
        setState(() {
          isBookmarked = false;
          Get.snackbar("Recipe Unsaved", "recipe is deleted from bookmarks");
        });
      } else {
        // Add to bookmarks (create a document)
        await bookmarkRef.set({
          'id': widget.recipeModel.id,
          "name": widget.recipeModel.name,
          "recipeOfWeek": widget.recipeModel.recipeOfWeek,
          "image": widget.recipeModel.image,
          "description": widget.recipeModel.description,
          "difficulty": widget.recipeModel.difficulty,
          "ingredients": widget.recipeModel.ingredients,
          "calories": widget.recipeModel.calories,
          "serving": widget.recipeModel.serving,
          "prep": widget.recipeModel.prep,
          "cook": widget.recipeModel.cook,
          "category": widget.recipeModel.category,
          "isFavourite": widget.recipeModel.isFavourite,
          "link": widget.recipeModel.link,
          "categoryId": widget.recipeModel.categoryId,

          // Add other fields if necessary
        });
        setState(() {
          isBookmarked = true;
          Get.snackbar("Recipe Saved", "Check bookmarks");
        });
      }
    } else {
      Get.snackbar("Login required", "please login to save");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: const WidgetStatePropertyAll(
              Colors.cyan,
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,

              // ignore: sized_box_for_whitespace
              builder: (context) => Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    1, // Set the height of the bottom sheet
                child: SizedBox(
                  height: 250,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
            );
          },
          child: const Text(
            "watch video",
            style: TextStyle(color: Colors.white),
          )),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 80),
      //   child:
      // ),
      // backgroundColor: Colors.greenAccent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.cyan,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Screens()));
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Screens()));
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: IconButton(
                    onPressed: () {
                      toggleBookmark();
                    },
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_added : Icons.bookmark_add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                fit: BoxFit.cover,
                //height: 240,
                width: MediaQuery.of(context).size.width,
                image: NetworkImage(widget.recipeModel.image),
              ),
            ),
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.37,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.recipeModel.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InfoBox(
                              txttop: 'Cook time',
                              txt: widget.recipeModel.cook,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InfoBox(
                              txttop: 'Calories',
                              txt: widget.recipeModel.calories,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InfoBox(
                              txttop: 'Serving',
                              txt: widget.recipeModel.serving,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.recipeModel.description,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            scrollDirection: Axis.vertical,
                            itemCount: widget.recipeModel.ingredients.length,
                            itemBuilder: (context, index) {
                              final ingredient =
                                  widget.recipeModel.ingredients[index];
                              return Container(
                                  height: 40,
                                  color: Colors.cyan.withOpacity(0.1),
                                  child: Text(ingredient));
                            }),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
