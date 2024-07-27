import 'grammatical_case.dart';


enum Instructor {
	bas(
		codeName: InstructorName.bas,
		firstName: InstructorName.vsevolod,
		isMale: true
	),
	dok(
		codeName: InstructorName.dok,
		firstName: InstructorName.dmytro,
		isMale: true
	),
	dolia(
		codeName: InstructorName.dolia,
		firstName: InstructorName.alisa,
		isMale: false
	),
	domino(
		codeName: InstructorName.domino,
		firstName: InstructorName.ihor,
		isMale: true
	),
	ktulhu(
		codeName: InstructorName.ktulhu,
		firstName: InstructorName.oleksandr,
		isMale: true
	),
	petarda(
		codeName: InstructorName.petarda,
		firstName: InstructorName.iryna,
		isMale: false
	),
	tiuvyk(
		codeName: InstructorName.tiuvyk,
		firstName: InstructorName.mariia,
		isMale: false
	),
	vilna(
		codeName: InstructorName.vilna,
		firstName: InstructorName.kateryna,
		isMale: false
	),
	vovkulaka(
		codeName: InstructorName.vovkulaka,
		firstName: InstructorName.viktor,
		isMale: true
	);

	const Instructor({
		required this.codeName,
		required this.firstName,
		required this.isMale
	});

	factory Instructor.fromString(String string) => Instructor.values.firstWhere(
		(i) => i.codeName.inNominative.toLowerCase() == string.toLowerCase()
	);

	final InstructorName codeName;
	final InstructorName firstName;
	final bool isMale;

	@override
	String toString() => codeName.inNominative;
}

enum InstructorName {
	bas("Бас", "Баса", "Баса"),
	dok("Док", "Дока", "Дока"),
	dolia("Доля", "Долю", "Долі"),
	domino.uninflected("Доміно"),
	ktulhu.uninflected("Ктулху"),
	petarda("Петарда", "Петарду", "Петарди"),
	tiuvyk("Тювик", "Тювика", "Тювика"),
	vilna("Вільна", "Вільну", "Вільної"),
	vovkulaka("Вовкулака", "Вовкулаку", "Вовкулаки"),

	alisa("Аліса", "Алісу", "Аліси"),
	dmytro("Дмитро", "Дмитра", "Дмитра"),
	ihor("Ігор", "Ігоря", "Ігоря"),
	iryna("Ірина", "Ірину", "Ірини"),
	kateryna("Катерина", "Катерину", "Катерини"),
	mariia("Марія", "Марію", "Марії"),
	oleksandr("Олександр", "Олександра", "Олександра"),
	viktor("Віктор", "Віктора", "Віктора"),
	vsevolod("Всеволод", "Всеволода", "Всеволода");

	const InstructorName(this.inNominative, this.inAccusative, this.inGenitive);

	const InstructorName.uninflected(String name) : this(name, name, name);

	final String inNominative;
	final String inAccusative;
	final String inGenitive;

	String operator [](GrammaticalCase grammaticalCase) => switch (grammaticalCase) {
		GrammaticalCase.nominative => inNominative,
		GrammaticalCase.accusative => inAccusative,
		GrammaticalCase.genitive => inGenitive,
	};
}
