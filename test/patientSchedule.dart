import 'dart:convert';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:vax_cast/src/forecast.dart';

var rec = ImmunizationRecommendation(
  date: FhirDateTime('2020-05-01'),
  patient: Reference(id: 'testBaby'),
  recommendation: [
    ImmunizationRecommendationRecommendation(
      series: 'DTAP',
      dateCriterion: [
        ImmunizationRecommendationDateCriterion(
          code: CodeableConcept(text: 'Earliest_Date'),
          value: FhirDateTime('2999-12-31'),
        ),
        ImmunizationRecommendationDateCriterion(
          code: CodeableConcept(text: 'Recommended_Date'),
          value: FhirDateTime('2999-12-31'),
        ),
        ImmunizationRecommendationDateCriterion(
          code: CodeableConcept(text: 'Past_Due_Date'),
          value: FhirDateTime('2999-12-31'),
        ),
      ],
      forecastStatus: CodeableConcept(text: 'Complete'),
    ),
  ],
);
var pat = Patient(
  id: Id('testBaby'),
  name: [HumanName(family: 'testBaby')],
  gender: PatientGender('female'),
  birthDate: Date('2020-01-01'),
);

var hepB1 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-01-01'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'HepB unspecified formulation',
    coding: [
      Coding(
        code: Code('45'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var hepB2 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'HepB unspecified formulation',
    coding: [
      Coding(
        code: Code('45'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var dtap1 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'DTaP unspecified formulation',
    coding: [
      Coding(
        code: Code('107'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var hib1 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'Hib unspecified formulation',
    coding: [
      Coding(
        code: Code('17'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var rv1 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'Rotavirus unspecified formulation',
    coding: [
      Coding(
        code: Code('122'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var pcv1 = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'Pneumoccocal unspecified formulation',
    coding: [
      Coding(
        code: Code('109'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var polio = Immunization(
  occurrenceDateTime: FhirDateTime('2020-03-10'),
  status: Code('completed'),
  vaccineCode: CodeableConcept(
    text: 'Polio unspecified formulation',
    coding: [
      Coding(
        code: Code('89'),
        system: FhirUri("http://hl7.org/fhir/sid/cvx"),
      )
    ],
  ),
  patient: Reference(id: 'testBaby'),
);

var testBundle = Bundle(
  entry: [
    BundleEntry(
        resource: pat,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Patient'),
        )),
    BundleEntry(
        resource: hepB1,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: hepB2,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: dtap1,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: hib1,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: rv1,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: pcv1,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
    BundleEntry(
        resource: polio,
        request: BundleRequest(
          method: BundleRequestMethod('PUT'),
          url: FhirUri('Immunization'),
        )),
  ],
);

void main() async {
  var forecast = await Forecast().r4Forecast(pat, [
    hepB1,
    hepB2,
    dtap1,
    hib1,
    rv1,
    polio,
    pcv1,
  ], [
    rec
  ], <Condition>[]);
  forecast.forEach((group) {
    print(
        '${group.seriesVaccineGroup}:${group.targetDisease}:${group.groupEarliestDate}');
  });
}

var immBundle = Bundle.fromJson(jsonDecode("""{
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
