import 'dart:ui';
import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/component/card1.dart';
import 'package:Favorito/component/card2.dart';
import 'package:Favorito/component/card3.dart';
import 'package:Favorito/component/rowWithTextNButton.dart';
import 'package:Favorito/component/showPopup.dart';
import 'package:Favorito/model/dashModel.dart';
import 'package:Favorito/network/RequestModel.dart';
import 'package:Favorito/network/serviceFunction.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/catalog/Catalogs.dart';
import 'package:Favorito/ui/checkins/checkins.dart';
import 'package:Favorito/ui/claim/ClaimProvider.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/order/Orders.dart';
import 'package:Favorito/ui/review/ReviewList.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/setting/BusinessProfile/businessProfile.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myString.Dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SizeManager sm;
  SharedPreferences preferences;
  var ratingCount;
  bool isFirst = true;
  String messageTitle = "";
  String messageMessage = "";
  String notificationAlert = "alert";
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((value) {
      print("this is new Token2:${value}");
    });

    _firebaseMessaging.configure(onMessage: (message) async {
      setState(() {
        messageTitle = message["notification"]["title"];
        messageMessage = message["notification"]["message"];
        print("messageTitle:$messageTitle");
        notificationAlert = "New Notification Alert";
      });
    }, onResume: (message) async {
      setState(() {
        messageTitle = message["data"]["title"];
        messageTitle = message["data"]["message"];
        print("messageTitle1:$messageTitle");
        notificationAlert = "Application opened from Notification";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    if (isFirst) {
      Provider.of<SettingProvider>(context, listen: false).getProfileImage();
      calldashBoard(context);
      isFirst = false;
    }
    return WillPopScope(
      onWillPop: () {
        BaseProvider.onWillPop(context);
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              title: Padding(
                padding: EdgeInsets.only(top: sm.h(4)),
                child: Text("Dashboard",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).appBarTheme.textTheme.headline1),
              ),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(null, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop()),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => calldashBoard(context),
            backgroundColor: Colors.amber,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.h(2)),
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("ver : 2.4", style: TextStyle(fontSize: 8)),
                        Text("Status : ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(
                            is_verified == "0"
                                ? "Offline"
                                : is_verified == "1"
                                    ? "Live"
                                    : "Blocked",
                            style: TextStyle(
                                fontSize: 18,
                                color: is_verified == "0"
                                    ? Colors.grey
                                    : is_verified == "1"
                                        ? Colors.green
                                        : Colors.red,
                                fontFamily: 'Gilroy-Medium',
                                fontWeight: FontWeight.w500)),
                        // SizedBox(
                        //   width: 20,
                        // )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: is_profile_completed == '0' ? true : false,
                    child: rowWithTextNButton(
                        txt1: "Complete Your Profile",
                        txt2: "Fill",
                        check: is_profile_completed,
                        function: () {
                          Provider.of<BusinessProfileProvider>(context,
                                  listen: false)
                              .getProfileData(context);
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BusinessProfile(isFirst: true)))
                              .whenComplete(() => calldashBoard(context));
                        }),
                  ),
                  Visibility(
                    visible: is_information_completed == '0' ? true : false,
                    child: rowWithTextNButton(
                        txt1: "Complete Your Information",
                        txt2: "Now",
                        check: is_information_completed,
                        function: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => businessInfo()))
                              .whenComplete(() => calldashBoard(context));
                        }),
                  ),
                  Visibility(
                    visible: is_verified == "0" ? true : false,
                    child: rowWithTextNButton(
                        txt1: "Send For Verification",
                        txt2: "Verify",
                        check: is_verified,
                        function: () {
                          Provider.of<ClaimProvider>(context, listen: false)
                              .getClaimData(context);
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BusinessClaim(
                                            isFirst: true,
                                          )))
                              .whenComplete(() => calldashBoard(context));
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        card1(
                            checkins: check_ins,
                            function: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => checkins()))
                                  .whenComplete(() => calldashBoard(context));
                            }),
                        card2(
                            ratings:
                                double.parse(ratings ?? 0.0).toStringAsFixed(1),
                            function: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReviewList()))
                                  .whenComplete(() => calldashBoard(context));
                            },
                            va: ratingCount ?? '0')
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: sm.h(4)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Catalogs()))
                                      .whenComplete(
                                          () => calldashBoard(context));
                                },
                                child: card3(
                                    txt1: "Catalogoues", title: catalogoues)),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Orders()))
                                      .whenComplete(
                                          () => calldashBoard(context));
                                },
                                child: card3(txt1: "Orders", title: orders))
                          ])),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Grow your Business",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    )
                  ]),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sm.h(2), vertical: 6),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          credit("Free Credit", free_credit ?? 0,
                              "assets/icon/warning.svg", true),
                          credit("Paid Credit", paid_credit,
                              "assets/icon/warning.svg", false)
                        ]),
                  ),
                  rowCard(
                      "Advertise",
                      "Reach new audience searching for related services",
                      () => Navigator.of(context)
                          .pushNamed('/adSpent')
                          .whenComplete(() => calldashBoard(context))),
                  SizedBox(
                    height: 10,
                  ),
                  rowCard("Notifications", "Send Direct Update To Customer",
                      () {
                    Navigator.of(context).pushNamed('/notifications');
                  }),
                  SizedBox(
                    height: 20,
                  )
                ])),
          )),
    );
  }

  Widget rowCard(String title, String subtitle, Function function) => InkWell(
        onTap: function,
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
                title: Text(title ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Gilroy-Medium')),
                subtitle: Text(
                  subtitle ?? '',
                  style: TextStyle(fontSize: 14),
                )),
          ),
        ),
      );

  Widget credit(String title, String ammount, String ico, bool val) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 16),
      child: Row(children: [
        Text("${title ?? ''} : ",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontFamily: 'Gilroy-Medium')),
        Text("${ammount ?? ''}  ",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontFamily: 'Gilroy-Medium')),
        val
            ? InkWell(
                onTap: () {
                  showPopup(
                          callback: () {},
                          ctx: context,
                          sizesBottom: 44,
                          sizesLeft: 20,
                          sizesRight: 20,
                          sizesTop: 44,
                          sm: sm,
                          widget: Text('Lorem dolor isit'))
                      .show();
                },
                child: SvgPicture.asset(
                  ico,
                  alignment: Alignment.center,
                  height: sm.h(1.4),
                ),
              )
            : Container()
      ]),
    );
  }

  calldashBoard(BuildContext _context) async {
// DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
// print('Running on ${androidInfo.id}');  // e.g. "Moto G (4)"

    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String firebaseToken = await firebaseMessaging.getToken();

    print('Running on token $firebaseToken');

    preferences = await SharedPreferences.getInstance();
    final RequestModel requestModel = RequestModel();
    requestModel.context = _context;
    requestModel.url = serviceFunction.funDash;
    await WebService.serviceCall(requestModel).then((value) {
      var _v = DashModel.fromJson(convert.json.decode(value?.toString()));
      var va = _v?.data;
      preferences.setString('businessId', va?.businessId);
      business_name = va?.businessName;
      preferences.setString('nickname', va?.businessName);
      print("nameis ${va.businessName}");
      preferences.setString('photoUrl', va?.photo);
      preferences.setInt('type', va?.businessType);
      Prefs.setBusinessType(va?.businessType);
      // Provider.of<SettingProvider>(context, listen: false)
      //     .initCall(va?.businessType == 1);
      Prefs.setISAPPOINTMENT(va?.businessAttributes.contains('Appointment'));
      print("isAppointment:${va?.businessAttributes.contains('Appointment')}");
      business_status = va?.businessStatus;
      photoUrl = va?.photo;
      is_profile_completed = va?.isProfileCompleted?.toString() ?? '';
      is_information_completed = va?.isInformationCompleted?.toString() ?? '';
      preferences.setString('isPhoneVerified', '${va?.isPhoneVerified}');
      is_email_verified = va?.isEmailVerified?.toString() ?? '';
      is_verified = va?.isVerified.toString() ?? '';
      check_ins = va?.checkIns.toString() ?? '';
      ratings = va?.ratings.toString() ?? '';
      catalogoues = va?.catalogoues?.toString() ?? '';
      orders = va?.orders?.toString() ?? '';
      ratingCount = va?.ratingCount?.toString() ?? '';
      setState(() {
        paid_credit = va?.paidCredit?.toString() ?? '';
        free_credit = va?.freeCredit?.toString() ?? '';
      });
      Provider.of<BusinessProfileProvider>(_context, listen: false)
          .getProfileData(_context);

      Provider.of<SettingProvider>(_context, listen: false).wait =
          va.businessType == 1;
    });
    await WebService.setGetFirebaseId({'api_type': 'get'}).then((value) {
      preferences.setString("firebaseId", value.data[0].firebaseChatId ?? "");
    });
  }
}
