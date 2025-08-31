import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';

class HomepagePreferredModal extends StatefulWidget {
  const HomepagePreferredModal({super.key});

  @override
  State<HomepagePreferredModal> createState() => _HomepagePreferredModalState();
}

class _HomepagePreferredModalState extends State<HomepagePreferredModal> {
  Map<String, dynamic>? selectedBranch;
  final List<Map<String, dynamic>> branches = [
    {"name": "Maruthamunai", "id": 1},
    {"name": "Sainthamaruthu", "id": 2},
  ];
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    selectedBranch = branches.first; // Set initial value dynamically
  }

  // Function to save the selected branch's ID
  Future<void> _saveBranchId() async {
    if (selectedBranch != null) {
      String branchId = selectedBranch!['id'].toString(); // Get ID from map
      await _secureStorage.write(key: 'selectedBranchId', value: branchId);
      print("Stored Branch ID: $branchId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Theme.of(context).focusColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select your Preferred Branch?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    value: selectedBranch,
                    items: branches.map((branch) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: branch,
                        child: Text(
                          branch['name'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? value) {
                      setState(() {
                        selectedBranch = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor)),
                      labelText: 'Branch',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    _saveBranchId(); // Save ID when button is pressed
                    print("Proceed with: ${selectedBranch?['name']}");
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
