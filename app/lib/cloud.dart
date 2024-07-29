import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'private.dart';
import 'entities/course_form.dart';
import 'entities/course.dart';


Future<AutoRefreshingAuthClient> authClient() => clientViaUserConsent(
	authClientId,
	[DriveApi.driveScope],
	(url) => print("Автентифікація за посиланням:\n$url\n")
);

Future<String> createFolder(FilesResource files) async {
	print("Як назвати теку?");
	final name = stdin.readLineSync(encoding: utf8);
	print('');

	final folder = await files.create(
		File(
			name: name,
			mimeType: 'application/vnd.google-apps.folder',
			parents: [formsParentFolderId]
		),
		$fields: 'id'
	);
	return folder.id!;
}

Future<List<File>> createForms(
	List<Course> courses,
	String folderId,
	FilesResource files,
	FormsResource forms
) async {
	final courseFormFutures = courses.map((course) => CourseForm(
		course: course,
		folderId: folderId,
		files: files,
		forms: forms
	).create());
	return Future.wait(courseFormFutures);
}
