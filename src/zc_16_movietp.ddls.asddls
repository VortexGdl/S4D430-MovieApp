@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Movie Consumption View'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_16_MovieTP
  as projection on ZR_16_MovieTP

{
  key MovieUuid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Title,

      Genre,
      PublishingYear,
      RuntimeInMin,
      @Semantics.imageUrl
      ImageUrl,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy,
      
      //Association
      _Ratings : redirected to composition child ZC_16_RatingTP
}
