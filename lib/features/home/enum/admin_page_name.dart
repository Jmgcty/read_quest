enum AdminPageName {
  dashboard(0),
  books(1),
  games(2),
  others(3);

  final int customIndex;

  static AdminPageName fromIndex(int index) => AdminPageName.values[index];
  const AdminPageName(this.customIndex);
}
