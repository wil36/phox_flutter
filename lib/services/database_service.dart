import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference filterCollection =
      FirebaseFirestore.instance.collection("filters");

  //saving the userdata
  Future savingUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "uid": uid,
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  savingFilter(Map<String, dynamic> filterData) async {
    try {
      DocumentReference filterDocumentReference =
          await filterCollection.add(filterData);
      filterDocumentReference.update({
        'userId': uid,
        'filterId': filterDocumentReference.id,
      });
      return true;
    } catch (e) {
      return 'an error has occurred';
    }
  }

  getFilterListOfUser() async {
    return filterCollection.where('userId', isEqualTo: uid).snapshots();
  }

  getdetailFilterOfUser(String docId) async {
    return await filterCollection.doc(docId).get();
  }

  Future resetFilter(String docId, String dateChange, String dateExpire) async {
    return await filterCollection.doc(docId).update({
      "dateChange": dateChange,
      "dateExpires": dateExpire,
    });
  }

  Future deleteFilter(String docId) async {
    return await filterCollection.doc(docId).delete();
  }
}
