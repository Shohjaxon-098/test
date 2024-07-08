import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/pages/shartnomaDetail_page.dart';
import 'package:test1/screens/login_screen.dart';

class ShartnomalarScreen extends StatefulWidget {
  @override
  _ShartnomalarScreenState createState() => _ShartnomalarScreenState();
}

class _ShartnomalarScreenState extends State<ShartnomalarScreen> {
  List<Map<String, String>> shartnomalar = [];

  @override
  void initState() {
    super.initState();
    _loadShartnomalar();
  }

  Future<void> _loadShartnomalar() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUser = prefs.getString('currentUser');
      if (currentUser != null) {
        final data = prefs.getStringList('shartnomalar_$currentUser') ?? [];
        setState(() {
          shartnomalar = data.map((e) => Map<String, String>.from(json.decode(e))).toList();
        });
      } else {
        // Handle case where currentUser is null
      }
    } catch (e) {
      // Handle error
      print('Error loading agreements: $e');
    }
  }

  Future<void> _addShartnoma(Map<String, String> shartnoma) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUser = prefs.getString('currentUser');
      if (currentUser != null) {
        setState(() {
          shartnomalar.add(shartnoma);
        });
        final data = shartnomalar.map((e) => json.encode(e)).toList();
        await prefs.setStringList('shartnomalar_$currentUser', data);
      } else {
        // Handle case where currentUser is null
      }
    } catch (e) {
      // Handle error
      print('Error adding agreement: $e');
    }
  }

  Future<void> _deleteShartnoma(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUser = prefs.getString('currentUser');
      if (currentUser != null) {
        setState(() {
          shartnomalar.removeAt(index);
        });
        final data = shartnomalar.map((e) => json.encode(e)).toList();
        await prefs.setStringList('shartnomalar_$currentUser', data);
      } else {
        // Handle case where currentUser is null
      }
    } catch (e) {
      // Handle error
      print('Error deleting agreement: $e');
    }
  }

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle error
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shartnomalar'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: shartnomalar.isEmpty
          ? Center(
              child: Text('Hech qanday shartnoma mavjud emas'),
            )
          : ListView.builder(
              itemCount: shartnomalar.length,
              itemBuilder: (context, index) {
                final shartnoma = shartnomalar[index];
                return Dismissible(
                  key: Key(shartnoma.hashCode.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteShartnoma(index);
                  },
                  child: ListTile(
                    leading: Text('${index + 1}', style: TextStyle(fontSize: 16)),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shartnoma['F.I.SH'] ?? ''),
                        Text(shartnoma['To\'lov Sanasi'] ?? ''),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShartnomaDetailsScreen(
                            shartnoma: shartnoma,
                            onSave: (updatedShartnoma) {
                              setState(() {
                                shartnomalar[index] = updatedShartnoma;
                              });
                              _saveShartnomalar();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShartnomaDetailsScreen(
                shartnoma: {},
                onSave: (shartnoma) => _addShartnoma(shartnoma),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _saveShartnomalar() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUser = prefs.getString('currentUser');
      if (currentUser != null) {
        final data = shartnomalar.map((e) => json.encode(e)).toList();
        await prefs.setStringList('shartnomalar_$currentUser', data);
      } else {
        // Handle case where currentUser is null
      }
    } catch (e) {
      // Handle error
      print('Error saving agreements: $e');
    }
  }
}
