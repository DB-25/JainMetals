import 'dart:async';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class GetItemDetails extends StatefulWidget {
  final FirebaseApp app;
  final String name;
  final String category;
  final String description;
  final String dimension;
  final String price;
  final String weight;
  final bool edit;
  final DocumentReference docRef;
  GetItemDetails(
      {this.app,
      this.dimension,
      this.category,
      this.price,
      this.weight,
      this.description,
      this.name,
      this.docRef,
      this.edit});
  @override
  _GetItemDetailsState createState() => _GetItemDetailsState(
      app: app,
      name: name,
      description: description,
      weight: weight,
      price: price,
      category: category,
      dimension: dimension,
      edit: edit,
      docRef: docRef);
}

class _GetItemDetailsState extends State<GetItemDetails> {
  final FirebaseApp app;
  final bool edit;

  final DocumentReference docRef;
  _GetItemDetailsState(
      {this.app,
      this.name,
      this.description,
      this.weight,
      this.price,
      this.category,
      this.dimension,
      this.edit,
      this.docRef});

  Future<DocumentReference> addData(String name, String category,
      String description, String dimension, String price, String weight) {
    return FirebaseFirestore.instance.collection('item').add(({
          'name': name,
          'category': category,
          'description': description,
          'dimension': dimension,
          'price': price,
          'weight': weight,
          'imageUrl': _uploadedFileURL,
        }));
  }

  String name;
  String category;
  String description;
  String dimension;
  String price;
  String weight;

  List<String> categories = [
    "Buddha Idol",
    "Ganesha Idol",
    "Lakshmi",
    "Saraswati",
    "Radha Krishna",
    "Durga",
    "Cow and Calf",
    "Wall Hanging",
    "Home Decor",
    "Urli",
    "Bronze Statue",
    "Copper",
    "Brass",
    "Others",
  ];

  PickedFile _image;
  List<String> _uploadedFileURL = [];
  ImagePicker _picker = ImagePicker();

  Future<void> updateData() {
    return docRef
        .update({
          'name': name,
          'category': category,
          'description': description,
          'dimension': dimension,
          'price': price,
          'weight': weight,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future chooseFile() async {
    final image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      uploadFile(_image);
    }
  }

  /// The user selects a file, and the task is added to the list.
  Future<void> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }
    firebase_storage.UploadTask uploadTask;
    print(Path.basename(_image.path));
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .refFromURL('gs://jainmetals-b875f.appspot.com/')
        .child('images/${Path.basename(_image.path)}');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
    }
    await uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) {
        setState(() {
          _uploadedFileURL.add(value);
        });
      });
    });
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    if (category == null) category = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                autofillHints: [name],
                decoration: InputDecoration(
                  labelText:
                      (!edit || name == null) ? "name" : name + " - Name",
                ),
                onChanged: (value) => name = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: category,
                  //elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "Select Category",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      category = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                autofillHints: [description],
                decoration: InputDecoration(
                    labelText: (edit && description != null)
                        ? description + " - Description"
                        : 'Description'),
                onChanged: (value) => description = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                autofillHints: [dimension],
                decoration: InputDecoration(
                    labelText: (edit && dimension != null)
                        ? dimension + " - Dimension (LxBxH)"
                        : 'Dimension (LxBxH)'),
                onChanged: (value) => dimension = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                autofillHints: [price],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText:
                        (edit && price != null) ? price + " - Price" : 'Price'),
                onChanged: (value) => price = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                autofillHints: [weight],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: (edit && weight != null)
                        ? weight + " - Weight(in Kg)"
                        : 'Weight (in Kg)'),
                onChanged: (value) => weight = value,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            (!edit)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: (_uploadedFileURL == null ||
                            _uploadedFileURL.length <= 1)
                        ? 140.0
                        : (_uploadedFileURL.length <= 3)
                            ? 280
                            : ((_uploadedFileURL.length / 2.floor() + 1) * 140)
                                .floorToDouble(),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: (_uploadedFileURL == null)
                          ? 1
                          : _uploadedFileURL.length + 1,
                      itemBuilder: (BuildContext ctx, index) {
                        return (_uploadedFileURL == null)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  color: Color(0xff01A0C7),
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  child: Center(
                                    child: TextButton(
                                      child: Text('+',
                                          style: style.copyWith(
                                              color: Color(0xff01A0C7),
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        chooseFile();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : (index >= _uploadedFileURL.length)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12),
                                      padding: EdgeInsets.all(6),
                                      color: Color(0xff01A0C7),
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      child: Center(
                                        child: TextButton(
                                          child: Text('+',
                                              style: style.copyWith(
                                                  color: Color(0xff01A0C7),
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            chooseFile();
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12),
                                      padding: EdgeInsets.all(3),
                                      color: Color(0xff01A0C7),
                                      strokeWidth: 1,
                                      strokeCap: StrokeCap.butt,
                                      child: Center(
                                        child: Image.network(
                                          _uploadedFileURL[index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                      },
                    ),
                  )
                : Container(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  child: (edit)
                      ? Text('UPDATE',
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold))
                      : Text('ADD',
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                  onPressed: (edit)
                      ? () async {
                          updateData();
                          Navigator.pop(context);
                        }
                      : () async {
                          if (_uploadedFileURL != null) {
                            DocumentReference ref = await addData(
                                name,
                                category,
                                description,
                                dimension,
                                price,
                                weight);
                            if (ref.id != null) {
                              Navigator.pop(context);
                            }
                          }
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
