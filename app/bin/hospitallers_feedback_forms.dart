import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'package:hospitallers_feedback_forms/cloud.dart';
import 'package:hospitallers_feedback_forms/courses.dart';


Future<void> main() async {
	final courses = readCourses();
	print("Ідентифіковано ${courses.length} курсів\n");

	final client = await authClient();
	final files = DriveApi(client).files;
	final forms = FormsApi(client).forms;

	final folderId = await createFolder(files);
	print("Теку створено, форми створюються\n");

	await createForms(courses, folderId, files, forms);
	client.close();
	print("\nФорми створено");
}
