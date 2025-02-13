import 'package:Favorito/component/txtfieldprefix.dart';
import 'package:Favorito/ui/adSpent/PayAddHome.dart';
import 'package:flutter/material.dart';

import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';

class AddMoney extends StatefulWidget {
  var totalbal;
  AddMoney({
    Key key,
    this.totalbal,
  }) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  SizeManager sm;

  TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Money",
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
        centerTitle: true,
      ),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: sm.h(2), vertical: sm.h(2)),
            child: Container(
              height: sm.h(14),
              width: sm.h(90),
              child: Card(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Available Balance",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: myRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      Text(
                        widget.totalbal.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontSize: 28),
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: sm.h(2), vertical: sm.h(2)),
            child: txtfieldboundry(
              controller: _amount,
              hint: "Enter the amount",
              security: false,
              keyboardSet: TextInputType.number,
              title: "Amount",
              maxlen: 5,
              prefix: "\u{20B9}",
              inputTextSize: 18,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: sm.h(10), vertical: sm.h(2)),
            child: RoundedButton(
              clicker: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PayAddHome(amount: _amount.text))),
              title: "Proceed",
            ),
          )
        ],
      ),
    );
  }
}
