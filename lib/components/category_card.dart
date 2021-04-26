import 'package:flutter/material.dart';
import 'package:jain_metals/screens/home_screen.dart';

class CategoryCard extends StatefulWidget {
  CategoryCard(this.title, this.admin);
  final String title;
  final bool admin;

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                width: 500,
                child: ListTile(
                  leading: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      widget.title,
                      style: style,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                  onTap: () {
                    setState(() {
                      currentSelectedCategory = widget.title;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(widget.admin)));
                    });
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
