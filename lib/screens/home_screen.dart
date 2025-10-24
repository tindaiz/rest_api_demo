
import 'package:flutter/material.dart';
import 'post_list_http.dart';
import 'post_list_dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  static const List<Widget> _screens = [
    PostListHttp(),
    PostListDio(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_index == 0 ? 'HTTP Package' : 'DIO Package'),
        backgroundColor: _index == 0 ? Colors.blue : Colors.green,
      ),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.http), label: 'HTTP'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: 'DIO'),
        ],
      ),
    );
  }
}
