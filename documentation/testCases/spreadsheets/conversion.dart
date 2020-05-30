import 'dart:convert';
import 'dart:io';

// void Conversion() async {
//   //where is the directory for the XML documents
//   final dir = Directory('./Version 4.3 - 508/XML/');

//   //get a list of the directory
//   final files = await dir.list().toList();

//   //for transformation XML to json
//   var myTransformer = Xml2Json();
//   String file;
//   var schema = '{"vaccines": [';
//   String contents;

//   for (final entry in files) {

//     //as long as it's an XML file
//     if (entry.toString().contains('.xml')) {

//       //read it
//       file = await (entry as File).readAsString();

//       //parse it
//       myTransformer.parse(file);

//       //format the name
//       file = entry.toString().replaceFirst(".xml'", '.json');
//       file =
//           file.split(file.contains('-508') ? 'SupportingData- ' : '/XML/')[1];

//       //get the contents
//       contents = myTransformer.toParker();

//       //put them in their own file
//       await File('./json/' + file.replaceAll('-508', '')).writeAsString(contents);

//       //add them to the ful document
//       schema += contents + ',';
//     }
//   }

//   //write all of them to one document
//   await File('./json/dartFhirSchema.json')
//       .writeAsString(schema.substring(0, schema.length - 1) + ']}');
// }

void writeSchema() async {
  //directory of classes
  final dir = Directory('./json/');

  //get a list of the directory
  final files = await dir.list().toList();

  //run through each of the files in the directory
  for (final file in files) {
    if (file.toString().contains('./json/dartFhirSchema.json')) {
      var vax = json.decode(await (file as File).readAsString());
      for (final vaccine in vax['vaccines']) {
        if (vaccine['antigenSupportingData'] != null) {
          await File('./json/' +
                  vaccine['antigenSupportingData']['series'][0]
                      ['targetDisease'] +
                  '.json')
              .writeAsString(json.encode(vaccine).toString());
        }
      }
    }
  }
}
