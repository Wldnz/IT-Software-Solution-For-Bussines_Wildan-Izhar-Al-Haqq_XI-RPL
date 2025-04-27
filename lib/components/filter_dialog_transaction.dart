import 'package:flutter/material.dart';

class FilterDialogTransaction extends StatefulWidget {
  final Function(Map<String, dynamic> products) onSubmit;
  final Map<String, dynamic> selectedFilter;
  const FilterDialogTransaction({
    super.key,
    required this.selectedFilter,
    required this.onSubmit,
  });
  @override
  State<FilterDialogTransaction> createState() =>
      _FilterDialogTransactionState();
}

class _FilterDialogTransactionState extends State<FilterDialogTransaction> {
  Map<String, dynamic> defaultSelectedFilter = {
    "status": "",
    "price": "",
    "created_at": "",
  };
  Map<String, dynamic> selectedFilter = {};
  @override
  void initState() {
    selectedFilter = widget.selectedFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filter Product'),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, size: 30.0),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.0,
        children: [
          _filterBox("Price", [
            _cardValue("Highest Price", "price"),
            _cardValue("Lowest Price", "price"),
          ]),
          _filterBox("Status", [
            _cardValue("Completed", "status"),
            _cardValue("Checking", "status"),
            _cardValue("Rejected", "status"),
          ]),
          _filterBox("Publish By", [
            _cardValue("7 Days", "created_at"),
            _cardValue("14 Days", "created_at"),
            _cardValue("30 Days", "created_at"),
          ]),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  widget.onSubmit(defaultSelectedFilter);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 5.0,
                    top: 5.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    " Reset ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onSubmit(selectedFilter);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 5.0,
                    top: 5.0,
                    left: 30.0,
                    right: 30.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueAccent,
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _filterBox(String name, List<Widget> listValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Wrap(spacing: 10.0, runSpacing: 10.0, children: listValue),
      ],
    );
  }

  GestureDetector _cardValue(String name, String fieldName) {
    return GestureDetector(
      onTap: () {
        if (selectedFilter[fieldName] == name) {
          selectedFilter[fieldName] = "";
        } else {
          selectedFilter[fieldName] = name;
        }
        setState(() => {});
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: 15.0,
          right: 15.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8.0),
          color:
              selectedFilter[fieldName] == name
                  ? Colors.blueAccent
                  : Colors.white,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: "Poppins",
            color:
                selectedFilter[fieldName] == name ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
