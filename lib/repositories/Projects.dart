
import 'package:supabase_flutter/supabase_flutter.dart';

class Projects
{
  // Read Operation to return existing projects
  static Future<List<String>> readProject() async {
    var projects = await Supabase.instance.client.from('Projects').select('title');

    List<String> titles = [];
    for (var project in projects){
      titles.add(project['title'] as String);
    }

    return titles;
  }
}