import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit/models/Ingridient.dart';
import 'package:cookit/models/User.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference usersCollection =
      Firestore.instance.collection("users");
  final CollectionReference ingridientsCollection =
      Firestore.instance.collection("ingridients");
  final CollectionReference categoriesCollection =
      Firestore.instance.collection("categories");

  Future initUser(User user) async {
    return await usersCollection.document(user.id).setData({
      'email': user.email,
      'token': user.token,
    });
  }

  Future addIngridient(Ingridient ingridient) async {
    return await ingridientsCollection.add({
      "title": ingridient.name,
      "isInGrams": ingridient.isInGramms,
      "isVerified": false,
      "color": ingridient.color,
      "kcal": ingridient.kcal,
      "caseSearch": setSearchParam(ingridient.name),
    });
  }

  Future<List<Ingridient>> searchIngridient(String text) async {
    List<Ingridient> ingridients = [];
    await ingridientsCollection
        .where("caseSearch", arrayContainsAny: text.toLowerCase().split(" "))
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        ingridients.add(new Ingridient(
            id: element.documentID,
            name: element.data['title'],
            isInGramms: element.data['isInGrams'],
            isVerified: element.data['isVerified'],
            color: element.data['color'],
            kcal: double.parse(element.data['kcal'].toString())));
      });
    });

    return ingridients;
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    var splitResult = caseNumber.split(" ");
    for (var i = 0; i < splitResult.length; i++) {
      caseSearchList.add(splitResult[i].substring(1));
      String temp = "";
      for (int j = 0; j < splitResult[i].length; j++) {
        temp = temp + splitResult[i][j];
        caseSearchList.add(temp);
      }
    }
    return caseSearchList;
  }

  initCategories() {}
}
