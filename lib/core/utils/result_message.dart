String resultMessage(String result) {
  switch (result) {
    case "user_invalid_credentials":
      return "Invalid credentials, please try again!";
    case "general_argument_invalid":
      return "Invalid ID, please try again!";
    default:
      return result;
  }
}
