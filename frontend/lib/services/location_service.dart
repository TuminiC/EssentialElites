import '../models/resource.dart';

class LocationService {
  Future<List<Resource>> getNearbyResources() async {
    // TODO: Implement actual location-based resource fetching
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    return [
      Resource(
        name: "Local Counseling Center",
        description: "Professional mental health services",
        address: "123 Main St, City, State",
        type: "Counseling Center",
        hours: "Monday - Friday, 9:00 AM - 5:00 PM",
        phone: "555-123-4567",
        category: "Mental Health",
      ),
      Resource(
        name: "Support Group Meeting",
        description: "Weekly group therapy sessions",
        address: "456 Oak Ave, City, State",
        type: "Support Group",
        hours: "Every Tuesday, 6:00 PM - 7:30 PM",
        phone: "555-123-4567",
        category: "Mental Health",
      ),
    ];
  }
}