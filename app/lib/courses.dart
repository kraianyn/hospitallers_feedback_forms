import 'dart:io';
import 'entities/course.dart';


List<Course> readCourses() {
	final courseStrings = File('courses.txt').readAsLinesSync()..removeWhere((s) => s.isEmpty);
	return courseStrings.map(Course.fromFileFormat).toList();
}
