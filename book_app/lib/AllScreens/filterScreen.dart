import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilterScreen extends StatefulWidget {
  static const String idScreen = "filter";

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const String idScreen = "filter";
  String valueChoose;
  List listItem = ["author", "name", "rating"];
  TextEditingController field = new TextEditingController();
  TextEditingController feild_value = new TextEditingController();
  var firestore = FirebaseFirestore.instance.collection('Book').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        title: Text('Filter Book'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                size: 25.0,
              ),
              onPressed: () {
                _showDialog(context);
              },
            ),
          )
        ],
        foregroundColor: Colors.orange.shade400,
      ),
      body: StreamBuilder(
        stream: firestore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, int index) {
              return CustomCard(snapshot: snapshot.data, index: index);
            },
          );
        },
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(10),
              content: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 4.7,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("FILTER DATA"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        hint: Text("Select the Field:"),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20.0,
                        isExpanded: true,
                        value: valueChoose,
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose = newValue;
                          });
                        },
                        items: listItem.map(
                          (valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        decoration: InputDecoration(labelText: "Field value"),
                        controller: feild_value,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      field.clear();
                      feild_value.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      setState(() {
                         if (feild_value.text.isEmpty) {
                          displayToastMessage(
                              "Please enter the value", context);
                        } else {
                          firestore = FirebaseFirestore.instance
                              .collection('Book')
                              .where(valueChoose.trim(),
                                  isEqualTo: feild_value.text.trim())
                              .snapshots();
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text("Search"))
              ],
            ));
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}

class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.docs[index].data();
    var docId = snapshot.docs[index].id;

    TextEditingController nameInput =
        new TextEditingController(text: snapshotData['name']);
    TextEditingController authorInput =
        new TextEditingController(text: snapshotData['author']);
    TextEditingController rateInput =
        new TextEditingController(text: snapshotData['rating']);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          child: Card(
            elevation: 9,
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage("images/book.png"),
                    width: 90.0,
                    height: 90.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Book Name:  ${snapshot.docs[index]['name']}",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Author Name:  ${snapshot.docs[index]['author']}",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Rating:  ${snapshot.docs[index]['rating']}",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
