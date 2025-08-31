import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UserDetails extends StatefulWidget {
  final String name;
  final String value;
  final Widget itemIcon;

  const UserDetails({
    super.key,
    required this.name,
    required this.value,
    required this.itemIcon,
    required Null Function(dynamic newValue) onSaved,
  });

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late TextEditingController _textController;
  bool _isEditing = false; // To toggle between view and edit mode

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
      // You can save the changes to secure storage or any other service here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          widget.itemIcon, // Display the passed icon here
          SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    _isEditing
                        ? TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                            ),
                          )
                        : Text(
                            _textController.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isEditing) {
                        _saveChanges();
                      } else {
                        _isEditing = true;
                      }
                    });
                  },
                  child: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: _isEditing ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
