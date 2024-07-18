import 'package:flutter/material.dart';
//import 'package:pro/db_handler.dart';
//import 'package:pro/model.dart';
import 'package:todonew/db_handler.dart';
import 'package:todonew/model.dart';
import 'add_update_screen.dart';


class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DbHelper? dbHelper;
  late Future<List<ToDoModel>> dataList;

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
    // TODO: implement build
    //   throw UnimplementedError();
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('To Do Task', style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 1),),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<ToDoModel>> snapshot) {
              if(!snapshot.hasData || snapshot.data == null ){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.data!.length == 0){
                return Center(
                  child:  Text(
                    " No Task Found ",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                );

              }
              else{
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder:(context,index){
                      int todoId=snapshot.data![index].id!.toInt();
                      String todoTitle = snapshot.data![index].title.toString();
                      String todoDesc = snapshot.data![index].desc.toString();
                      String todoDT = snapshot.data![index].dateandtime.toString();

                      return Dismissible(key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.redAccent,
                          child: Icon(Icons.delete_forever,color: Colors.white,),
                        ),onDismissed: (DismissDirection direction) {
                          setState(() {
                            dbHelper!.delete(todoId);
                            dataList = dbHelper!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade500,
                            boxShadow: [
                              BoxShadow(color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(10),
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    todoTitle,style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                subtitle: Text(
                                  todoDesc,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.8,
                              ),
                              Padding(padding: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(todoDT,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic),),InkWell(
                                      onTap: (){
                                        Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                            AddUpdatedTask(
                                              todoId: todoId,
                                              todoTitle: todoTitle,
                                              todoDesc: todoDesc,
                                              todoDT: todoDT,
                                              update: true,
                                            ),
                                        ));
                                      },
                                      child: Icon(Icons.edit_note, size: 28,color:Colors.green,),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                );
              }
            },
          )),
        ],),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=> AddUpdatedTask(),

          ) );
        },
      ),
    );
  }


}