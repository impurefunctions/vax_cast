import 'dart:convert';

import 'package:fhir/fhir_r4.dart' as fhir_r4;
import 'package:fhir/r4/resource_types/foundation/other/other.enums.dart';
import 'package:fhir/r4/resource_types/resource_types.enums.dart';
import 'package:vax_cast/src/shared.dart';

var rec = fhir_r4.ImmunizationRecommendation(
  resourceType: 'ImmunizationRecommendation',
  date: fhir_r4.FhirDateTime('2020-05-01'),
  patient: fhir_r4.Reference(id: 'testBaby'),
  recommendation: [
    fhir_r4.ImmunizationRecommendationRecommendation(
      series: 'DTAP',
      dateCriterion: [
        fhir_r4.ImmunizationRecommendationDateCriterion(
          code: fhir_r4.CodeableConcept(text: 'Earliest_Date'),
          value: fhir_r4.FhirDateTime('2999-12-31'),
        ),
        fhir_r4.ImmunizationRecommendationDateCriterion(
          code: fhir_r4.CodeableConcept(text: 'Recommended_Date'),
          value: fhir_r4.FhirDateTime('2999-12-31'),
        ),
        fhir_r4.ImmunizationRecommendationDateCriterion(
          code: fhir_r4.CodeableConcept(text: 'Past_Due_Date'),
          value: fhir_r4.FhirDateTime('2999-12-31'),
        ),
      ],
      forecastStatus: fhir_r4.CodeableConcept(text: 'Complete'),
    ),
  ],
);
var pat = fhir_r4.Patient(
  resourceType: 'Patient',
  id: fhir_r4.Id('testBaby'),
  name: [fhir_r4.HumanName(family: 'testBaby')],
  gender: Gender.female,
  birthDate: fhir_r4.Date('2020-01-01'),
);

var hepB1 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-01-01'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'HepB unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('45'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var hepB2 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'HepB unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('45'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var dtap1 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'DTaP unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('107'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var hib1 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'Hib unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('17'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var rv1 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'Rotavirus unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('122'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var pcv1 = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'Pneumoccocal unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('109'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var polio = fhir_r4.Immunization(
  resourceType: 'Immunization',
  occurrenceDateTime: fhir_r4.FhirDateTime('2020-03-10'),
  status: fhir_r4.Code('completed'),
  vaccineCode: fhir_r4.CodeableConcept(
    text: 'Polio unspecified formulation',
    coding: [
      fhir_r4.Coding(
        code: fhir_r4.Code('89'),
        system: fhir_r4.FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: fhir_r4.Reference(id: 'testBaby'),
);

var testBundle = fhir_r4.Bundle(
  resourceType: 'Bundle',
  entry: [
    fhir_r4.BundleEntry(
        resource: pat,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Patient'),
        )),
    fhir_r4.BundleEntry(
        resource: hepB1,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: hepB2,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: dtap1,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: hib1,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: rv1,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: pcv1,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
    fhir_r4.BundleEntry(
        resource: polio,
        request: fhir_r4.BundleRequest(
          method: RequestMethod.put,
          url: fhir_r4.FhirUri('Immunization'),
        )),
  ],
);

void main() async {
  await VaxCast().cast(
    FHIR_V.r4,
    false,
    pat,
    [
      hepB1,
      hepB2,
      dtap1,
      hib1,
      rv1,
      polio,
      pcv1,
    ],
    [rec],
    <fhir_r4.Condition>[],
    null,
  );
  // forecast.forEach((group) {
  //   print(
  //       '${group.seriesVaccineGroup}:${group.targetDisease}:${group.groupEarliestDate}');
  // });
}

var immBundle = fhir_r4.Bundle.fromJson(jsonDecode("""{
 "query-time": 7,
 "meta": {
  "versionId": "56102"
 },
 "type": "searchset",
 "resourceType": "Bundle",
 "total": 7,
 "link": [
  {
   "relation": "first",
   "url": "/Immunization?patient=testBaby&page=1"
  },
  {
   "relation": "self",
   "url": "/Immunization?patient=testBaby&page=1"
  }
 ],
 "query-timeout": 60000,
 "entry": [
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "c03586e0-0551-4185-86bf-7b14800c0809",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.731712Z",
     "createdAt": "2020-05-05T21:37:57.731712Z",
     "versionId": "56096"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/c03586e0-0551-4185-86bf-7b14800c0809",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/c03586e0-0551-4185-86bf-7b14800c0809"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "fe977792-845e-4084-b660-700034be79ff",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.743326Z",
     "createdAt": "2020-05-05T21:37:57.743326Z",
     "versionId": "56097"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/fe977792-845e-4084-b660-700034be79ff",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/fe977792-845e-4084-b660-700034be79ff"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "4efbc6c3-449f-42bb-8343-6d712f208193",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.747491Z",
     "createdAt": "2020-05-05T21:37:57.747491Z",
     "versionId": "56098"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/4efbc6c3-449f-42bb-8343-6d712f208193",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/4efbc6c3-449f-42bb-8343-6d712f208193"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "c60889e6-d2c8-453b-aa9c-b05abfcad3a0",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.751688Z",
     "createdAt": "2020-05-05T21:37:57.751688Z",
     "versionId": "56099"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/c60889e6-d2c8-453b-aa9c-b05abfcad3a0",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/c60889e6-d2c8-453b-aa9c-b05abfcad3a0"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "4a202830-12b6-42cd-bfc5-729bd9257224",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.755579Z",
     "createdAt": "2020-05-05T21:37:57.755579Z",
     "versionId": "56100"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/4a202830-12b6-42cd-bfc5-729bd9257224",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/4a202830-12b6-42cd-bfc5-729bd9257224"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "837af30a-23b9-4daf-ac5b-37e657bacc91",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.759899Z",
     "createdAt": "2020-05-05T21:37:57.759899Z",
     "versionId": "56101"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/837af30a-23b9-4daf-ac5b-37e657bacc91",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/837af30a-23b9-4daf-ac5b-37e657bacc91"
    }
   ]
  },
  {
   "resource": {
    "status": "completed",
    "patient": {
     "id": "testBaby",
     "_id": "testBaby",
     "resourceType": "Patient"
    },
    "vaccineCode": {
     "text": "HepB unspecified formulation",
     "coding": [
      {
       "code": "45",
       "system": "http://hl7.org/fhir/sid/cvx"
      }
     ]
    },
    "id": "fdc4f519-63fd-498e-b389-26dd3f550497",
    "resourceType": "Immunization",
    "meta": {
     "lastUpdated": "2020-05-05T21:37:57.765105Z",
     "createdAt": "2020-05-05T21:37:57.765105Z",
     "versionId": "56102"
    }
   },
   "fullUrl": "https://r4immunizationtesting.aidbox.app/Immunization/fdc4f519-63fd-498e-b389-26dd3f550497",
   "link": [
    {
     "relation": "self",
     "url": "https://r4immunizationtesting.aidbox.app/Immunization/fdc4f519-63fd-498e-b389-26dd3f550497"
    }
   ]
  }
 ],
 "query-sql": [
  "SELECT \"immunization\".* FROM \"immunization\" WHERE (\"immunization\".resource @> ?) LIMIT ? OFFSET ? ",
  "{\"patient\":{\"id\":\"testBaby\"}}",
  100,
  0
 ]
}"""));
