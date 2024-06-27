import 'dart:convert';
import 'package:http/http.dart';
import '../models/member.dart';

class ApiService{
  final String apiUrl = "http://gdnexam.somee.com/api/members";

  Future<List<member>> getMembers() async{
    Response res = await get(Uri.parse(apiUrl));

    if(res.statusCode == 200){
        List<dynamic> body = jsonDecode(res.body);
        List<member> members = body.map((dynamic item) => member.fromJson(item)).toList();
        print(members);
        return members;
    }else{
      throw "Failed to load members";
    }

  }

  Future<member> createMember(member _member)async{
    Map data = {
      'm_id':_member.m_id,
      'm_name':_member.m_name,
      'm_batch':_member.m_batch
    };

    final Response response = await post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return member.fromJson(json.decode(response.body));
    }else{
      throw Exception("Failed to create member");
    }
  }

  Future<void> deleteMember(int id)async{
    //final Response response = await delete(Uri.parse('$apiUrl/$id'));
    Uri uriDelete = Uri.parse('$apiUrl/$id');
    Response res = await delete(uriDelete);

     if (res.statusCode == 200) {
     print('Deleted successfully');
    }else{
      throw "Failed to delete member";
    }

  }

   Future<member> updateMember(member _member, int id)async{
    Map data = {
      'm_id':_member.m_id,
      'm_name':_member.m_name,
      'm_batch':_member.m_batch
    };

    final Response response = await put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return member.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to update member");
    }
  }


}