import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_php_mysql_crud_240529/addeditpage.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> _dataListFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataListFuture = getData();
  }

  Future<List<dynamic>> getData() async {
    final url = Uri.parse('http://43.203.45.247/app1/read.php') ;
    final response = await http.get(url) ;
    return json.decode(response.body) ;
  }

  Future<void> deleteItem(String id) async {
    final url = Uri.parse('http://43.203.45.247/app1/delete.php') ;
    final response = await http.post(url,
        body : {
          'id' : id,
        }) ;
    if(response.body == '200') {
      print('deleted ok') ;
      setState(() {
        getData();
      });
    }else{
      print('delete failed') ;
    }
  }

  showDeleteDialog(String id){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('확인'),
        content: Text('삭제하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop() ;
              },
              child: Text('취소')),
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop() ;
                deleteItem(id) ;
              },
              child: Text('삭제'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Flutter PHP MySQL CRUD APP')
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=>AddEditPage(list: [],),),
          );
        },
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error) ;
          return snapshot.hasData
              ? ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  List list = snapshot.data! ;
                  return ListTile(
                    leading: GestureDetector(
                      child: Icon(Icons.edit),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> AddEditPage(list : list, index : index,),),);
                      },
                    ),
                    title : Text(list[index]['lastname']),
                    subtitle : Text(list[index]['phone']),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete),
                      onTap: (){
                        showDeleteDialog(list[index]['id']) ;
                        // setState(() {
                        //   final url = Uri.parse('http://43.203.45.247/app1/delete.php') ;
                        //   http.post(url,
                        //     body : {
                        //       'id' : list[index]['id'],
                        //     }) ;
                        // });
                      },
                    ),
                  );
                })
              : CircularProgressIndicator() ;
        },
      ),
    );
  }
}
