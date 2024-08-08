import 'dart:io';

import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'package:hospitallers_feedback_forms/cloud.dart';
import 'package:hospitallers_feedback_forms/local.dart';


Future<void> main() async {
	final courses = readCourses();
	print("Ідентифіковано ${courses.length} курсів\n");

	final client = await authClient();
	final filesResource = DriveApi(client).files;
	final formsResource = FormsApi(client).forms;

	final folderId = await createFolder(filesResource);
	print("Теку створено, форми створюються\n");

	final forms = await createForms(courses, folderId, filesResource, formsResource);
	client.close();

	await writeFormLinks(forms);
	print("\nПосилання на форми записано до файлу");
	stdin.readByteSync();
}
