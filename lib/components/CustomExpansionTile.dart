// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String trailingText;
  final IconData trailingIcon;
  final String type;
  final VoidCallback? onPressed;
  final String transId;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.trailingIcon,
    required this.type,
    required this.transId,
    this.onPressed,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String actionText = widget.type == 'credit' ? 'Deposit' : 'Withdraw';

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: _isExpanded ? Colors.grey[200] : Colors.transparent,
            child: ListTile(
              title: Text(
                actionText,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text(
                widget.subtitle,
                style: GoogleFonts.openSans(
                    fontSize: 13,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.type == 'debit'
                      ? Text(
                          "-₹" + widget.trailingText,
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.type == 'debit'
                                  ? Colors.blue
                                  : Colors.green),
                        )
                      : Text(
                          "+₹" + widget.trailingText,
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.type == 'debit'
                                  ? Colors.blue
                                  : Colors.green),
                        ),
                  SizedBox(width: 8),
                  RotationTransition(
                    turns: AlwaysStoppedAnimation(_isExpanded ? 0.5 : 0),
                    child: Icon(
                      widget.trailingIcon,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                if (widget.onPressed != null) {
                  widget.onPressed!();
                }
              },
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${widget.trailingText}',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction Date: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.subtitle}',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction ID: ', // Add your transaction ID here
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.transId, // Replace with your actual ID
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
