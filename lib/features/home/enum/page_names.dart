enum AdminPageName {
  dashboard(0),
  books(1),
  games(2),
  others(3);

  final int customIndex;

  static AdminPageName fromIndex(int index) => AdminPageName.values[index];
  const AdminPageName(this.customIndex);
}

enum ReaderPageName {
  home(0),
  books(1),
  games(2),
  others(3);

  final int customIndex;

  static ReaderPageName fromIndex(int index) => ReaderPageName.values[index];
  const ReaderPageName(this.customIndex);
}
