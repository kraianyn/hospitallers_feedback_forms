import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'private.dart';
import 'entities/course.dart';


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

// do: define a class `CreatedForm` to avoid repassing arguments
Future<void> createForms(
	Iterable<Course> courses,
	FilesResource files,
	FormsResource forms,
	String folderId
) async {
	await Future.wait([
		for (final course in courses)
			_createForm(course, folderId, files, forms)
	]);
}

Future<void> _createForm(
	Course course,
	String folderId,
	FilesResource files,
	FormsResource forms
) async {
	final form = await _copyFormTemplate(course, folderId, files);
	await _addInstructorsToForm(form.id!, course, forms);
	print("Форму створено: $course");
}

Future<File> _copyFormTemplate(Course course, String folderId, FilesResource files) {
	final fileName = "${course.type.shortName} (${course.metadata})";
	return files.copy(
		File(name: fileName, parents: [folderId]),
		course.type.templateFileId,
		$fields: 'id'
	);
}

Future<void> _addInstructorsToForm(
	String formId,
	Course course,
	FormsResource forms
) async {
	int locationIndex = 2;
	await forms.batchUpdate(
		BatchUpdateFormRequest(requests: [
			for (final instructor in course.instructors)
				...[
					Request(createItem: CreateItemRequest(
						item: Item(
							title: "Що ви можете сказати про викладання ${instructor.codeName.inGenitive}?",
							questionItem: QuestionItem(question: Question(
								textQuestion: TextQuestion(paragraph: false),
								required: true
							))
						),
						location: Location(index: locationIndex++)
					)),
					Request(createItem: CreateItemRequest(
						item: Item(
							title: "Як ви оціните ${instructor.codeName.inAccusative}?",
							questionItem: QuestionItem(question: Question(
								scaleQuestion: ScaleQuestion(low: 1, high: 5),
								required: true
							))
						),
						location: Location(index: locationIndex++)
					))
				]
		]),
		formId
	);
}
