import 'package:flutter/material.dart';

import './dummy_data.dart';
import './screens/filters_screen.dart';
import './screens/tabs_screen.dart';
import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegeterian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where(
        ((meal) {
          if (_filters['gluten'] == true && !meal.isGlutenFree) {
            return false;
          }
          if (_filters['lactose'] == true && !meal.isLactoseFree) {
            return false;
          }
          if (_filters['vegan'] == true && !meal.isVegan) {
            return false;
          }
          if (_filters['vegeterian'] == true && !meal.isVegetarian) {
            return false;
          }
          return true;
        }),
      ).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'DeliMeals',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoCondensed',
                ),
                headline5: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Raleway',
                ),
              ),

          // colorScheme: ColorScheme(
          //   brightness: Brightness.light,
          //   primary: Colors.pink,
          //   onPrimary: Colors.white,
          //   secondary: Colors.amber,
          //   onSecondary: Colors.white,
          //   error: Colors.red,
          //   onError: Colors.white,
          //   background: Colors.whi<te,
          //   onBackground: Colors.black,
          //   surface: Colors.white,
          //   onSurface: Colors.white,
          // ),
        ),
        //home: CategoriesScreen(),
        routes: {
          '/': (ctx) => TabsScreen(_favoriteMeals),
          CategoryMealScreen.routeName: (ctx) =>
              CategoryMealScreen(_availableMeals),
          MealDetailScreen.routeName: (ctx) =>
              MealDetailScreen(_toggleFavorite, _isMealFavorite),
          FiltersScreen.routeName: (ctx) =>
              FiltersScreen(_filters, _setFilters),
        },
        // onGenerateRoute: (settings) {
        //   print(settings.arguments);
        //   return MaterialPageRoute(
        //     builder: (context) => CategoriesScreen(),
        //   );
        // },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => CategoriesScreen());
        });
  }
}
