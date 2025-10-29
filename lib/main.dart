import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(MyApp());
}

/// ------------------------------
/// Configure GoRouter
/// ------------------------------
final GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // The ShellRoute just builds the scaffold.
        // The child it receives is already animated by the GoRoutes below.
        return ScaffoldWithDrawer(child: child);
      },
      routes: [
        // -------- Tab A --------
        GoRoute(
          path: '/a',
          // ⛔️ REMOVED: builder: (context, state) => const TabAPage(),
          // ✨ ADDED: pageBuilder for custom tab transition
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey, // Important for animations
            transitionDuration: const Duration(milliseconds: 500),
            child: const TabAPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
          ),
          routes: [
            GoRoute(
              path: 'details/:id',
              // ⛔️ REMOVED: builder: (context, state) => ...
              // ✨ ADDED: pageBuilder for Cupertino detail transition
              pageBuilder: (context, state) => CupertinoPage(
                key: state.pageKey,
                child: ADetailPage(id: state.pathParameters['id']!),
              ),
            ),
          ],
        ),

        // -------- Tab B --------
        GoRoute(
          path: '/b',
          // ✨ ADDED: pageBuilder for custom tab transition
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TabBPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
          ),
          routes: [
            GoRoute(
              path: 'details/:id',
              // ✨ ADDED: pageBuilder for Cupertino detail transition
              pageBuilder: (context, state) => CupertinoPage(
                key: state.pageKey,
                child: BDetailPage(id: state.pathParameters['id']!),
              ),
            ),
          ],
        ),

        // -------- Tab C --------
        GoRoute(
          path: '/c',
          // ✨ ADDED: pageBuilder for custom tab transition
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TabCPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
          ),
          routes: [
            GoRoute(
              path: 'details/:id',
              // ✨ ADDED: pageBuilder for Cupertino detail transition
              pageBuilder: (context, state) => CupertinoPage(
                key: state.pageKey,
                child: CDetailPage(id: state.pathParameters['id']!),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
  initialLocation: '/a',
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter + Animations Example',
      routerConfig: router,
    );
  }
}

/// ------------------------------
/// Shell Scaffold with Drawer
/// ------------------------------
class ScaffoldWithDrawer extends StatefulWidget {
  final Widget child;
  const ScaffoldWithDrawer({required this.child, super.key});

  @override
  State<ScaffoldWithDrawer> createState() => _ScaffoldWithDrawerState();
}

class _ScaffoldWithDrawerState extends State<ScaffoldWithDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShellRoute Drawer Example')),
      drawer: Drawer(
        // ... (Your Drawer code is perfect, no changes) ...
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text('Navigation Menu', style: TextStyle(fontSize: 20)),
              ),
            ),
            ListTile(
              title: const Text('Tab A'),
              onTap: () {
                context.go('/a');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tab B'),
              onTap: () {
                context.go('/b');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tab C'),
              onTap: () {
                context.go('/c');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // Your PopScope logic is correct for handling back button presses
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          final loc = GoRouterState.of(context).uri.toString();

          // ... (Your exit dialog logic is perfect, no changes) ...
          if (loc.startsWith('/a')) {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Exit App?'),
                content: const Text('Do you want to close the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            );

            if (shouldExit == true) {
              SystemNavigator.pop(); // 👈 exits app
            }
            return;
          } else {
            context.go('/a');
          }
        },

        // ⛔️ The PageTransitionSwitcher is removed.
        // ✨ The body is now just the child provided by the router.
        child: widget.child,
      ),
    );
  }
}

/// ------------------------------
/// Tab A
/// ------------------------------
class TabAPage extends StatelessWidget {
  const TabAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This is Tab A'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/a/details/1'),
            child: const Text('Go to A Details'),
          ),
          ElevatedButton(
            onPressed: () {
              // Replace stack and navigate to Tab B
              context.go('/b/details/2');
            },
            child: const Text('Replace → Go to B Details'),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// A Detail Page
/// ------------------------------
class ADetailPage extends StatelessWidget {
  final String id;
  const ADetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('A Detail $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}

/// ------------------------------
/// Tab B
/// ------------------------------
class TabBPage extends StatelessWidget {
  const TabBPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This is Tab B'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/b/details/2'),
            child: const Text('Go to B Details'),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// B Detail Page
/// ------------------------------
class BDetailPage extends StatelessWidget {
  final String id;
  const BDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('B Detail $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}

/// ------------------------------
/// Tab C
/// ------------------------------
class TabCPage extends StatelessWidget {
  const TabCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('This is Tab C'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push('/c/details/3'),
            child: const Text('Go to C Details'),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------
/// C Detail Page
/// ------------------------------
class CDetailPage extends StatelessWidget {
  final String id;
  const CDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('C Detail $id')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back'),
        ),
      ),
    );
  }
}
