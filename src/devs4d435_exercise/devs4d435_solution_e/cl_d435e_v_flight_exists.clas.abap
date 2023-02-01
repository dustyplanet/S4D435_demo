CLASS cl_d435e_v_flight_exists DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_v_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_validation~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_D435E_V_FLIGHT_EXISTS IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_items TYPE d435e_t_itravelitemtp.

    DATA lo_msg TYPE ref to cm_devs4d435.

    io_read->retrieve(
      EXPORTING
        iv_node        = is_ctx-node_key
        it_key         = it_key
      IMPORTING
        et_data = lt_items ).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>)
           WHERE airlineid IS NOT INITIAL
             AND connectionnumber IS NOT INITIAL
             AND flightdate IS NOT INITIAL.

      SELECT SINGLE FROM sflight
             FIELDS  @abap_true
              WHERE carrid = @<ls_item>-airlineid
                AND connid = @<ls_item>-connectionnumber
                AND fldate = @<ls_item>-flightdate
              INTO @DATA(lv_exists).

      IF lv_exists = abap_false.

        CREATE OBJECT lo_msg
          EXPORTING
            textid           = cm_devs4d435=>flight_not_exist
            severity         = cm_devs4d435=>co_severity_error
            lifetime         = cm_devs4d435=>co_lifetime_state
            airlineid        = <ls_item>-airlineid
            connectionnumber = <ls_item>-connectionnumber
            flightdate       = <ls_item>-flightdate.

        IF eo_message IS NOT BOUND.
          eo_message = /bobf/cl_frw_factory=>get_message( ).
        ENDIF.

        eo_message->add_cm( lo_msg ).

        APPEND VALUE #(  key = <ls_item>-key ) TO et_failed_key.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
