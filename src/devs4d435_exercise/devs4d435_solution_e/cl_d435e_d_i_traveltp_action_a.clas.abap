CLASS cl_d435e_d_i_traveltp_action_a DEFINITION
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



CLASS CL_D435E_D_I_TRAVELTP_ACTION_A IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA lt_travels        TYPE d435e_t_itraveltp.

    DATA lt_travels_active TYPE d435e_t_itraveltp.

    FIELD-SYMBOLS <ls_for_check> TYPE d435e_s_itraveltp.

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


* Loop at all not new travels and set properties dependent on Dates
**********************************************************************

*    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>)
*                           WHERE startdate IS NOT INITIAL
*                             AND enddate   IS NOT INITIAL.

    " Only loop at active and edit draft

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>)
                            WHERE isactiveentity  = abap_true
                               OR hasactiveentity = abap_true.

      IF <ls_travel>-isactiveentity = abap_false.

        " draft instance: use active instance for check
        io_read->retrieve(
          EXPORTING
            iv_node  = is_ctx-node_key
            it_key   = VALUE #(  ( key = <ls_travel>-activeuuid ) )
          IMPORTING
            et_data  = lt_travels_active
        ).

*        READ TABLE lt_travels_active ASSIGNING <ls_for_check> INDEX 1.
        ASSIGN lt_travels_active[ 1 ] TO <ls_for_check>.
      ELSE.
        ASSIGN <ls_travel> TO <ls_for_check>.
      ENDIF.


      IF <ls_for_check>-status = 'C'
      OR <ls_for_check>-enddate < sy-datum .

        "Action SET_TO_CANCELLED
        lo_property_helper->set_action_enabled(
             iv_action_key = if_d435e_i_traveltp_c=>sc_action-d435e_i_traveltp-set_to_cancelled
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
      IF <ls_for_check>-startdate < sy-datum.  "travel already started - no editing of customer

        " Field Customer
        lo_property_helper->set_attribute_read_only(
              iv_attribute_name = if_d435e_i_traveltp_c=>sc_node_attribute-d435e_i_traveltp-customer
              iv_key            = <ls_travel>-key
              iv_value          = abap_true
             ).

        " Field StartDate
        lo_property_helper->set_attribute_read_only(
            iv_attribute_name = if_d435e_i_traveltp_c=>sc_node_attribute-d435e_i_traveltp-startdate
            iv_key            = <ls_travel>-key
            iv_value          = abap_true
             ).

      ENDIF.

* For Draft Scenario:
**********************************************************************
      " Disable Delete for Active Entities

      IF <ls_travel>-isactiveentity = abap_true.
        lo_property_helper->set_node_delete_enabled(
          iv_key   = <ls_travel>-key
          iv_value = abap_false
          ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
