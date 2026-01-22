@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Genre Werte Hilfe'

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_16_GenreVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                   p_domain_name : 'ZABAP_GENRE')

{
      @EndUserText.label: 'Genre'
      @EndUserText.quickInfo: 'Genre'
  key value_low as Genre,

      @EndUserText.label: 'Genre Text'
      @EndUserText.quickInfo: 'Genre Text'
      text      as GenreText
}

where language = $session.system_language
