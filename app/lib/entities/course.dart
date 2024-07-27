import 'package:hospitallers_feedback_forms/private.dart';

import 'instructor.dart';

class Course {
	const Course({
		required this.type,
		required this.metadata,
		required this.instructors
	});

	final CourseType type;
	final String metadata;
	final List<Instructor> instructors;

	factory Course.fromFileFormat(String line) {
		final (type, metadata, instructors) = _parseFileLine(line);
		return Course(type: type, metadata: metadata, instructors: instructors);
	}

	static (CourseType, String, List<Instructor>) _parseFileLine(String line) {
		try {
			final [typeString, metadata, instructorsString] = line.split('|').map((s) => s.trim()).toList();
			final type = CourseType.fromString(typeString.trim());
			final instructors = instructorsString.split(',').map(
				(s) => Instructor.fromString(s.trim())
			).toList();

			return (type, metadata, instructors);
		}
		on StateError {
			throw "Хибний формат: \"$line\"";
		}
	}

	@override
	String toString() => "${type.shortName} ($metadata): ${instructors.join(', ')}";
}

enum CourseType {
	basicLifeSupport(
		name: "Базова підтримка життя",
		shortName: "BLS",
		isMilitary: false,
		templateFileId: basicLifeSupportTemplateFileId
	),
	basicTraumaCare(
		name: "Перша допомога при травмі",
		shortName: "Травма",
		isMilitary: false,
		templateFileId: basicTraumaCareTemplateFileId
	),
	simulations(
		name: "Симуляційний курс",
		shortName: "Симуляції",
		isMilitary: false,
		templateFileId: simulationsTemplateFileId
	),
	spinalInjuryCare(
		name: "Перша допомога при травмі хребта",
		shortName: "Травма хребта",
		isMilitary: false,
		templateFileId: spinalInjuryCareTemplateFileId
	),
	tcccAsm1(
		name: "TCCC ASM (1 день)",
		shortName: "ASM 1",
		isMilitary: true,
		templateFileId: tcccAsm1TemplateFileId
	),
	tcccAsm3(
		name: "TCCC ASM (3 дні)",
		shortName: "ASM 3",
		isMilitary: true,
		templateFileId: tcccAsm3TemplateFileId
	);

	const CourseType({
		required this.name,
		required this.shortName,
		required this.isMilitary,
		required this.templateFileId
	});

	factory CourseType.fromString(String string) => CourseType.values.firstWhere(
		(t) => t.shortName.toLowerCase() == string.toLowerCase()
	);

	final String name;
	final String shortName;
	final bool isMilitary;
	final String templateFileId;
}
