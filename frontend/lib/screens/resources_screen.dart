import 'package:flutter/material.dart';
import 'package:mental_crisis_app/screens/chat_screen.dart';
import '../widgets/resource_card.dart';
import '../models/resource.dart';
import '../services/location_service.dart';

class ResourcesScreen extends StatefulWidget {
  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final LocationService _locationService = LocationService();
  List<Resource> _resources = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);
    try {
        final resources = await _locationService.getNearbyResources();
        setState(() {
        _resources = resources;
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading resources: $e';
        _isLoading = false;
      });
    }
      
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Local Resources',
              style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mental health resources near you:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildResourceList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF4285F4),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          } else if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Resources'),
        ],
      ),
    );
  }

    Widget _buildResourceList() {
    if (_isLoading) {
      return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_errorMessage.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage),
              ElevatedButton(
                onPressed: _loadResources,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else if (_resources.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('No resources found.')),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ResourceCard(resource: _resources[index]),
          childCount: _resources.length,
        ),
      );
    }
  }
}