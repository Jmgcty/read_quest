enum RouteName {
  root(path: '/'),
  home(path: '/home'),
  login(path: '/login'),
  register(path: '/register');

  final String path;
  const RouteName({required this.path});
}
