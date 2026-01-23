CLASS lhc_Movie DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Movie RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Movie RESULT result.
    METHODS ValidateGenre FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movie~ValidateGenre.

ENDCLASS.


CLASS lhc_Movie IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ValidateGenre.
    " Wir benutzen Entity Manipulatipn Language
    DATA genres TYPE TABLE FOR READ RESULT ZR_16_MovieTP.

    " Read Travels
    READ ENTITIES OF ZR_16_MovieTP IN LOCAL MODE
         ENTITY Movie
         FIELDS ( Genre )
         WITH CORRESPONDING #( keys )
         RESULT genres.

    " process Travels
    LOOP AT genres INTO DATA(genre).

      " Validate Customer and Create Error Message
      SELECT SINGLE
        FROM ddcds_customer_domain_value_T( p_domain_name = 'ZABAP_GENRE' )
        FIELDS @abap_true
        WHERE value_low = @genre-Genre
        INTO @DATA(exists).

      IF exists = abap_false.
        APPEND VALUE #( %tky = genre-%tky ) TO failed-movie.
        DATA(message) = NEW zcm_abap_movie( textid   = zcm_abap_movie=>no_genre_found
                                            genre    = genre-Genre
                                            severity = if_abap_behv_message=>severity-error ).
        APPEND VALUE #( %tky           = genre-%tky
                        %msg           = message
                        %element-genre = if_abap_behv=>mk-on ) TO reported-movie.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
