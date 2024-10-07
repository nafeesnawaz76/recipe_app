import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:recipe_app/admin/controller/dropdown.dart';
import 'package:recipe_app/admin/controller/image_handler.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/services/id_generator.dart';
import 'package:recipe_app/widgets/dropdown.dart';
import 'package:recipe_app/widgets/loading.dart';
import 'package:recipe_app/widgets/textformfield.dart';

class AddRecipe extends StatefulWidget {
  AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < ingredients.length; i++) {
      _controllers.add(TextEditingController(text: ingredients[i]));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  final AddRecipeImageController _imageuploadController =
      Get.put(AddRecipeImageController());

  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  final _nameController = TextEditingController();

  final _caloriesController = TextEditingController();

  final _difficultyController = TextEditingController();

  final _cooktimeController = TextEditingController();

  final _preparetimeController = TextEditingController();

  final _servingController = TextEditingController();

  final _linkController = TextEditingController();

  final _descriptionController = TextEditingController();

  final RxList<String> ingredients = <String>[].obs;

  final SpinkitLoading loadingController = Get.put(SpinkitLoading());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("add Image"),
                  ElevatedButton(
                      onPressed: () {
                        _imageuploadController.showImagesPickerDialog();
                      },
                      child: const Text("Add Image"))
                ],
              ),
              Obx(() {
                // Obx widget listens to changes in the controller's observable
                if (_imageuploadController.selectedImage.value != null) {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(
                        File(_imageuploadController.selectedImage.value!.path)),
                  );
                } else {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  );
                }
              }),
              const DropDownCategoriesWidget(),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _nameController, hinttxt: "Recipe name"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _caloriesController, hinttxt: "Calories"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _difficultyController, hinttxt: "Difficulty"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _servingController, hinttxt: "Serving"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _preparetimeController,
                  hinttxt: "Prepration time"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _cooktimeController, hinttxt: "Cook time"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _descriptionController, hinttxt: "Description"),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                  controller: _linkController, hinttxt: "Video link"),
              const SizedBox(
                height: 5,
              ),
              Obx(() {
                return Column(
                  children: [
                    for (int i = 0; i < ingredients.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              //textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                hintText: "Ingredient ${i + 1}",
                              ),
                              controller: _controllers[i],
                              onChanged: (value) {
                                ingredients[i] = value;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ingredients.removeAt(i);
                              _controllers.removeAt(i);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {
                        ingredients.add(''); // Add a new empty ingredient
                        _controllers.add(TextEditingController(text: ''));
                      },
                      child: const Text('Add Ingredient'),
                    ),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: () async {
                  loadingController.toggleLoading();
                  await _imageuploadController
                      .uploadFunction(_imageuploadController.selectedImage);
                  String productId = GenerateIds().generateProductId();

                  RecipeModel recipeModel = RecipeModel(
                      id: productId,
                      name: _nameController.text,
                      recipeOfWeek: false,
                      image: _imageuploadController.arrImageUrl.toString(),
                      description: _descriptionController.text,
                      difficulty: _difficultyController.text,
                      ingredients: ingredients,
                      calories: _caloriesController.text,
                      serving: _servingController.text,
                      prep: _preparetimeController.text,
                      cook: _cooktimeController.text,
                      category: categoryDropDownController.selectedCategoryName
                          .toString(),
                      categoryId: categoryDropDownController.selectedCategoryId
                          .toString(),
                      isFavourite: false,
                      link: _linkController.text);

                  await FirebaseFirestore.instance
                      .collection('recipe')
                      .doc(productId)
                      .set(recipeModel.toMap());

                  print("success");
                  loadingController.toggleLoading();
                },
                child: Obx(
                  () => loadingController.isLoading.value
                      ? const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Center(
                            child: SpinKitFadingCube(
                              color: Colors.cyan,
                              size: 30,
                            ),
                          ),
                        )
                      : const Text("Upload"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
