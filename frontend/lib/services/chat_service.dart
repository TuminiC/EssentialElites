class ChatService {
  Future<String> getResponse(String message) async {
    // TODO: Implement actual chat logic or API call
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return "This is a sample response from the AI therapist.";
  }
}