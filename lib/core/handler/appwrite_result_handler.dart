class Result {
  final bool? success;
  final String? error;

  Result.success() : success = true, error = null;
  Result.error(this.error) : success = false;

  bool get isSuccess => success == true;
}
