@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rating'
@Metadata.allowExtensions: true
define view entity ZC_16_RatingTP
  as projection on ZR_16_RatingTP
{
  key RatingUuid,
      MovieUuid,
      UserName,
      Rating,
      RatingDate,

      /* Associations */
      _Movie : redirected to parent ZC_16_MovieTP
}
