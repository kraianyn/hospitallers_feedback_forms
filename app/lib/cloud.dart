import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'private.dart';
import 'entities/course.dart';
import 'entities/instructor.dart';
import 'entities/grammatical_case.dart';


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

// do: define a `CreatedForm` class to avoid repassing arguments
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
	const previousQuestionCount = 2, instructorQuestionCount = 2;
	await forms.batchUpdate(
		BatchUpdateFormRequest(requests: [
			for (final (index, instructor) in course.instructors.indexed)
				..._instructorQuestionRequests(
					instructor,
					course.type.isMilitary,
					previousQuestionCount + instructorQuestionCount * index
				)
		]),
		formId
	);
}

List<Request> _instructorQuestionRequests(Instructor instructor, bool useCodeName, int locationIndex) {
	final instructorInGenitive = _instructorString(instructor, useCodeName, GrammaticalCase.genitive);
	final instructorInAccusative = _instructorString(instructor, useCodeName, GrammaticalCase.accusative);

	return [
		_createQuestionRequest(
			title: "Що ви можете сказати про викладання $instructorInGenitive?",
			question: Question(
				textQuestion: TextQuestion(paragraph: false),
				required: true
			),
			locationIndex: locationIndex++
		),
		_createQuestionRequest(
			title: "Як ви оціните $instructorInAccusative?",
			question: Question(
				scaleQuestion: ScaleQuestion(low: 1, high: 5),
				required: true
			),
			locationIndex: locationIndex++
		)
	];
}

Request _createQuestionRequest({
	required String title,
	required Question question,
	required int locationIndex
}) => Request(
	createItem: CreateItemRequest(
		item: Item(
			title: title,
			questionItem: QuestionItem(question: question)
		),
		location: Location(index: locationIndex)
	)
);

String _instructorString(
	Instructor instructor,
	bool useCodeName,
	GrammaticalCase grammaticalCase
) {
	final codeName = instructor.codeName[grammaticalCase];
	final firstName = instructor.firstName[grammaticalCase];
	return useCodeName ? codeName : "$firstName ($codeName)";
}
