CLASS cl_d435e_v_flight_date_future DEFINITION
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



CLASS CL_D435E_V_FLIGHT_DATE_FUTURE IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_items TYPE d435e_t_itravelitemtp.

    DATA lo_msg TYPE REF TO cm_devs4d435.

    DATA lv_attribute TYPE string.

    io_read->retrieve(
      EXPORTING
        iv_node        = is_ctx-node_key
        it_key         = it_key
      IMPORTING
        et_data = lt_items ).



    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>)
              WHERE flightdate IS NOT INITIAL.

      IF <ls_item>-flightdate < sy-datum.

        CREATE OBJECT lo_msg
          EXPORTING
            textid   = cm_devs4d435=>flight_date_past
            severity = cm_devs4d435=>co_severity_error
            lifetime = cm_devs4d435=>co_lifetime_state.

        IF eo_message IS NOT BOUND.
          eo_message = /bobf/cl_frw_factory=>get_message( ).
        ENDIF.

        eo_message->add_cm(  lo_msg ).
        APPEND VALUE #(  key = <ls_item>-key ) TO et_failed_key.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
