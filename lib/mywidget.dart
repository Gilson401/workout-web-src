import 'package:flutter/material.dart';
import 'package:hello_flutter/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// https://www.youtube.com/watch?v=cQbWd2tnfdc&t=2496s
class MyState extends State<MyWidget> {
  var _items = [];
  final _font = const TextStyle(
    fontSize: 15.0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    String carteira = "http://localhost:3005/carteira";

    try {
      
      http.Response response = await http.get(Uri.parse(carteira));
      
      List<dynamic> decoded = jsonDecode(response.body);
      List<Stock> parsedListStock = decoded.map((element) => Stock.fromJson(element)).toList();

      setState(() {       
        _items = parsedListStock;
      });
    } catch (err) {
      print(err);    
    }
  }

  Widget _buildRow(int position) {
    return ListTile(
      title: Text("${1+position}:  ${_items[position].asset}", style: _font),
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: NetworkImage("https://picsum.photos/200"),
        ),
      ),
      subtitle: Text("${_items[position].setor}", textAlign: TextAlign.left),

    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int position) {
        return _buildRow(position);
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  @override
  createState() => MyState();
}
