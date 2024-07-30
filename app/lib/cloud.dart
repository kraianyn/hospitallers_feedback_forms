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

Future<String> createFolder(FilesResource filesResource) async {
	print("Як назвати теку?");
	final name = stdin.readLineSync(encoding: utf8);
	print('');

	final folder = await filesResource.create(
		File(
			name: name,
			mimeType: 'application/vnd.google-apps.folder',
			parents: [formsParentFolderId]
		),
		$fields: 'id'
	);
	return folder.id!;
}

Future<List<CourseForm>> createForms(
	List<Course> courses,
	String folderId,
	FilesResource filesResource,
	FormsResource formsResource
) async {
	final courseForms = courses.map((course) => CourseForm(
		course: course,
		folderId: folderId,
		filesResource: filesResource,
		formsResource: formsResource
	)).toList();
	await Future.wait(courseForms.map((f) => f.create()));
	return courseForms;
}
