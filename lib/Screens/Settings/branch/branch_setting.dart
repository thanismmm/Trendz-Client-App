import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:trendz_customer/Providers/theme_provider.dart';

class BranchSetting extends StatefulWidget {
  const BranchSetting({super.key});

  @override
  State<BranchSetting> createState() => _BranchSettingState();
}

class _BranchSettingState extends State<BranchSetting> {
  final secureStorage = const FlutterSecureStorage();

  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Flat design for a clean look
        title: Text(
          "Branch Settings",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              "Choose Your Preferred Branch",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 2),
            Text(
              "You can change your branch preference anytime.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Branch List
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBranchTile(
                  context,
                  branchName: "Maruthamunai",
                  isSelected: selectedBranch == "Maruthamunai",
                  onTap: () => _onBranchSelected("Maruthamunai"),
                ),
                const SizedBox(height: 10),
                _buildBranchTile(
                  context,
                  branchName: "Sainthamaruthu",
                  isSelected: selectedBranch == "Sainthamaruthu",
                  onTap: () => _onBranchSelected("Sainthamaruthu"),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Save the branch preference to secure storage
            if (selectedBranch != null) {
              secureStorage.write(
                  key: "preferredBranch", value: selectedBranch);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Preferred branch set to $selectedBranch"),
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a branch before proceeding."),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Save Preference",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchTile(BuildContext context,
      {required String branchName,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              branchName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 23,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  void _onBranchSelected(String branchName) {
    setState(() {
      selectedBranch = branchName;
    });
  }
}
