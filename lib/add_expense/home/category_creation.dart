import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expensetracker/add_expense/blocs/create_category/create_category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context){
  List<String> myCategoriesIcons=[
    'entertainment.png',
    'food.png',
    'home.png',
    'pet.png',
    'shopping.png',
    'tech.png',
    'travel.png',

  ];

  return showDialog(context: context, builder: (ctx)
  {
    bool isExpanded=false;
    bool isLoading=false;
    String iconSelected='';
    Color? categoryColor;
    TextEditingController categoryNameController= TextEditingController();
    Category category = Category.empty;


    return  BlocProvider.value(
      value: context.read<CreateCategoryBloc>(),
      child: StatefulBuilder(
  builder: ( ctx, setState) {
    return BlocListener<CreateCategoryBloc, CreateCategoryState>(
      listener: (context, state) {
        if (state is CreateCategorySuccess) {
          Navigator.pop(ctx,category);
        }
        else if (state is CreateCategoryLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: AlertDialog(
        title: const Text("Create a Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: categoryNameController,
              textAlignVertical: TextAlignVertical
                  .center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              readOnly: true,
              textAlignVertical: TextAlignVertical
                  .center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(
                  CupertinoIcons.arrow_down,
                  size: 12,),
                hintText: "Icon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22),
                    bottom: isExpanded == false ? const Radius.circular(22) : const Radius
                        .circular(0),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            isExpanded == true ? Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                          itemCount: myCategoriesIcons.length,
                          itemBuilder: (context, int i) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  iconSelected = myCategoriesIcons[i];
                                });
                              },
                              child: Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: iconSelected == myCategoriesIcons[i]
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/${myCategoriesIcons[i]}'),
                                  ),
                                ),

                              ),
                            );
                          }),
                    ))) : Container(),
            const SizedBox(height: 20,),


            TextFormField(
              readOnly: true,
              onTap: () {
                showDialog(context: context, builder: (ctx2) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ColorPicker(
                            pickerColor: Colors.white,
                            onColorChanged: (value) {
                              setState(() {
                                categoryColor = value;
                              });
                            },),
                          const SizedBox(height: 10,),
                          SizedBox(
                            width: double.infinity,
                            height: kToolbarHeight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: const Text("Save Color",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
              textAlignVertical: TextAlignVertical
                  .center,
              decoration: InputDecoration(
                filled: true,
                fillColor: categoryColor,
                hintText: "Color",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16,),
            SizedBox(
              width: double.infinity,
              height: kToolbarHeight,
              child: isLoading == true
                  ? CircularProgressIndicator()
                  : TextButton(
                  onPressed: () {
                    //create category object and pop out
                    setState((){
                      category.categoryId = const Uuid().v1();
                      category.name = categoryNameController.text;
                      category.icon = iconSelected;
                      category.color = categoryColor!.value;
                    });
                    context.read<CreateCategoryBloc>().add(
                        CreateCategory(category));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text("Save",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white
                    ),
                  )
              ),
            ),
          ],
        ),

      ),
    );
  },
      ),
    );
  });

}