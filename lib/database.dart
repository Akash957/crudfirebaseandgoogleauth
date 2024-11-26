import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection("User").snapshots();
  }
  Future updateEmployeeDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .update(updateInfo);
  }
  Future deleteEmployeeDetails(
      String id,) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .delete();
  }
}
