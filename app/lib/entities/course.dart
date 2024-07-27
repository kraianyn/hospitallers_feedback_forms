import 'instructor.dart';

class Course {
	const Course({
		required this.name,
		required this.metadata,
		required this.instructors
	});

	final String name;
	final String metadata;
	final List<Instructor> instructors;

	factory Course.fromFileFormat(String line) {
		final (name, metadata, instructors) = _parseFileLine(line);
		return Course(name: name, metadata: metadata, instructors: instructors);
	}

	static (String, String, List<Instructor>) _parseFileLine(String line) {
		try {
			final [name, metadata, instructorsString] = line.split('|').map((s) => s.trim()).toList();
			final instructors = instructorsString.split(',').map(
				(s) => Instructor.fromString(s.trim())
			).toList();

			return (name, metadata, instructors);
		}
		on StateError {
			throw "Invalid format: \"$line\"";
		}
	}

	@override
	String toString() => "$name ($metadata): ${instructors.join(', ')}";
}
