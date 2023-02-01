class CM_DEVS4D435 definition
  public
  inheriting from /BOBF/CM_FRW
  final
  create public .

public section.

  constants:
    begin of CANCEL_SUCCESS,
      msgid type symsgid value 'DEVS4D435',
      msgno type symsgno value '120',
      attr1 type scx_attrname value 'TRAVELNUMBER',
      attr2 type scx_attrname value 'STARTDATE_TXT',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of CANCEL_SUCCESS .
  constants:
    begin of ALREADY_CANCELLED,
      msgid type symsgid value 'DEVS4D435',
      msgno type symsgno value '130',
      attr1 type scx_attrname value 'TRAVELNUMBER',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ALREADY_CANCELLED .
  constants:
    BEGIN OF customer_not_exist,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '200',
        attr1 TYPE scx_attrname VALUE 'CUSTOMER',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_not_exist .
  constants:
    BEGIN OF dates_wrong_sequence,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '210',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF dates_wrong_sequence .
  constants:
    BEGIN OF end_date_past,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '220',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_past .
  constants:
    BEGIN OF start_date_past,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '230',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_past .
  constants:
    BEGIN OF class_invalid,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '300',
        attr1 TYPE scx_attrname VALUE 'FLIGHTCLASS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF class_invalid .
  constants:
    BEGIN OF flight_date_past,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '310',
        attr1 TYPE scx_attrname VALUE ' ',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_date_past .
  constants:
    BEGIN OF flight_not_exist,
        msgid TYPE symsgid VALUE 'DEVS4D435',
        msgno TYPE symsgno VALUE '320',
        attr1 TYPE scx_attrname VALUE 'AIRLINEID',
        attr2 TYPE scx_attrname VALUE 'CONNECTIONNUMBER',
        attr3 TYPE scx_attrname VALUE 'FLIGHTDATE_TXT',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_not_exist .
  data TRAVELNUMBER type S_TRAVELID read-only .
  data STARTDATE_TXT type CHAR10 read-only .
  data CUSTOMER type S_CUSTOMER read-only .
  data FLIGHTCLASS type S_CLASS read-only .
  data AIRLINEID type S_CARR_ID read-only .
  data CONNECTIONNUMBER type S_CONN_ID read-only .
  data FLIGHTDATE_TXT type CHAR10 read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !SEVERITY type TY_MESSAGE_SEVERITY optional
      !SYMPTOM type TY_MESSAGE_SYMPTOM optional
      !LIFETIME type TY_MESSAGE_LIFETIME default CO_LIFETIME_TRANSITION
      !MS_ORIGIN_LOCATION type /BOBF/S_FRW_LOCATION optional
      !MT_ENVIRONMENT_LOCATION type /BOBF/T_FRW_LOCATION optional
      !MV_ACT_KEY type /BOBF/ACT_KEY optional
      !MV_ASSOC_KEY type /BOBF/OBM_ASSOC_KEY optional
      !MV_BOPF_LOCATION type /BOBF/CONF_KEY optional
      !MV_DET_KEY type /BOBF/DET_KEY optional
      !MV_QUERY_KEY type /BOBF/OBM_QUERY_KEY optional
      !MV_VAL_KEY type /BOBF/VAL_KEY optional
      !TRAVELNUMBER type S_TRAVELID optional
      !STARTDATE type S_STDAT optional
      !CUSTOMER type S_CUSTOMER optional
      !FLIGHTCLASS type S_CLASS optional
      !AIRLINEID type S_CARR_ID optional
      !CONNECTIONNUMBER type S_CONN_ID optional
      !FLIGHTDATE type S_DATE optional .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS CM_DEVS4D435 IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous                = previous
        severity                = severity
        symptom                 = symptom
        lifetime                = lifetime
        ms_origin_location      = ms_origin_location
        mt_environment_location = mt_environment_location
        mv_act_key              = mv_act_key
        mv_assoc_key            = mv_assoc_key
        mv_bopf_location        = mv_bopf_location
        mv_det_key              = mv_det_key
        mv_query_key            = mv_query_key
        mv_val_key              = mv_val_key.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->travelnumber = travelnumber.
*    WRITE startdate TO me->startdate_txt.
    me->startdate_txt = |{ startdate DATE = USER }|.

    me->customer =  customer.

    me->flightclass = flightclass.

    me->airlineid = airlineid.
    me->connectionnumber = connectionnumber.
    me->flightdate_txt = |{ flightdate date = user }|.

  ENDMETHOD.
ENDCLASS.
