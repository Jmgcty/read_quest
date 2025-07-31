enum RouteName {
  root(path: '/'),
  start(path: '/start'),
  home(path: '/home/:userType'),
  login(path: '/login'),
  register(path: '/register');

  final String path;
  const RouteName({required this.path});
}
