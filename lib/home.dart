import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudfirebase/database.dart';
import 'package:crudfirebase/useradd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("No User Data Available"));
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

            return Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name: ${data["Name"] ?? 'N/A'}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              namecontroller.text = ds["Name"];
                              agecontroller.text = ds["Age"];
                              locationcontroller.text = ds["Location"];
                              EditEmployeeDetail(ds["Id"]);
                            },
                            child: Icon(Icons.edit)),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () async {
                              await DatabaseMethods()
                                  .deleteEmployeeDetails(ds["Id"]);
                            },
                            child: Icon(Icons.delete))
                      ],
                    ),
                    if (data.containsKey("Age"))
                      Text(
                        "Age: ${data["Age"]}",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    // Location
                    Text(
                      "Location: ${data["Location"] ?? 'N/A'}",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Useradd(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.orange,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              'Flutter',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Firebase',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }

  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel),
                        ),
                        Text(
                          'Edit Details',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: namecontroller,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      "Age",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: agecontroller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Location input field
                    Text(
                      "Location",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: locationcontroller,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                        child: ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> updateInfo = {
                                "Name": namecontroller.text,
                                "Age": agecontroller.text,
                                "Id": id,
                                "Location": locationcontroller.text,
                              };
                              await DatabaseMethods()
                                  .updateEmployeeDetails(id, updateInfo)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Updata")))
                  ],
                ),
              ),
            ),
          ));
}
