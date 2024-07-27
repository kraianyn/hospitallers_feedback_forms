import 'dart:io';
import 'package:hospitallers_feedback_forms/course.dart';


Future<void> main() async {
	final courseStrings = File('courses.txt').readAsLinesSync()..removeWhere((s) => s.isEmpty);
	final courses = courseStrings.map(Course.fromFileFormat);
}
