import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class Users with ChangeNotifier {
  static const _baseUrl =
      'https://crud-flutter-teste-default-rtdb.firebaseio.com/';
  List<User> _items = [];

  List<User> get all {
    return [..._items];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.elementAt(i);
  }

  Future<void> put(User user) async {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return;
    }

    if (user.id.trim().isNotEmpty) {
      final url = '$_baseUrl/users/${user.id}.json';
      await http.patch(
        Uri.parse(url),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );
      _items[_items.indexWhere((u) => u.id == user.id)] = user;
    } else {
      final response = await http.post(
        Uri.parse('$_baseUrl/users.json'),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );
      final id = json.decode(response.body)['name'];
      final newUser = User(
        id: id,
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
      );
      _items.add(newUser);
    }
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users.json'));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<User> loadedUsers = [];
    extractedData.forEach((userId, userData) {
      loadedUsers.add(User(
        id: userId,
        name: userData['name'],
        email: userData['email'],
        avatarUrl: userData['avatarUrl'],
      ));
    });
    _items = loadedUsers;
    notifyListeners();
  }

  void remove(User user) async {
    final url = '$_baseUrl/users/${user.id}.json';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      // Aqui você pode tratar erros, caso ocorram
      return;
    }

    _items.removeWhere((u) => u.id == user.id);
    notifyListeners();
  }
}
