class CustomAuthResult {
  bool? status;
  String? errorMessage;
  var user;
  bool needsProfileCompletion;
  CustomAuthResult({
    this.status,
    this.errorMessage,
    this.user,
    this.needsProfileCompletion = false,
  });
}
