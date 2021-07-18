import 'package:book_app/AllScreens/filterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final user = FirebaseFirestore.instance.collection('Book');

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);
  static const String idScreen = "main";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController name;
  TextEditingController author;
  TextEditingController rate;

  @override
  void initState() {
    // TODO: implement initState
    name = new TextEditingController();
    author = new TextEditingController();
    rate = new TextEditingController();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        title: Text('My books'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.sort,
              size: 25.0,),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => FilterScreen(),
                    ));
              },

            ),
          )
        ],
        foregroundColor: Colors.orange.shade400,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Book').snapshots(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
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
                height: MediaQuery.of(context).size.height / 3.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("ADD BOOK"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        decoration: InputDecoration(labelText: "Book Name"),
                        controller: name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        decoration: InputDecoration(labelText: "Author's Name"),
                        controller: author,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        decoration:
                            InputDecoration(labelText: "Book's Rating(1-5)"),
                        controller: rate,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      name.clear();
                      author.clear();
                      rate.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                FlatButton(
                    onPressed: () {
                      if (name.text.isEmpty) {
                        displayToastMessage(
                            "Please enter the book name", context);
                      } else if (author.text.isEmpty) {
                        displayToastMessage(
                            "Please enter the author's name", context);
                      } else if (rate.text.isEmpty) {
                        displayToastMessage(
                            "Please give some rating ", context);
                      } else {
                        if (int.parse(rate.text.toString()) > 0 &&
                            int.parse(rate.text.toString()) < 6) {
                          FirebaseFirestore.instance.collection('Book').add({
                            "name": name.text,
                            "author": author.text,
                            "rating": rate.text,
                          }).then((value) {
                            print(value.id);
                            name.clear();
                            author.clear();
                            rate.clear();
                            Navigator.pop(context);
                          }).catchError((error) => print(error));
                        } else {
                          displayToastMessage(
                              "Rating value must be in between 1-5", context);
                        }
                      }
                    },
                    child: Text("Save"))
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.edit,
                          size: 20.0,
                        ),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    contentPadding: EdgeInsets.all(10),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.5,
                                      child: Column(
                                        children: [
                                          Text("UPDATE DETAILS"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              autofocus: true,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                  labelText: "Book Name"),
                                              controller: nameInput,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              autofocus: true,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                  labelText: "Author's Name"),
                                              controller: authorInput,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              autofocus: true,
                                              autocorrect: true,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      "Book's Rating (1-5)"),
                                              controller: rateInput,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            nameInput.clear();
                                            authorInput.clear();
                                            rateInput.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      FlatButton(
                                          onPressed: () {
                                            if (nameInput.text.isEmpty) {
                                              displayToastMessage(
                                                  "Please enter the book name",
                                                  context);
                                            } else if (authorInput
                                                .text.isEmpty) {
                                              displayToastMessage(
                                                  "Please enter the author's name",
                                                  context);
                                            } else if (rateInput.text.isEmpty) {
                                              displayToastMessage(
                                                  "Please give some rating ",
                                                  context);
                                            } else {
                                              if (int.parse(rateInput.text
                                                          .toString()) >
                                                      0 &&
                                                  int.parse(rateInput.text
                                                          .toString()) <
                                                      6) {
                                                FirebaseFirestore.instance
                                                    .collection('Book')
                                                    .doc(docId)
                                                    .update({
                                                  "name": nameInput.text,
                                                  "author": authorInput.text,
                                                  "rating": rateInput.text,
                                                }).then((value) {
                                                  nameInput.clear();
                                                  authorInput.clear();
                                                  rateInput.clear();
                                                  Navigator.pop(context);
                                                }).catchError((error) =>
                                                        print(error));
                                              } else {
                                                displayToastMessage(
                                                    "Rating value must be in between 1-5",
                                                    context);
                                              }
                                            }
                                          },
                                          child: Text("Update"))
                                    ],
                                  ));
                        }),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.trashAlt,
                          size: 20.0,
                        ),
                        onPressed: () async {
                          var CollectionReference =
                              FirebaseFirestore.instance.collection('Book');
                          await CollectionReference.doc(docId).delete();
                        })
                  ],
                )
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
