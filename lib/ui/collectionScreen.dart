import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> items = [
    'Pramod Kumar Matho',
    'Item 2',
    'Item 3',
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
        title: const Padding(
          padding: EdgeInsets.fromLTRB(5, 50, 5, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Collections",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSearchLayout(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return CollectionItemCard(
                  title: filteredItems[index],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
// Widget for each collection item card
class CollectionItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Text(
                  '₹0',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Lan and Days Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lan: 101101033426',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '65 Days',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Address
            const Text(
              'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD, Pune City PUNE Kothrud S.O 411038, Test Landmark, PUNE, MAHARASHTRA - 411038',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.article, 'Detail', Colors.green),
                _buildActionButton(Icons.location_on, 'Location', Colors.orange),
                _buildActionButton(Icons.handshake, 'PTP', Colors.orange),
                _buildActionButton(Icons.account_balance_wallet, 'Collection', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
