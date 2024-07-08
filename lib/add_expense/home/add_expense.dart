import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController= TextEditingController();
  TextEditingController categoryController= TextEditingController();
  TextEditingController dateController= TextEditingController();
  DateTime selectedDate= DateTime.now();

  List<String> myCategoriesIcons=[
    'entertainment.png',
    'food.png',
    'home.png',
    'pet.png',
    'shopping.png',
    'tech.png',
    'travel.png',

  ];



  @override
  void initState(){
    dateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Add Expense",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22
              ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: TextFormField(
                    controller: expenseController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.dollarSign,
                        size: 16,
                        color: Colors.grey,
                      ),
                      hintText: "Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
              ),
              const SizedBox(height: 32,),
              SizedBox(
                // width: MediaQuery.of(context).size.width*0.7,
                child: TextFormField(
                  readOnly: true,
                  onTap: () {},
                  controller: categoryController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.list,
                      size: 16,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                        onPressed: ()  {
                          showDialog(context: context, builder: (ctx)
                          {
                            bool isExpanded=false;
                            String iconSelected='';
                            Color? categoryColor;
                            return  StatefulBuilder(
                              builder: ( context, setState) {
                              return  AlertDialog(
                                  title: const Text("Create a Category"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
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
                                        decoration:  InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: const Icon(
                                            CupertinoIcons.arrow_down,
                                            size: 12,),
                                          hintText: "Icon",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(22),
                                              bottom:isExpanded==false?Radius.circular(22):Radius.circular(0),
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      isExpanded == true ? Container(
                                        width: MediaQuery.of(context).size.width,
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
                                                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                                                      itemCount: myCategoriesIcons.length,
                                                  itemBuilder: (context, int i) {
                                                       return GestureDetector(
                                                         onTap: (){
                                                           setState((){
                                                             iconSelected=myCategoriesIcons[i];
                                                           });
                                                         },
                                                         child: Container(
                                                           width: 50,height: 50,
                                                           decoration: BoxDecoration(
                                                             border: Border.all(
                                                               color: iconSelected==myCategoriesIcons[i]?Colors.green:Colors.grey,
                                                               width: 5,
                                                             ),
                                                             borderRadius: BorderRadius.circular(16),
                                                             image: DecorationImage(
                                                               image: AssetImage('assets/${myCategoriesIcons[i]}'),
                                                             ),
                                                           ),

                                                                                                       ),
                                                       );
                                                                                       }),
                                           ))) : Container(),
                                      const SizedBox(height: 20,),


                                      TextFormField(
                                        readOnly: true,
                                        onTap: (){
                                          showDialog(context: context, builder: (ctx2){
                                            return AlertDialog(
                                                content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ColorPicker(
                                                    pickerColor: Colors.white,
                                                    onColorChanged: (value){
                                                      setState((){
                                                        categoryColor=value;
                                                      });
                                                    },),
                                                    const SizedBox(height: 10,),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: kToolbarHeight,
                                                      child: TextButton(
                                                          onPressed: (){
                                                            Navigator.pop(context);
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
                                          });
                                        },
                                        textAlignVertical: TextAlignVertical
                                            .center,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:categoryColor,
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
                                        child: TextButton(
                                            onPressed: (){
                                              //create category object and pop out
                                              Navigator.pop(context);
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

                                );
                              }
                            );
                          });
                        },
                        icon: const Icon(
                          FontAwesomeIcons.plus,
                          size: 16,
                          color: Colors.grey,
                        )
                    ),
                    hintText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                // width: MediaQuery.of(context).size.width*0.7,
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: ()async{
                    DateTime? newDate =await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: selectedDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)));

                    if(newDate != null){
                      setState(() {
                        dateController.text=DateFormat('dd/MM/yyyy').format(newDate);
                        selectedDate=newDate;
                      });
                    }
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: Colors.grey,
                    ),
                    hintText: "Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                height: kToolbarHeight,
                child: TextButton(
                    onPressed: (){},
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
      ),
    );
  }
}






















