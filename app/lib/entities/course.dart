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
			throw "Invalid format: \"$line\"";
		}
	}

	@override
	String toString() => "${type.shortName} ($metadata): ${instructors.join(', ')}";
}

enum CourseType {
	basicLifeSupport(
		name: "Базова підтримка життя",
		shortName: "BLS",
		isMilitary: false
	),
	basicTraumaCare(
		name: "Перша допомога при травмі",
		shortName: "Травма",
		isMilitary: false
	),
	simulations(
		name: "Симуляційний курс",
		shortName: "Симуляції",
		isMilitary: false
	),
	spinalInjuryCare(
		name: "Перша допомога при травмі хребта",
		shortName: "Травма хребта",
		isMilitary: false
	),
	tcccAsm1(
		name: "TCCC ASM (1 день)",
		shortName: "ASM 1",
		isMilitary: true
	),
	tcccAsm3(
		name: "TCCC ASM (3 дні)",
		shortName: "ASM 3",
		isMilitary: true
	);

	const CourseType({
		required this.name,
		required this.shortName,
		required this.isMilitary
	});

	factory CourseType.fromString(String string) => CourseType.values.firstWhere(
		(t) => t.shortName.toLowerCase() == string.toLowerCase()
	);

	final String name;
	final String shortName;
	final bool isMilitary;
}
