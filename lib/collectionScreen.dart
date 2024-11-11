import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Item 1',

  ];
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items; // Initially, show all items
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 50, 5, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
              ),
               const Text("Collections",
                 style: TextStyle(
                 fontSize: 20,        // Set the font size to 24
                 color: Colors.white,  // Set the text color to white
                 fontWeight: FontWeight.bold, // Optional: set the font weight
               ),),
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,

      ),
      body: Column(
        children: [
          _buildSearchLayout(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]),
                  onTap: () {
                    // Handle item tap if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _filterItems(''); // Reset the list
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: _filterItems,
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Search"),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "Type to search...",
            ),
            onChanged: _filterItems,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filterItems('');
                Navigator.of(context).pop();
              },
              child: const Text("Clear"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
