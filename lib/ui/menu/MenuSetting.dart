import 'package:Favorito/Functions/PopmyPage.dart';
import 'package:Favorito/component/CustomSwitch.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuSetting extends StatefulWidget {
  @override
  _MenuSettingState createState() => _MenuSettingState();
}

class _MenuSettingState extends State<MenuSetting> {
  bool isFirst = true;

  SizeManager sm;

  bool _needValidate = false;

  MaterialLocalizations localizations;

  MenuProvider vaTrue;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      sm = SizeManager(context);
      vaTrue = Provider.of<MenuProvider>(context, listen: true);
      vaTrue
        ..menuSettingsGetServiceCall()
        ..setNeedSave(false);
      localizations = MaterialLocalizations.of(context);
      vaTrue.initcall();
      isFirst = false;
    }
    return Scaffold(
        key: RIKeys.josKeys17,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {}),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Menu Setting", style: TextStyle(color: Colors.black)),
        ),
        body: Consumer<MenuProvider>(builder: (context, _data, child) {
          return WillPopScope(
            onWillPop: () => popMethod(_data),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Builder(builder: (context) {
                  return Form(
                    key: RIKeys.josKeys16,
                    autovalidate: _needValidate,
                    child: ListView(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Accepting Orders",
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              CustomSwitch(
                                value: _data.acceptingOrder,
                                activeColor: Color(0xff1dd100),
                                inactiveColor: Colors.red,
                                activeText: "Online",
                                inactiveText: "Offline",
                                activeTextColor: Colors.white,
                                inactiveTextColor: Colors.white,
                                onChanged: (value) =>
                                    _data.acceptingOrderOnOff(),
                              ),
                            ]),
                        Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Take Away",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Switch(
                                      value: _data.takeAway,
                                      onChanged: (value) {
                                        _data.takeawayOnOff();
                                      },
                                      activeTrackColor: Colors.grey,
                                      activeColor: Colors.red)
                                ])),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, left: 30.0),
                            child: Text("Time",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int _i = 0; _i <= 1; _i++)
                                  InkWell(
                                    onTap: () {
                                      _data.getTimePicker(
                                          _i, context, localizations);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: myGreyLight2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        alignment: Alignment.center,
                                        width: sm.w(24),
                                        height: sm.h(5),
                                        child: Text(
                                            vaTrue.controller[_i].text ??
                                                'select')),
                                  ),
                              ]),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 32.0, top: 16.0, right: 16.0),
                            child: txtfieldboundry(
                                controller: _data.controller[2],
                                title: "Minimum Bill",
                                hint: "Enter minimum amount",
                                security: false,
                                prefix: '\u20B9: ',
                                keyboardSet: TextInputType.number,
                                maxlen: 10,
                                maxLines: 1,
                                myOnChanged: (_) => _data.setNeedSave(true),
                                valid: true)),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 32.0, top: 16.0, right: 16.0),
                            child: txtfieldboundry(
                                controller: _data.controller[3],
                                title: "Packaging Charge",
                                hint: "Enter packaging charge",
                                prefix: '\u20B9: ',
                                keyboardSet: TextInputType.number,
                                maxlen: 10,
                                maxLines: 1,
                                security: false,
                                myOnChanged: (_) => _data.setNeedSave(true),
                                valid: true)),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Dine-in",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Switch(
                                    value: _data.dineIn,
                                    onChanged: (value) => _data.dineInOnOff(),
                                    activeTrackColor: Colors.grey,
                                    activeColor: Colors.red)
                              ]),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 24.0, left: 32.0),
                            child: Text("Time",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int _i = 4; _i <= 5; _i++)
                                InkWell(
                                  onTap: () {
                                    _data.getTimePicker(
                                        _i, context, localizations);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: myGreyLight2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      alignment: Alignment.center,
                                      width: sm.w(24),
                                      height: sm.h(5),
                                      child: Text(vaTrue.controller[_i].text ??
                                          'select')),
                                ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Switch(
                                    value: _data.delivery,
                                    onChanged: (value) => _data.deliveryOnOff(),
                                    activeTrackColor: Colors.grey,
                                    activeColor: Colors.red)
                              ]),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 24.0, left: 32.0),
                            child: Text("Time",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int _i = 6; _i <= 7; _i++)
                                InkWell(
                                  onTap: () {
                                    _data.getTimePicker(
                                        _i, context, localizations);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: myGreyLight2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      alignment: Alignment.center,
                                      width: sm.w(24),
                                      height: sm.h(5),
                                      child: Text(vaTrue.controller[_i].text ??
                                          'select')),
                                ),
                            ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 32.0, top: 16.0, right: 16.0),
                            child: txtfieldboundry(
                                controller: _data.controller[8],
                                title: "Minimum Bill",
                                hint: "Enter minimum amount",
                                security: false,
                                prefix: '\u20B9: ',
                                keyboardSet: TextInputType.number,
                                maxlen: 10,
                                maxLines: 1,
                                myOnChanged: (_) => _data.setNeedSave(true),
                                valid: true)),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 32.0, top: 16.0, right: 16.0),
                          child: txtfieldboundry(
                              controller: _data.controller[9],
                              title: "Packaging Charge",
                              hint: "Enter packaging charge",
                              security: false,
                              prefix: '\u20B9: ',
                              keyboardSet: TextInputType.number,
                              maxlen: 10,
                              maxLines: 1,
                              myOnChanged: (_) => _data.setNeedSave(true),
                              valid: true),
                        ),
                        Visibility(
                          visible: _data.needSave,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: sm.w(15), vertical: 16.0),
                            child: RoundedButton(
                              clicker: () {
                                if (RIKeys.josKeys16.currentState.validate()) {
                                  _data.saveSettingServiceCall();
                                } else {
                                  _needValidate = true;
                                }
                                _data.notifyListeners();
                              },
                              clr: Colors.red,
                              title: "Save",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
          );
        }));
  }

  popMethod(_data) {
    print("fffffff");
    if (_data.needSave) {
      PopmyPage(
          key: RIKeys.josKeys17,
          cancel: () {
            Navigator.pop(RIKeys.josKeys17.currentContext);
            Navigator.pop(RIKeys.josKeys17.currentContext);
          },
          save: () {
            if (RIKeys.josKeys16.currentState.validate()) {
              Navigator.pop(RIKeys.josKeys17.currentContext);
              _data.saveSettingServiceCall();
            } else {
              _needValidate = true;
              _data.notifyListeners();
              Navigator.pop(RIKeys.josKeys17.currentContext);
            }
          }).popMe();
    } else {
      Navigator.pop(RIKeys.josKeys17.currentContext);
    }
  }
}
