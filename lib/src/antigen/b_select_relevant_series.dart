part of 'a_antigen.dart';

List<VaxSeries> relevantSeries(VaxPatient patient, VaxAg vaxAg) {
  List<VaxSeries> series = <VaxSeries>[];
  for (String ag in SupportingData.antigenSupportingData[agString(vaxAg)]]) {}
}

// bool isRelevant(Series series) => isAppropriateGender(series.requiredGender)
//     ? series.seriesType == 'Standard'
//         ? true
//         : doesIndicationApply(series.indication)
//     : false;

// bool isAppropriateGender(String requiredGender) =>
//     //if for some reason we don't know the patient's gender,
//     //we assume it's appropriate
//     requiredGender == null || patient.gender == null
//         ? true
//         : requiredGender.toLowerCase() == 'male'
//             ? patient.gender == VaxGender.male
//             : patient.gender != VaxGender.male;

// bool doesIndicationApply(Map<String, Indication> indications) {
//   if (patient.conditions.isNotEmpty) {
//     for (final condition in patient.conditions) {
//       if (indications.keys.contains(condition)) {
//         var indication = indications[condition];
//         if (patient.dob.minIfNull(indication.beginAge) <=
//                 patient.assessmentDate &&
//             patient.assessmentDate < patient.dob.maxIfNull(indication.endAge)) {
//           return true;
//         }
//       }
//     }
//   }
//   return false;
// }
