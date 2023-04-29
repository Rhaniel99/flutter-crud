import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(User? user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    final User? user = ModalRoute.of(context)?.settings.arguments as User?;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Formulário de Usuário'),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                final formState = _form.currentState;
                if (formState?.validate() ?? false) {
                  formState?.save();
                  setState(() {
                    _isLoading = true;
                  });

                  await Provider.of<Users>(context, listen: false).put(User(
                    id: _formData['id'] ?? '',
                    name: _formData['name'] ?? '',
                    email: _formData['email'] ?? '',
                    avatarUrl: _formData['avatarUrl'] ?? '',
                  ));

                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _formData['name'],
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome inválido';
                          }
                          if (value.trim().length < 3) {
                            return 'Nome muito pequeno. No mínimo 3 letras.';
                          }
                        },
                        onSaved: (value) => _formData['name'] = value!,
                      ),
                      TextFormField(
                        initialValue: _formData['email'],
                        decoration: InputDecoration(labelText: 'Email'),
                        onSaved: (value) => _formData['email'] = value!,
                      ),
                      TextFormField(
                        initialValue: _formData['avatarUrl'],
                        decoration: InputDecoration(labelText: 'URL do Avatar'),
                        onSaved: (value) => _formData['avatarUrl'] = value!,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
