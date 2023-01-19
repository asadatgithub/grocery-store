import 'package:alpha_mini_grocery/constants/constants.dart';
import 'package:alpha_mini_grocery/models/items.dart';
import 'package:alpha_mini_grocery/models/members.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'db.dart';

class MemberDatabase {
  static Future<Map<String, dynamic>?> insertMember(Member member) async {
    return await Database.db
        ?.collection(MEMBER_COLLECTION)
        .insert(member.toMap());
  }

  static Future<Stream<Map<String, dynamic>>?> getMember(String email) async {
    var result =
        await Database.db?.collection(MEMBER_COLLECTION).find({"email": email});
    return result;
  }

  static Future<dynamic> getMembers() async {
    //("here");
    var result = await Database.db
        ?.collection(MEMBER_COLLECTION)
        .find({"exists": "yes"}).toList();
    // //(result + " >>>>>>>>>>>>");
    //("not here");
    return result;
  }

  static Future<dynamic> findMember(String email) async {
    var res = await Database.db
        ?.collection(MEMBER_COLLECTION)
        .findOne({"email": email});
    //(res);
    return res;
  }

  static Future<dynamic> findMemberHavingPassword(
      String email, String password) async {
    var res = await Database.db
        ?.collection(MEMBER_COLLECTION)
        .findOne({"email": email, "password": password});
    //(res);
    return res;
  }
}
