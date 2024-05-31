import 'package:flutter/material.dart';
import 'package:flutter_php_mysql_crud_240529/myhomepage.dart';
import 'package:http/http.dart' as http ;

class AddEditPage extends StatefulWidget {
  final List? list ;
  final int? index ;
  AddEditPage({this.list, this.index});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  bool editMode = false ;
  TextEditingController firstName = TextEditingController() ;
  TextEditingController lastName = TextEditingController() ;
  TextEditingController phone = TextEditingController() ;
  TextEditingController address = TextEditingController() ;

  addUpdateData() async {
    if(editMode){
      final url = Uri.parse('http://43.203.45.247/app1/edit.php') ;
      final response = await http.post(url,
        body : {
          'id' : widget.list![widget.index!]['id'],
          'firstname' : firstName.text,
          'lastname' : lastName.text,
          'phone' : phone.text,
          'address' : address.text,
        });
      if(response.statusCode == 200){
        print('Response = ${response.body}') ;
      }else{
        print('update failed ') ;
      } ;
    }else {
      final url = Uri.parse('http://43.203.45.247/app1/add.php') ;
      final response = await http.post(url,
        body: {
          'firstname' : firstName.text ,
          'lastname' : lastName.text,
          'phone' : phone.text,
          'address' : address.text,
        }) ;
      if(response.statusCode == 200){
        print('Response = ${response.body}') ;
      }else{
        print('insert failed ') ;
      } ;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(editMode == true && widget.list != null ){
      editMode = true ;
      firstName.text = widget.list![widget.index!]['firstname'] ;
      lastName.text = widget.list![widget.index!]['lastname'] ;
      phone.text = widget.list![widget.index!]['phone'] ;
      address.text = widget.list![widget.index!]['address'] ;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : Text(editMode ? 'Update' : 'Add Data')),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: firstName,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: lastName,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: phone,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: address,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),),
          Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    addUpdateData() ;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(editMode ? 'Update' : 'Save', style: TextStyle(color: Colors.white),),
              ),),
        ],
      ),
    );
  }
}
