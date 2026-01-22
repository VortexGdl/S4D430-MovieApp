@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Textelement for Genre'
define view entity ZI_16_GenreText
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZABAP_GENRE' )
{

  key domain_name,
  key value_position,
  key language,
      value_low as Genre,
      text      as GenreText
}
where
  language = $session.system_language
