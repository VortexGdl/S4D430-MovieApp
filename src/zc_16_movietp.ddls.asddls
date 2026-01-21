@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Movie Consumption View'

@Metadata.allowExtensions: true

@Search.searchable: true

define view entity ZC_16_MovieTP
  as select from ZR_16_MovieTP

{
  key MovieUuid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Title,

      Genre,
      PublishingYear,
      RuntimeInMin,
      @Semantics.imageUrl
      ImageUrl as Picture,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy
}
