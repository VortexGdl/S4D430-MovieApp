@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Restricted Rating'

define view entity ZR_16_RatingTP
  as select from ZI_16_Rating

  association to parent ZR_16_MovieTP as _Movie on $projection.MovieUuid = _Movie.MovieUuid

{
  key RatingUuid,

      MovieUuid,
      UserName,
      Rating,
      RatingDate,

      // Association
      _Movie
}
