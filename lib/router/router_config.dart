import 'package:astro_app/pagina/homeAdmin.dart';
import 'package:astro_app/pagina/review_quiz_page.dart';
import 'package:astro_app/pagina/forget_password.dart';
import 'package:astro_app/pagina/home.dart';
import 'package:astro_app/pagina/new_password.dart';
import 'package:astro_app/pagina/otp_verification.dart';
import 'package:astro_app/pagina/password_changed.dart';
import 'package:astro_app/pagina/quiz_page.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/pagina/astroApp.dart';
import 'package:astro_app/login_page.dart';
import 'package:astro_app/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: Routers.authenticationpage.path,
    name: Routers.authenticationpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: AstroApp());
    },
  ),
  GoRoute(
    path: Routers.loginpage.path,
    name: Routers.loginpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: LoginPage());
    },
  ),
  GoRoute(
    path: Routers.signuppage.path,
    name: Routers.signuppage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: SignupPage());
    },
  ),
  GoRoute(
    path: Routers.forgetpassword.path,
    name: Routers.forgetpassword.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: ForgetPasswordPage());
    },
  ),
  GoRoute(
    path: Routers.newpassword.path,
    name: Routers.newpassword.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: NewPasswordPage());
    },
  ),
  GoRoute(
    path: Routers.otpverification.path,
    name: Routers.otpverification.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: OtpVerificationPage());
    },
  ),
  GoRoute(
    path: Routers.passwordchanges.path,
    name: Routers.passwordchanges.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: PasswordChangesPage());
    },
  ),
  GoRoute(
    path: Routers.quizpage.path,
    name: Routers.quizpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: QuizPage());
    },
  ),
  GoRoute(
    path: Routers.homepage.path,
    name: Routers.homepage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: HomePage());
    },
  ),
  GoRoute(
    path: Routers.reviewquizpage.path,
    name: Routers.reviewquizpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: ReviewQuizPage());
    },
  ),
  GoRoute(
    path: Routers.homeadminpage.path,
    name: Routers.homeadminpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: HomeAdminPage());
    },
  ),
]);
