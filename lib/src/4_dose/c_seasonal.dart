part of 'a_dose.dart';

bool givenOutsideSeason(
        SeasonalRecommendation recommendation, VaxDate dateGiven) =>
    recommendation == null
        ? false
        : VaxDate.max().fromNullableString(recommendation.endDate) <=
                dateGiven ||
            dateGiven <
                VaxDate.min().fromNullableString(recommendation.startDate);
