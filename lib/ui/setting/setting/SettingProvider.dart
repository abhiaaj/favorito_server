import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/PageViews/PageViews.dart';
import 'package:Favorito/ui/catalog/Catalogs.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/contactPerson/ContactPerson.dart';
import 'package:Favorito/ui/highlights/highlights.dart';
import 'package:Favorito/ui/jobs/JobList.dart';
import 'package:Favorito/ui/offer/Offers.dart';
import 'package:Favorito/ui/setting/BusinessProfile/businessProfile.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfo.dart';
import 'package:Favorito/ui/waitlist/Waitlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends BaseProvider {
  // BuildContext _context;
  SharedPreferences preferences;
  String name;
  SettingProvider() {
    getProfileImage();

  }
  getBusinessName(){
    name = preferences.getString('nickname');
    print("nameis $name");

    notifyListeners();
  }
  String photo = '';
  String shortdescription = '';
  bool wait = true;
  List<String> title = [
    "Bussiness Profile",
    "Bussiness Information",
    "Claim Bussiness",
    "Owner Profile",
    "Create Offer",
    "Jobs",
    "Waitlist",
    "Catalogs",
    "Create Highlights",
    "Page View"
  ];
  List<String> icon = [
    "shop",
    "circlenotyfy",
    "claim",
    "owner",
    "offer",
    "jobs",
    "waiting",
    "catlog",
    "highlights",
    "eye"
  ];
  List<Widget> pages = [
    BusinessProfile(isFirst: true),
    businessInfo(),
    BusinessClaim(isFirst: true),
    ContactPerson(),
    Offers(),
    JobList(),
    Waitlist(),
    Catalogs(),
    highlights(),
    PageViews(),
  ];
  bool settingHeight = true;
  bool settingTool = true;

  changeSettingHeight() {
    settingHeight = !settingHeight;
    notifyListeners();
  }

  changeSettingTool() {
    settingTool = !settingTool;
    notifyListeners();
  }

  getProfileImage() async {
    preferences= await SharedPreferences.getInstance();
    await WebService.funUserPhoto().then((value) {
      if (value.status == 'success') {
        this.photo = value.result[0].photo ?? '';
        this.shortdescription = value.result[0].shortDescription ?? '';
      }
      notifyListeners();
    });
  }
}
