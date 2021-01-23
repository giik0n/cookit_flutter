import 'package:cookit/models/Ingridient.dart';
import 'package:cookit/models/IngridientCounts.dart';
import 'package:cookit/models/Recipe.dart';
import 'package:cookit/services/database.dart';
import 'package:cookit/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

class AddRecipe extends StatefulWidget {
  AddRecipe({Key key}) : super(key: key);

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<Ingridient> searchIntersections = [];
  TextEditingController controller = TextEditingController();
  String valueTmp = "";
  Recipe recipeTmp = Recipe(
    ingridientCounts: [],
  );

  @override
  Widget build(BuildContext context) {
    var dataKey = GlobalKey();
    Widget addPhotoW = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).backgroundColor.withOpacity(0.7),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: Center(
              child: Icon(Icons.add_a_photo_outlined),
            ),
          ),
        ),
      ),
    );

    Widget searchListW = Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Center(
        child: Container(
          height: 150.0,
          width: MediaQuery.of(context).size.width * 0.85,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < searchIntersections.length; i++)
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset:
                                    Offset(1, 2), // changes position of shadow
                              ),
                            ],
                            color:
                                ingridientColors[searchIntersections[i].color],
                            borderRadius: BorderRadius.circular(8)),
                        child: GestureDetector(
                          onTap: () async {
                            print(dataKey.currentContext);
                            print(recipeTmp.ingridientCounts.length);

                            double count = await showDialog(
                              context: context,
                              builder: (_) => NumberPickerDialog.decimal(
                                  title: Text("Choose portion in " +
                                      ((searchIntersections[i].isInGramms == 0)
                                          ? "pieces"
                                          : "100 grams")),
                                  minValue: 1,
                                  maxValue: 100,
                                  initialDoubleValue: 1.0),
                            );
                            if (count != null) {
                              var ingCount = IngridientCounts(
                                  count: count,
                                  ingridient: searchIntersections[i]);
                              setState(() {
                                controller.text = "";
                                int len = recipeTmp.ingridientCounts
                                    .where((element) =>
                                        element.ingridient.name ==
                                        searchIntersections[i].name)
                                    .length;
                                print("len:" + len.toString());
                                if (len > 0) {
                                  print("exists");
                                  int index = recipeTmp.ingridientCounts
                                      .indexWhere((element) =>
                                          element.ingridient.name ==
                                          searchIntersections[i].name);
                                  recipeTmp.ingridientCounts
                                      .elementAt(index)
                                      .count += count;
                                } else {
                                  print("not exists");
                                  recipeTmp.ingridientCounts.add(ingCount);
                                }
                              });
                            }
                          },
                          child: Padding(
                            key: i == 0 ? dataKey : null,
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                capitalize(searchIntersections[i].name),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                if ((controller.text.length > 0 &&
                        searchIntersections.length == 0) ||
                    (controller.text.length > 0 &&
                        searchIntersections
                                .where((element) =>
                                    element.name.toLowerCase() ==
                                    controller.text.toLowerCase())
                                .length ==
                            0))
                  Container(
                    //key: dataKey,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(1, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: FlatButton(
                      onPressed: () async {
                        Ingridient isUpdate =
                            await addNewIngridient(controller.text.trim());
                        if (isUpdate != null) {
                          setState(() {
                            searchIntersections.add(isUpdate);
                          });
                        }
                      },
                      child: Center(
                        child: Text("Cant find \"" +
                            controller.text.trim() +
                            "\", add new?"),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );

    Widget searchTextFieldW = TextField(
      decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.circular(50)),
          enabledBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.circular(50)),
          focusedBorder: new OutlineInputBorder(
              borderSide: new BorderSide(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.circular(50)),
          prefixIcon: Icon(Icons.search),
          hintText: "Search your ingridients"),
      controller: controller,
      onChanged: (value) async {
        List<Ingridient> tmp = [];

        if (value.isNotEmpty) {
          tmp = await DatabaseService().searchIngridient(value);

          setState(() {
            searchIntersections = tmp;
          });
          Scrollable.ensureVisible(dataKey.currentContext);
        } else {
          searchIntersections.clear();

          setState(() {});
          Scrollable.ensureVisible(dataKey.currentContext);
        }
      },
    );

    Widget ingridientsW = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 230,
            //color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 64.0),
                        child: Container(
                          height: 144,
                          child: SingleChildScrollView(
                            child: Center(
                              child: Wrap(
                                children: [
                                  for (var i = 0;
                                      i < recipeTmp.ingridientCounts.length;
                                      i++)
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Chip(
                                        backgroundColor: ingridientColors[
                                            recipeTmp.ingridientCounts[i]
                                                .ingridient.color],
                                        label: Text(recipeTmp
                                                .ingridientCounts[i].count
                                                .toString() +
                                            " x " +
                                            capitalize(recipeTmp
                                                .ingridientCounts[i]
                                                .ingridient
                                                .name)),
                                        onDeleted: () {
                                          recipeTmp.ingridientCounts
                                              .removeAt(i);
                                          setState(() {});
                                        },
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.text.length > 0) searchListW,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: Padding(
                          padding:
                              //const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: searchTextFieldW,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Share Your Recipe"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [addPhotoW, ingridientsW],
        ),
      ),
    );
  }

  addNewIngridient(String name) {
    TextEditingController controller = TextEditingController();
    TextEditingController controllerKcal = TextEditingController();
    controller.text = capitalize(name);
    int selectedColor = 3;
    int _groupValue = 1;
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Add new ingridient"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: controller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: StatefulBuilder(
                  builder: (context, setRadioState) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: 0,
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  setRadioState(() {
                                    _groupValue = value;
                                  });
                                }),
                            Text("In pieces"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: (value) {
                                setRadioState(() {
                                  _groupValue = value;
                                });
                              },
                            ),
                            Text("In gramms")
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              StatefulBuilder(builder: (context, setColorState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < ingridientColors.length; i++)
                      GestureDetector(
                        onTap: () {
                          setColorState(() {
                            selectedColor = i;
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          color: ingridientColors[i],
                          child: i == selectedColor
                              ? Icon(Icons.check, color: Colors.white)
                              : SizedBox.shrink(),
                        ),
                      )
                  ],
                );
              }),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                  ],
                  controller: controllerKcal,
                  decoration: InputDecoration(
                      hintText: "Callories in one piece/100 gramm"),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: RaisedButton(
                      onPressed: () async {
                        Ingridient newIngridient = Ingridient(
                          name: controller.text.toLowerCase(),
                          color: selectedColor,
                          isInGramms: _groupValue,
                          kcal: double.parse(controllerKcal.text),
                        );
                        await DatabaseService().addIngridient(newIngridient);

                        //search.add(controller.text);
                        Navigator.pop(context, newIngridient);
                      },
                      child: Text("Add"),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String unCapitalize(String s) => s[0].toLowerCase() + s.substring(1);
}
