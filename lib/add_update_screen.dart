import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:pro/db_handler.dart';
// import 'package:pro/home_screen.dart';
// import 'package:pro/model.dart';
import 'package:todonew/db_handler.dart';
import 'package:todonew/home_screen.dart';
import 'package:todonew/model.dart';

class AddUpdatedTask extends StatefulWidget{

  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  AddUpdatedTask({

    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDT,
    this.update,
  });
  @override
  State<AddUpdatedTask> createState() => _AddUpdatedTaskState();
}

class _AddUpdatedTaskState extends State<AddUpdatedTask> {



  DbHelper? dbHelper;
  late Future<List<ToDoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }
  loadData() async{
    dataList= dbHelper!.getDataList();

  }
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if(widget.update == true){
      appTitle="Update Task";
    }else{
      appTitle="Add Task";
    }

    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Add/Update Task',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(),
          child: Column(children: [
            Form(
              key: _fromKey,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        keyboardType: TextInputType.multiline,

                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Note Title',
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return " enter some text";
                          }
                          return null;
                        }
                    ),),
                  SizedBox(height: 10),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 5,
                        controller: descController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Note Title',
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return " enter some text";
                          }
                          return null;
                        }
                    ),),
                ],
              ),

            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                    child: InkWell(
                      onTap:(){
                        if(_fromKey.currentState!.validate()){
                          dbHelper!.insert(ToDoModel(
                              title: titleController.text,
                              desc:  descController.text,
                              dateandtime: DateFormat('yMd')
                                  .add_jm()
                                  .format(DateTime.now())
                                  .toString()));
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
                          titleController.clear();
                          descController.clear();
                          print("Data Added");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black,
                          //     blurRadius: 5,
                          //     spreadRadius: 2,
                          //   ),
                          // ],
                        ),
                        child: Text('Submit',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap:(){
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black,
                          //     blurRadius: 5,
                          //     spreadRadius: 2,
                          //   ),
                          // ],
                        ),
                        child: Text('Clear',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                    ),
                  )
                ],
              ),

            ),
          ],),
        )
    );
  }
}