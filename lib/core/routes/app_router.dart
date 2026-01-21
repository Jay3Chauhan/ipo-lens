import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipo_lens/core/routes/app_routes.dart';
import 'package:ipo_lens/features/open-ipos/Screens/open_ipo_details_screen.dart';
import 'package:ipo_lens/utils/wigets/bottom_nav_bar_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            _buildPageWithSlideTransition(const BottomNavBarScreen(), state),
      ),
      GoRoute(
        path: '${AppRoutes.openIpos}/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _buildPageWithSlideTransition(
            OpenIpoDetailsScreen(id: id),
            state,
          );
        },
      ),
    ],
  );

  static CustomTransitionPage _buildPageWithSlideTransition<T>(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease)),
          ),
          child: child,
        );
      },
    );
  }
}
