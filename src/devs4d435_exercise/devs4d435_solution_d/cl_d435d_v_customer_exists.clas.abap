class CL_D435D_V_CUSTOMER_EXISTS definition
  public
  inheriting from /BOBF/CL_LIB_V_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_VALIDATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS CL_D435D_V_CUSTOMER_EXISTS IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_travel TYPE d435d_t_itraveltp.

    DATA lv_exists TYPE abap_bool.

    "for message
    DATA lo_msg TYPE REF TO cm_devs4d435.
    DATA ls_location TYPE /bobf/s_frw_location.

    " for appending et_failed_key

    DATA ls_key LIKE LINE OF et_failed_key.

* Read required Data
**********************************************************************

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
*     iv_before_image         = abap_false
*     iv_fill_data            = abap_true
*     it_requested_attributes =
      IMPORTING
        eo_message              = eo_message
        et_data                 = lt_travel
    ).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lv_exists = abap_false.

      IF <ls_travel>-customer IS NOT INITIAL.

        SELECT SINGLE @abap_true
                FROM d435_i_customer
                INTO @lv_exists
               WHERE customer = @<ls_travel>-customer.

        IF lv_exists <> abap_true.

          IF eo_message IS NOT BOUND.
            eo_message = /bobf/cl_frw_factory=>get_message( ).
          ENDIF.

* issue error message
**********************************************************************

          ls_location-bo_key   = is_ctx-bo_key.
          ls_location-node_key = is_ctx-node_key.
          ls_location-key      = <ls_travel>-key.
          APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-customer
              TO ls_location-attributes.

          CREATE OBJECT lo_msg
            EXPORTING
              textid             = cm_devs4d435=>customer_not_exist
              severity           = cm_devs4d435=>co_severity_error
              customer           = <ls_travel>-customer
              lifetime           = cm_devs4d435=>co_lifetime_state
              ms_origin_location = ls_location.

          eo_message->add_cm( lo_msg ).

          " expression-based alternative
*
*          eo_message->add_cm( NEW cm_devs4d435(
*                textid             = cm_devs4d435=>customer_not_exist
*                severity           = cm_devs4d435=>co_severity_error
*                customer           = <ls_travel>-customer
*                lifetime           = cm_devs4d435=>co_lifetime_state
*                ms_origin_location = value #(  bo_key     = is_ctx-bo_key
*                                               node_key   = is_ctx-node_key
*                                               key        = <ls_travel>-key
*                                               attributes = value #( ( `CUSTOMER` ) )
*                                             )
*                                               )
*                             ).

* add key to failed keys
**********************************************************************

          ls_key-key = <ls_travel>-key.
          INSERT ls_key INTO TABLE et_failed_key.

          " expression-based alternative
*          INSERT VALUE #(  key = <ls_travel>-key ) INTO TABLE et_failed_key.

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
