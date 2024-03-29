import 'package:flutter/material.dart';
import 'package:shaspeaker_news_app/src/features/comment/presentation/comments_screen.dart';
import 'package:shaspeaker_news_app/src/features/posts/presentation/post_detail/post_screen.dart';

import '../screens/home_screen/home_screen.dart';
import '../screens/splash_screen.dart';
import '../features/authentication/presentation/authentication_presentations.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case postRoute:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PostScreen(
                  postId: arguments['postId'] as String,
                  categoryId: arguments['categoryId'] as String,
                ));
      case commentsRoute:
        var arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) =>
                CommentsScreen(postId: arguments['postId'] as String));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  //Arguments generator functions for routes

  //PostDetail Screen
  static Map<String, dynamic> createPostRouteArguments(
      String postId, String categoryId) {
    return {'postId': postId, 'categoryId': categoryId};
  }

  //Comments Screen
  static Map<String, dynamic> createCommentsRouteArguments(String postId) {
    return {'postId': postId};
  }
}
