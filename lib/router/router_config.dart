import 'package:astro_app/models/proyecto_model.dart';
import 'package:astro_app/Login/forget_password.dart';
import 'package:astro_app/Login/new_password.dart';
import 'package:astro_app/Login/password_changed.dart';
import 'package:astro_app/router/router.dart';
import 'package:astro_app/astroApp.dart';
import 'package:astro_app/Login/login_page.dart';
import 'package:astro_app/Login/signup_page.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/agregarnoticia.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/editarnoticia.dart';
import 'package:astro_app/vistausuario2/admin/Noticia/listarnoticia.dart';
import 'package:astro_app/vistausuario2/admin/homeb.dart';
import 'package:astro_app/vistausuario2/homeb.dart';
import 'package:astro_app/vistausuario2/passwordVerific.dart';
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
    path: Routers.passwordchanges.path,
    name: Routers.passwordchanges.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: PasswordChangesPage());
    },
  ),
  GoRoute(
    path: Routers.homeadminpage.path,
    name: Routers.homeadminpage.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: HomeadminPage());
    },
  ),
  GoRoute(
    path: Routers.addnoticia.path,
    name: Routers.addnoticia.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: AddNoticia());
    },
  ),
  GoRoute(
    path: Routers.homebpage.path,
    name: Routers.homebpage.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: HomebPage());
    },
  ),
  GoRoute(
    path: Routers.tickedpage.path,
    name: Routers.tickedpage.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: TickedPage());
    },
  ),
  GoRoute(
    path: Routers.listnoticia.path,
    name: Routers.listnoticia.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: ListarNoticia(
        elemento: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.editarnoticia.path,
    name: Routers.editarnoticia.name,
    pageBuilder: (context, state) {
      final noticia = state.extra as Noticia;
      return CupertinoPage(child: EditarNoticiaPage(noticia: noticia));
    },
  ),
]);
