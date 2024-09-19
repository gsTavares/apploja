import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:apploja/model/usermodel.dart';

import 'package:apploja/main.dart';

String _user = "";

bool _editForm = false;

String _editId = "";

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _searchController = TextEditingController();

  List<User> _userList = [];
  List<User> _filteredUserList = [];

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _user = args['name'];
    }

    final nameField = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _nameController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Nome Usuário",
              border: InputBorder.none),
        ));

    final cpfField = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _cpfController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.file_copy),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "CPF",
              border: InputBorder.none),
        ));

    final emailField = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "E-mail",
              border: InputBorder.none),
        ));

    final phoneField = Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Telefone",
              border: InputBorder.none),
        ));

    final searchField = Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          autofocus: false,
          controller: _searchController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Buscar por",
              border: InputBorder.none),
        ));

    const txtHeader = Center(
        child: Text("Cafeteria Boers", style: TextStyle(fontSize: 24.0)));

    final btnSubmit = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: MyApp.primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            if (_nameController.text.isNotEmpty &&
                _cpfController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _phoneController.text.isNotEmpty) {
              User user = User(
                  name: _nameController.text,
                  cpf: _cpfController.text,
                  phone: _phoneController.text,
                  email: _emailController.text);

              if (!_editForm) {
                await createUserFirestore(user);
              } else {
                await editUserFirestore(user, _editId);
              }

              _fetchUsers();

              setState(() {
                _user = _nameController.text;

                _nameController.clear();
                _cpfController.clear();
                _phoneController.clear();
                _emailController.clear();
              });
            } else {
              log("Please enter all fields!");
            }
          },
          child: Text(
            !_editForm ? "Cadastrar" : "Alterar",
            style: const TextStyle(color: Colors.white),
          ),
        ));

    final btnSearch = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: MyApp.primaryColor,
        child: MaterialButton(
          onPressed: () {
            _searchUsers(_searchController.text);
          },
          child: const Text(
            "Buscar",
            style: TextStyle(color: Colors.white),
          ),
        ));

    final userListSection = Container(
      height: 300.0,
      child: ListView.builder(
        itemCount: _filteredUserList.length,
        itemBuilder: (context, index) {
          final user = _filteredUserList[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(
                "CPF: ${user.cpf}\nEmail: ${user.email}\nPhone: ${user.phone}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    editUserForm(user);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteUserFirestore(user.id!);
                    _fetchUsers(); // Refresh the list after deletion
                  },
                ),
              ],
            ),
          );
        },
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txtHeader,
              const SizedBox(height: 20.0),
              nameField,
              const SizedBox(height: 20.0),
              cpfField,
              const SizedBox(height: 20.0),
              emailField,
              const SizedBox(height: 20.0),
              phoneField,
              const SizedBox(height: 60.0),
              btnSubmit,
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: searchField),
                  const SizedBox(width: 20.0),
                  btnSearch
                ],
              ),
              const SizedBox(height: 20.0),
              userListSection
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchUsers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('usuarios').get();
      setState(() {
        _userList = querySnapshot.docs
            .map((doc) => User(
                id: doc.id,
                name: doc['name'],
                cpf: doc['cpf'],
                phone: doc['phone'],
                email: doc['email']))
            .toList();
        _filteredUserList = _userList;
      });
    } catch (e) {
      log("Error fetching users: $e");
    }
  }

  void _searchUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUserList = _userList;
      } else {
        _filteredUserList = _userList.where((user) {
          final lowerQuery = query.toLowerCase();
          return user.name.toLowerCase().contains(lowerQuery) ||
              user.cpf.toLowerCase().contains(lowerQuery) ||
              user.email.toLowerCase().contains(lowerQuery) ||
              user.phone.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  Future<void> createUserFirestore(User user) async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
        'name': user.name,
        'cpf': user.cpf,
        'phone': user.phone,
        'email': user.email,
      });
      log("User Created");
    } catch (e) {
      log("Error creating user: $e");
    }
  }

  Future<void> deleteUserFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .delete();
      log("User Deleted");
    } catch (e) {
      log("Error deleting user: $e");
    }
  }

  Future<void> editUserFirestore(User user, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .update({
        'name': user.name,
        'cpf': user.cpf,
        'phone': user.phone,
        'email': user.email,
      });
      log("User Updated");
    } catch (e) {
      log("Error updating user: $e");
    }
  }

  void editUserForm(User user) {
    setState(() {
      _nameController.text = user.name;
      _cpfController.text = user.cpf;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _editForm = true;
      _editId = user.id!;
    });
  }
}
