CLASS lhc_rating DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS DetermineUser FOR DETERMINE ON SAVE
      IMPORTING keys FOR Rating~DetermineUser.

ENDCLASS.


CLASS lhc_rating IMPLEMENTATION.
  METHOD DetermineUser.
    DATA ratings TYPE TABLE FOR UPDATE zr_16_ratingtp.

    LOOP AT keys INTO DATA(key).
      APPEND VALUE #( %tky       = key-%tky
                      username   = sy-uname
                      ratingdate = sy-datum ) TO ratings.
    ENDLOOP.

    MODIFY ENTITIES OF zr_16_movietp IN LOCAL MODE
           ENTITY Rating
           UPDATE
           FIELDS ( username ratingdate )
           WITH ratings.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_Movie DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Movie RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Movie RESULT result.
    METHODS ValidateGenre FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movie~ValidateGenre.
    METHODS RateMovie FOR MODIFY
      IMPORTING keys FOR ACTION Movie~RateMovie. " RESULT result.

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

  METHOD RateMovie.
    DATA ratings TYPE TABLE FOR CREATE ZR_16_MovieTP\_Ratings.

    DATA(valid_keys) = keys.

    " Process Movie Keys
    LOOP AT keys INTO DATA(key).

      " Validate Rating
      IF key-%param-Rating >= 1 AND key-%param-Rating <= 10.
        CONTINUE.
      ENDIF.

      " Create Error Message
      DATA(message) = NEW zcm_abap_movie( textid   = zcm_abap_movie=>invalid_rating
                                          rating   = key-%param-Rating
                                          severity = if_abap_behv_message=>severity-error ).
      APPEND VALUE #( %tky              = key-%tky
                      %msg              = message
                      %action-RateMovie = if_abap_behv=>mk-on ) TO reported-movie.

      APPEND VALUE #( %tky = key-%tky ) TO failed-movie.

      DELETE valid_keys WHERE %tky = key-%tky.

    ENDLOOP.

    " Check Movie-Keys
    IF valid_keys IS INITIAL.
      RETURN.
    ENDIF.

    " Create Ratings
    LOOP AT valid_keys INTO key.
      APPEND VALUE #( %tky    = key-%tky
                      %target = VALUE #( ( Rating = key-%param-Rating ) ) ) TO ratings.
    ENDLOOP.

    MODIFY ENTITIES OF zr_16_movietp IN LOCAL MODE
           ENTITY Movie
           CREATE BY \_Ratings
           AUTO FILL CID
           FIELDS ( Rating )
           WITH ratings.
  ENDMETHOD.
ENDCLASS.
