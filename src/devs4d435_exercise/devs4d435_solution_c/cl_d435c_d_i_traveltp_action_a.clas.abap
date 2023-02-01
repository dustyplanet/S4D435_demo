CLASS cl_d435c_d_i_traveltp_action_a DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_D435C_D_I_TRAVELTP_ACTION_A IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA lt_travels TYPE d435c_t_itraveltp.

* retrieve the data of the requested node instance
************************************************************************
    io_read->retrieve(
         EXPORTING
             iv_node         = is_ctx-node_key
             it_key          = it_key
         IMPORTING
             et_data         = lt_travels
     ).

* Create a Property Helper object
**********************************************************************

*    DATA lo_property_helper TYPE REF TO /bobf/cl_lib_h_set_property.
*    CREATE OBJECT lo_property_helper
*      EXPORTING
*        is_context = is_ctx
*        io_modify  = io_modify.

    DATA(lo_property_helper) = NEW /bobf/cl_lib_h_set_property(
                                      is_context = is_ctx
                                      io_modify  = io_modify ).


* Loop at all Travels and set properties dependent on Dates
**********************************************************************

*    FIELD-SYMBOLS <ls_travel> TYPE d435c_s_itraveltp.
*    LOOP AT lt_travels ASSIGNING <ls_travel>
*                           WHERE startdate IS NOT INITIAL
*                             AND enddate   IS NOT INITIAL.
    .

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>)
                          WHERE startdate IS NOT INITIAL
                            AND enddate   IS NOT INITIAL.

      IF <ls_travel>-status = 'C'
      OR <ls_travel>-enddate < sy-datum .

        "Action SET_TO_CANCELLED
        lo_property_helper->set_action_enabled(
             iv_action_key = if_D435c_i_traveltp_c=>sc_action-D435c_i_traveltp-set_to_cancelled
             iv_key        = <ls_travel>-key
             iv_value      = abap_false
         ).

        " Enable/Disable Editing of Data set
        lo_property_helper->set_node_update_enabled(
            iv_key   = <ls_travel>-key
            iv_value = abap_false
        ).

      ENDIF.

* Optional part: Field Control
**********************************************************************
      IF <ls_travel>-startdate < sy-datum.  "travel already started - no editing of customer

        " Field Customer
        lo_property_helper->set_attribute_read_only(
              iv_attribute_name = if_D435c_i_traveltp_c=>sc_node_attribute-D435c_i_traveltp-customer
              iv_key            = <ls_travel>-key
              iv_value          = abap_true
             ).

        " Field StartDate
        lo_property_helper->set_attribute_read_only(
            iv_attribute_name = if_D435c_i_traveltp_c=>sc_node_attribute-D435c_i_traveltp-startdate
            iv_key            = <ls_travel>-key
            iv_value          = abap_true
             ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
