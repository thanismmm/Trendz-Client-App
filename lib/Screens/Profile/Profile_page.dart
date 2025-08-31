import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trendz_customer/widgets/profile/user_details.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final securestorage = const FlutterSecureStorage();
  String? _fullname;
  String? _email;

  // Controller to edit and save user data
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<void> _loadUserData() async {
    String? fullname = await securestorage.read(key: "fullname");
    String? email = await securestorage.read(key: "email");
    setState(() {
      _fullname = fullname;
      _email = email;
      _fullnameController.text = fullname ?? '';
      _emailController.text = email ?? '';
    });
  }

  Future<void> _saveUserData() async {
    await securestorage.write(key: "fullname", value: _fullnameController.text);
    await securestorage.write(key: "email", value: _emailController.text);
    setState(() {
      _fullname = _fullnameController.text;
      _email = _emailController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Container(
                child: IconButton(
                    onPressed: () => {Navigator.pop(context)},
                    icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Image.asset(
                      "lib/assets/images/logo.png",
                      width: 150,
                      height: 1500,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$_fullname",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "$_email",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  UserDetails(
                    name: "Name",
                    value: _fullname ?? 'Super Admin',
                    itemIcon: const Icon(Iconsax.frame1),
                    onSaved: (newValue) {
                      setState(() {
                        _fullnameController.text = newValue;
                      });
                      _saveUserData();
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UserDetails(
                    name: "Mobile Number",
                    value: "+9475 73 33 221",
                    itemIcon: Icon(Icons.phone_android),
                    onSaved: (newValue) {
                      setState(() {
                        _emailController.text = newValue;
                      });
                      _saveUserData();
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UserDetails(
                    name: "Password",
                    value: "************",
                    itemIcon: Icon(Iconsax.lock),
                    onSaved: (newValue) {
                      setState(() {
                        _emailController.text = newValue;
                      });
                      _saveUserData();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
