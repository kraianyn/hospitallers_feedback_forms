import 'dart:convert';
import 'dart:io';

import 'package:googleapis/drive/v3.dart';

import 'private.dart';


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
