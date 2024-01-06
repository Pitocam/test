import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark_todo/data/categori_model.dart';
import 'package:spark_todo/data/db_helper.dart';
import 'package:spark_todo/data/task_model.dart';
import 'package:spark_todo/data/utils.dart';
// import 'package:spark_todo/data/utils.dart';
import 'package:spark_todo/generated/assets.dart';
import 'package:spark_todo/ui/pages/sign_up_screen.dart';

import '../style/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String tag = "/HomeScreenRoute";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? dropdownValue = 1;
  int? dropdownValue2 = 1;
  int? currentCategory = 1;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(19, 5, 19, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Image.asset(Assets.imageHome),
                Image.asset(Assets.imageProImage)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(19, 74, 19, 60),
            height: 132,
            decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                      color: primary.withOpacity(0.3),
                      offset: Offset(-2, 10),
                      blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(33, 35, 0, 35),
                  child: Text(
                    "Manage your \ntime well",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Image.asset(
                  Assets.imageArrow,
                  width: 91,
                  height: 113,
                ),
                Icon(
                  CupertinoIcons.book_solid,
                  size: 64,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19),
            child: Text(
              "Categories",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 52),
            child: Container(
              height: 85,
              width: double.infinity,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: getCategory().length,
                  itemBuilder: (context, index) {
                    CategoryModel tmp = getCategory()[index];

                    return Container(
                      height: 82,
                      width: 51,
                      margin: EdgeInsets.only(
                          left: 38,
                          right: index == (categoryList.length - 1) ? 38 : 0),
                      child: Column(
                        children: [
                          Container(
                            height: 51,
                            width: 51,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: IconButton(

                                  onPressed: (){
                                    setState(() {
                                      currentCategory = tmp.id;
                                    });


                              }, icon: Image.asset(tmp.icon!,scale: 0.1,)),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            tmp.title ?? "No Title",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(19, 0, 50, 6),
            child: Text(
              "You have ${getTaskList().length} task's",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ValueListenableBuilder(valueListenable: getTaskBox().listenable(), builder: (context, value, child) {

              return ListView.builder(
                shrinkWrap: true,
                itemCount: getTaskList().length,
                itemBuilder: (context, index) {
                  TaskModel tmp = getTaskList()[index];
                  // var categoryBox = Hive.box<CategoryModel>(categoryBoxName);
                  var categoryID = tmp.categoryModel!.id;
                  // categoryID = currentCategory;
                // print("$currentCategory  $categoryID ${index}");
                    if(categoryID == currentCategory){
                      return Container(
                        decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                            offset: Offset(10,10),
                            spreadRadius: 10,
                            blurRadius: 5,
                            color: primary.withOpacity(0.1)
                        ),]
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(width: 1),
                          ),
                          elevation: 3,
                          shadowColor: primary,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: ListTile(

                            onTap: () {},
                            tileColor: Colors.white,
                            trailing: Image.asset(tmp.categoryModel!.icon!,),
                            leading: Checkbox(
                              value: tmp.isDone,
                              onChanged: (value) {
                                setState(() {
                                  tmp.isDone = !(tmp.isDone!);
                                  updateTask(tmp);
                                });
                              },
                            ),
                            title: Text(
                              tmp.title!,
                              style: tmp.isDone!
                                  ? TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough)
                                  : TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  return Container();
                }
              );
            },)
          ))
        ],
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => myBottomSheet(context),
            );
          },
          label: Text("Add")),
    );
  }

  Widget myBottomSheet(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 50, 14, 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          children: [
            StatefulBuilder(
              builder: (context, setState) => DropdownButton(
                items: getCategory()
                    .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Image.asset(e.icon!), Text(e.title ?? "No Title")],
                    )))
                    .toList(),
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {

                    dropdownValue = value;

                  });
                },
              ),
            ),
            SizedBox(height: 25,),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), filled: true, labelText: "Task"),
            ),
          ],
        ),
          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 5,
              fixedSize: Size(size.width, 56)
            ),
              onPressed: () async{
              var task = TaskModel(controller.text, getCategory().firstWhere((element) => element.id == dropdownValue,),false);
              await addTask(task);

              Navigator.pop(context);
              }, child: Text("Add")),

        ],
      ),
    );
  }
}
