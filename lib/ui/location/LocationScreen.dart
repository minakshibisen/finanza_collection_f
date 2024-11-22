import 'package:flutter/material.dart';

class Locationscreen extends StatefulWidget {
  @override
  _LocationscreenState createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  final TextEditingController _receiptController = TextEditingController();

  // For dropdown spinner
  String? _selectedOption; // To hold the selected value
  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3']; // Add your items here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input with Dropdown')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 67,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      icon: Icon(Icons.arrow_drop_down, size: 18), items: [

                    ], onChanged: (String? value) {  },




                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputAction textInputAction;
  final TextEditingController controller;

  InputFieldWidget({
    required this.hintText,
    required this.icon,
    required this.textInputAction,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }
}
