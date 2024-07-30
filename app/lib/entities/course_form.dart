import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/forms/v1.dart';

import 'course.dart';
import 'grammatical_case.dart';
import 'instructor.dart';


class CourseForm {
	CourseForm({
		required this.course,
		required this.folderId,
		required this.files,
		required this.forms
	});

	final Course course;
	final String folderId;
	late final String link;
	final FilesResource files;
	final FormsResource forms;

	Future<void> create() async {
		final formFile = await _copyTemplate();
		final form = await _addInstructors(formFile.id!);
		link = form.responderUri!;
		print("Форму створено: $course");
	}

	Future<File> _copyTemplate() {
		final fileName = "${course.type.shortName} (${course.metadata})";
		return files.copy(
			File(name: fileName, parents: [folderId]),
			course.type.templateFileId,
			$fields: 'id'
		);
	}

	Future<Form> _addInstructors(String formId) async {
		const previousQuestionCount = 2, instructorQuestionCount = 2;
		final response = await forms.batchUpdate(
			BatchUpdateFormRequest(
				includeFormInResponse: true,
				requests: [
					for (final (index, instructor) in course.instructors.indexed)
						..._instructorQuestionRequests(
							instructor,
							previousQuestionCount + instructorQuestionCount * index
						)
				]
			),
			formId
		);
		return response.form!;
	}

	List<Request> _instructorQuestionRequests(Instructor instructor, int locationIndex) {
		final instructorInGenitive = _instructorString(instructor, GrammaticalCase.genitive);
		final instructorInAccusative = _instructorString(instructor, GrammaticalCase.accusative);

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
		GrammaticalCase grammaticalCase
	) {
		final codeName = instructor.codeName[grammaticalCase];
		final firstName = instructor.firstName[grammaticalCase];
		return course.type.isMilitary ? codeName : "$firstName ($codeName)";
	}
}
