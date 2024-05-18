class AppRouter {
  String name;
  String path;
  AppRouter({
    required this.name,
    required this.path,
  });
}

class Routers {
  static AppRouter authenticationpage = AppRouter(name: "/", path: "/");
  static AppRouter loginpage = AppRouter(name: "/login", path: "/login");
  static AppRouter signuppage = AppRouter(name: "/signip", path: "/signup");
  static AppRouter forgetpassword =
      AppRouter(name: "/forgetpassword", path: "/forgetpassword");
  static AppRouter newpassword =
      AppRouter(name: "/newpassword", path: "/newpassword");
  static AppRouter otpverification =
      AppRouter(name: "/otpverification", path: "/otpverification");
  static AppRouter passwordchanges =
      AppRouter(name: "/passwordchanges", path: "/passwordchanges");
  static AppRouter quizpage = AppRouter(name: "/quizpage", path: "/quizpage");
  static AppRouter homepage = AppRouter(name: "/homepage", path: "/homepage");
  static AppRouter reviewquizpage =
      AppRouter(name: "/reviewquizpage", path: "/reviewquizpage");
  static AppRouter homeadminpage =
      AppRouter(name: "/homeadminpage", path: "/homeadminpage");
  static AppRouter addquestionpageadmin =
      AppRouter(name: "/addquestionpageadmin", path: "/addquestionpageadmin");
  static AppRouter viewapod = AppRouter(name: "/viewapod", path: "/viewapod");
  static AppRouter addnoticia =
      AppRouter(name: "/addnoticia", path: "/addnoticia");
        static AppRouter homebpage =
      AppRouter(name: "/homebpage", path: "/homebpage");
  static AppRouter tickedpage =
      AppRouter(name: "/tickedpage", path: "/tickedpage");
        static AppRouter trueorfalsepage =
      AppRouter(name: "/trueorfalsepage", path: "/trueorfalsepage");
}
