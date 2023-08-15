import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/navigation/routes.dart';

class ProfileController extends ChangeNotifier{
  void onTap(String route){
    switch(route){
      case Routes.feedbackList:
      NavigationManager.instance.navigateTo(Routes.feedbackList);

    }
  }
}