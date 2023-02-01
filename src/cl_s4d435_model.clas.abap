class CL_S4D435_MODEL definition
  public
  final
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_AGENCY_BY_USER
    importing
      !IV_USER type SYUNAME default SY-UNAME
    returning
      value(RV_AGENCYNUM) type S_AGENCY .
  class-methods GET_NEXT_TRAVELID_FOR_AGENCY
    importing
      !IV_AGENCYNUM type S_AGENCY
    returning
      value(RV_TRAVELID) type S_TRAVELID .
  class-methods AUTHORITY_CHECK
    importing
      !IV_AGENCYNUM type S_AGENCY
      !IV_ACTVT type ACTIV_AUTH
    returning
      value(RV_RC) type SYSUBRC .
  PRIVATE SECTION.

    CONSTANTS first_travelid TYPE s_travelid VALUE '12000'.
ENDCLASS.



CLASS CL_S4D435_MODEL IMPLEMENTATION.


  METHOD authority_check.

* This method simulates an authority check

    IF iv_actvt = '02' OR iv_actvt = '01'.

* use mockup
      rv_rc = 4.
      SELECT SINGLE
        FROM ds4d435_users
    FIELDS 0
      WHERE uname   = @sy-uname
      And agencynum = @iv_agencynum
    INTO @rv_rc.

    ELSE.

* use real authority check
      AUTHORITY-CHECK OBJECT 'S_AGENCY'
      ID 'AGENCYNUM' FIELD iv_agencynum
      ID 'ACTVT' FIELD iv_actvt.

      rv_rc = sy-subrc.
    ENDIF.

  ENDMETHOD.


  METHOD class_constructor.

    DATA lt_mapping TYPE TABLE OF ds4d435_users .

    SELECT SINGLE
       FROM ds4d435_users
     FIELDS @abap_true
     INTO @DATA(lv_exists).

    IF lv_exists <> abap_true.

      SELECT FROM stravelag
        FIELDS mandt,
              'TRAIN-##' AS user,
               agencynum,
               @first_travelid  AS last_travelid
        WHERE agencynum >= 100
        ORDER BY agencynum
        INTO TABLE @lt_mapping
        UP TO 41 rows.

      LOOP AT lt_mapping ASSIGNING FIELD-SYMBOL(<ls_mapping>).
        REPLACE '##' IN <ls_mapping>-uname WITH CONV numc2( sy-tabix - 1 ).
      ENDLOOP.


      MODIFY ds4d435_users FROM TABLE lt_mapping.

    ENDIF.

  ENDMETHOD.


  METHOD get_agency_by_user.

* this method simulates a User/Travelagency assignment

    DATA ls_mapping TYPE ds4d435_users.

    SELECT SINGLE FROM ds4d435_users
    FIELDS *
    WHERE uname = @iv_user
      INTO @ls_mapping.

    IF sy-subrc <> 0.
      " User not like TRAIN-##: Use travel agency 055
      ls_mapping = VALUE #( uname = sy-uname agencynum = '055' last_travelid = first_travelid ).
      MODIFY ds4d435_users FROM ls_mapping.
    ENDIF.

    rv_agencynum = ls_mapping-agencynum.

  ENDMETHOD.


  METHOD get_next_travelid_for_agency.

* This method simulates a Number Range Object

    DATA ls_mapping TYPE ds4d435_users.

    SELECT SINGLE
      FROM ds4d435_users
    FIELDS *
    WHERE agencynum = @iv_agencynum
    INTO @ls_mapping.

    IF sy-subrc <> 0.
       ls_mapping = value #( agencynum = iv_agencynum last_travelid = first_travelid ).
    ENDIF.

    ls_mapping-last_travelid = ls_mapping-last_travelid + 1.

    MODIFY ds4d435_users FROM ls_mapping.

    rv_travelid = ls_mapping-last_travelid.

  ENDMETHOD.
ENDCLASS.
