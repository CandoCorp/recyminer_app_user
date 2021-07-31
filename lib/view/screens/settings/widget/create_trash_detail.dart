import 'package:flutter/material.dart';

Row createTrashRowDetail(TextFormField textFormField,  image, int weight) {
  int _counter = 0;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          Image.asset(
            'assets/image/$image',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          Text(
            '$weight Kg',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )

        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 60,
            child: textFormField,
          )
        ],
      ),
      Column(
          children: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                _counter++;
                textFormField.controller.text = "$_counter";
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                if(_counter == 0) return;
                _counter--;
                textFormField.controller.text = "$_counter";
              },
              child: Icon(
                Icons.remove,
                size: 30,
              ),
            )
          ])
    ],
  );
}
