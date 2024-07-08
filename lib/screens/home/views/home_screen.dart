import 'dart:math';

import 'package:expensetracker/add_expense/home/add_expense.dart';
import 'package:expensetracker/screens/home/views/main_screen.dart';
import 'package:expensetracker/screens/stats/stats_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index=0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          onTap: (value){
            setState(() {
              index=value;
            });
          },
          backgroundColor: Colors.white,
            elevation: 5,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items:
            [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home,color: index==0?Colors.blue:Colors.grey,),label: 'home',),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.graph_circle,color: index==1?Colors.blue:Colors.grey),label: 'states'),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => const AddExpense()
            ),
          );
        },
        shape: const CircleBorder(),
        child: Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: GradientRotation(pi/4)
            ),
          ),

          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: index ==0 ? MainScreen()
          :StatsScreen(),
    );
  }
}






