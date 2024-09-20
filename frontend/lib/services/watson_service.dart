class WatsonService {
  Future<String> getResponse(String input) async {
    // Add your Watson Assistant credentials here
    await Future.delayed(Duration(seconds: 2));
    return "I understand you're feeling stressed. Remember to take deep breaths and focus on the present moment. Would you like to try a quick relaxation exercise?";
  }
}