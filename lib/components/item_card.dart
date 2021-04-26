import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jain_metals/components/getItemDetails.dart';
import 'package:jain_metals/screens/imageScreen.dart';

class ItemCard extends StatefulWidget {
  ItemCard(
      {this.imageUrl,
      this.weight,
      this.price,
      this.dimension,
      this.description,
      this.name,
      this.category,
      this.admin,
      this.docRef});
  final List<dynamic> imageUrl;
  final String name;
  final String price;
  final String category;
  final String weight;
  final String dimension;
  final String description;
  final bool admin;
  final DocumentReference docRef;

  @override
  _ItemCardState createState() => _ItemCardState(
      category: category,
      price: price,
      imageUrl: imageUrl,
      name: name,
      weight: weight,
      dimension: dimension,
      description: description,
      admin: admin,
      docRef: docRef);
}

class _ItemCardState extends State<ItemCard> {
  _ItemCardState(
      {this.imageUrl,
      this.weight,
      this.price,
      this.dimension,
      this.description,
      this.name,
      this.category,
      this.admin,
      this.docRef});
  final List<dynamic> imageUrl;
  final String name;
  final String price;
  final String category;
  final String weight;
  final String dimension;
  final String description;
  final bool admin;

  final DocumentReference docRef;

  Future<void> deleteData() {
    return docRef
        .delete()
        .then((value) => print("Item Deleted"))
        .catchError((error) => print("Failed to delete item: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 600,
      child: Card(
        elevation: 0,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImageScreen(widget.imageUrl)));
                      },
                      child: CarouselSlider.builder(
                          itemCount: widget.imageUrl.length,
                          options: CarouselOptions(
                            autoPlay:
                                (widget.imageUrl.length == 1) ? false : true,
                          ),
                          itemBuilder:
                              (BuildContext context, int itemIndex, int a) {
                            return Image.network(
                              widget.imageUrl[itemIndex],
                            );
                          }),
                    ),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                (widget.description == null)
                    ? Container()
                    : Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.description,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Wt: " + widget.weight + " Kg",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "LxBxH: " + widget.dimension,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "₹ " + widget.price,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
            (widget.admin)
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color(0xffff8906),
                            size: 30,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  print(description);
                                  print(dimension);
                                  return GetItemDetails(
                                      app: null,
                                      dimension: dimension,
                                      category: category,
                                      price: price,
                                      weight: weight,
                                      description: description,
                                      name: name,
                                      docRef: docRef,
                                      edit: true);
                                });
                          }),
                    ),
                  )
                : Container(),
            (widget.admin)
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Color(0xfff25f4c),
                            size: 30,
                          ),
                          onPressed: () {
                            deleteData();
                          }),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
