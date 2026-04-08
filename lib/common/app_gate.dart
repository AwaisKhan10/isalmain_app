import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheduling_app/common/onbaording/onbaording_screen.dart';
import 'package:sheduling_app/common/welcome_screen.dart';
import 'package:sheduling_app/locator.dart';
import 'package:sheduling_app/student/ui/screens/root/student_root_screen.dart';
import 'package:sheduling_app/teacher/core/services/auth_services.dart';
import 'package:sheduling_app/teacher/ui/screens/root/root_screen.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  late final AuthServices _auth = locator<AuthServices>();
  late final Future<_GateResult> _future = _bootstrap();

  Future<_GateResult> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

    // Ensure auth state is loaded before deciding the initial screen.
    await _auth.init();

    if (_auth.isLogin ?? false) {
      return _GateResult.loggedIn(isTeacher: _auth.isTeacher);
    }

    return _GateResult.loggedOut(seenOnboarding: seenOnboarding);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GateResult>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.data;
        if (result == null) {
          return const Scaffold(
            body: Center(child: Text("Something went wrong.")),
          );
        }

        if (result.isLoggedIn) {
          return result.isTeacher ? RootScreen() : StudentRootScreen();
        }

        return result.seenOnboarding ? WelcomeScreen() : const OnBoardingScreen();
      },
    );
  }
}

class _GateResult {
  final bool isLoggedIn;
  final bool isTeacher;
  final bool seenOnboarding;

  const _GateResult._({
    required this.isLoggedIn,
    required this.isTeacher,
    required this.seenOnboarding,
  });

  factory _GateResult.loggedIn({required bool isTeacher}) {
    return _GateResult._(isLoggedIn: true, isTeacher: isTeacher, seenOnboarding: true);
  }

  factory _GateResult.loggedOut({required bool seenOnboarding}) {
    return _GateResult._(isLoggedIn: false, isTeacher: false, seenOnboarding: seenOnboarding);
  }
}

