CLASS cl_d435e_v_flight_class DEFINITION
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



CLASS CL_D435E_V_FLIGHT_CLASS IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_items TYPE d435e_t_itravelitemtp.

    DATA lo_msg TYPE REF TO cm_devs4d435.

    io_read->retrieve(
      EXPORTING
        iv_node        = is_ctx-node_key
        it_key         = it_key
      IMPORTING
        et_data = lt_items ).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>) WHERE flightclass IS  NOT INITIAL.

      SELECT SINGLE FROM d435_i_flightclass
                     FIELDS @abap_true
                    WHERE flightclass = @<ls_item>-flightclass
                    INTO @DATA(lv_exists).

      IF lv_exists = abap_false.

        IF eo_message IS NOT BOUND.
          eo_message = /bobf/cl_frw_factory=>get_message(  ).
        ENDIF.

        CREATE OBJECT lo_msg
          EXPORTING
            textid      = cm_devs4d435=>class_invalid
            severity    = cm_devs4d435=>co_severity_error
            lifetime    = cm_devs4d435=>co_lifetime_state
            flightclass = <ls_item>-flightclass.

        eo_message->add_cm( lo_msg ).

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
