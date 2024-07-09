import 'package:expense_repository/expense_repository.dart';
import 'package:expensetracker/add_expense/blocs/get_category/get_categories_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../blocs/create_expense/create_expense_bloc.dart';
import 'category_creation.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Expense expense;
  bool isLoading=false;

  @override
  void initState() {
    expense= Expense.empty;
    expense.expenseId=Uuid().v1();
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc,CreateExpenseState>(

      listener: (BuildContext context, state) {
        if(state is CreateExpenseSuccess){
          Navigator.pop(context,expense);
        }
        else if(state is CreateExpenseLoading){
          setState(() {
            isLoading=true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (BuildContext context, GetCategoriesState state) {
              if (state is GetCategoriesSuccess) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Add Expense",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
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
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {},
                            controller: categoryController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:expense.category==null ? Colors.white :Color(expense.category.color),
                              prefixIcon: expense.category ==null? Icon(
                                FontAwesomeIcons.list,
                                size: 16,
                                color: Colors.grey,
                              ):
                              Image.asset(
                                'assets/${expense.category.icon}',
                                scale: 2,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  var newCategory = await getCategoryCreation(context);
                                  setState(() {
                                    state.categories.insert(0, newCategory);
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Category",
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: state.categories.length,
                            itemBuilder: (context, int i) {
                              return Card(
                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      expense.category=state.categories[i];
                                      categoryController.text=expense.category.name;
                                    });
                                  },
                                  leading: Image.asset(
                                    'assets/${state.categories[i].icon}',
                                    scale: 2,
                                  ),
                                  title: Text(state.categories[i].name),
                                  tileColor: Color(state.categories[i].color),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16,),
                        SizedBox(
                          child: TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: expense.date,
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                  
                              if (newDate != null) {
                                setState(() {
                                  dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                                  expense.date=newDate;
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
                          child:isLoading==true ?Center(child: CircularProgressIndicator()): TextButton(
                            onPressed: () {
                              setState(() {
                                expense.amount=int.parse(expenseController.text);
                              });
                              context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
