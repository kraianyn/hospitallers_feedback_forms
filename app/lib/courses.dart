import 'dart:io';
import 'entities/course.dart';
import 'entities/course_form.dart';


List<Course> readCourses() {
	final courseStrings = File('courses.txt').readAsLinesSync()..removeWhere((s) => s.isEmpty);
	return courseStrings.map(Course.fromFileFormat).toList();
}

Future<void> writeFormLinks(List<CourseForm> forms) async {
	final labeledLinks = forms.map((f) => "${f.course}\n${f.link}\n");
	await File('links.txt').writeAsString(labeledLinks.join('\n'));
}
