import 'dart:io' as io;

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'package:hospitallers_feedback_forms/auth_client_id.dart';
import 'package:hospitallers_feedback_forms/course.dart';


Future<void> main() async {
	final courseStrings = io.File('courses.txt').readAsLinesSync()..removeWhere((s) => s.isEmpty);
	final courses = courseStrings.map(Course.fromFileFormat);

	print("Ідентифіковано ${courseStrings.length} курсів\n");

	final client = await clientViaUserConsent(
		clientId,
		[DriveApi.driveScope],
		(url) => print("Автентифікація за посиланням:\n$url\n")
	);
	final files = DriveApi(client).files;
	final forms = FormsApi(client).forms;
}
