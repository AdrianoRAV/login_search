import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSearch extends StatefulWidget {
  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<ScreenSearch> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _capturedInformation =
      ObservableList<String>().asObservable();
  bool _isEditing = false;
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadCapturedInformation();
  }

  Future<void> _loadCapturedInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedInformation = prefs.getStringList('capturedInformation') ?? [];
    _capturedInformation.addAll(savedInformation);
  }

  Future<void> _saveCapturedInformation() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('capturedInformation', _capturedInformation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('  ---- Screen Search ----'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Observer(
              builder: (_) => _capturedInformation.isEmpty
                  ? Card(
                      child: Container(
                        height: 100.0, // Defina a altura desejada aqui
                        child: ListTile(
                          title: Center(
                            child: Text('Nenhuma informação capturada'),
                          ),
                        ),
                      ),
                    )
                  : Card(
                      child: Container(
                        height: 100.0, // Defina a altura desejada aqui
                        child: ListTile(
                          title: _isEditing
                              ? TextField(
                                  controller: _textEditingController,
                                  onSubmitted: (text) {
                                    _capturedInformation[_editingIndex] = text;
                                    _isEditing = false;
                                    _saveCapturedInformation();
                                  },
                                )
                              : Text(_capturedInformation.last),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _startEditing(
                                    _capturedInformation.length - 1),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _showDeleteConfirmationDialog(
                                    _capturedInformation.length - 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite seu texto',
                ),
                onSubmitted: (text) {
                  if (_isEditing) {
                    _capturedInformation[_editingIndex] = text;
                    _isEditing = false;
                  } else {
                    _capturedInformation.add(text);
                  }
                  _saveCapturedInformation();
                  _textEditingController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startEditing(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _textEditingController.text = _capturedInformation[index];
    });
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Informação'),
          content: Text('Tem certeza de que deseja excluir esta informação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _capturedInformation.removeAt(index);
                _saveCapturedInformation();
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
