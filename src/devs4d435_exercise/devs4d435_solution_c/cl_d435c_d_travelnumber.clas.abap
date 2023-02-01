CLASS cl_d435c_d_travelnumber DEFINITION
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



CLASS CL_D435C_D_TRAVELNUMBER IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA lt_travel TYPE d435c_t_itraveltp.
    DATA lr_travel TYPE REF TO d435c_s_itraveltp.
    DATA lt_changed_fields TYPE /bobf/t_frw_name.


    APPEND if_d435c_i_traveltp_c=>sc_node_attribute-d435c_i_traveltp-travelnumber
        TO lt_changed_fields.

* Retrieve existing data (for travelagency)

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
      IMPORTING
*    eo_message              =
        et_data                 = lt_travel
*    et_failed_key           =
*    et_node_cat             =
    ).


    LOOP AT lt_travel REFERENCE INTO lr_travel.


      IF lr_travel->travelnumber IS INITIAL.

* Setup changed data
        lr_travel->travelnumber =
              cl_s4d435_model=>get_next_travelid_for_agency( lr_travel->travelagency ).

        io_modify->update(
          EXPORTING
            iv_node           = is_ctx-node_key
            iv_key            = lr_travel->key
*            iv_root_key       =
            is_data           = lr_travel
            it_changed_fields = lt_changed_fields
        ).

      ENDIF.
    ENDLOOP.

* Expression-based alternative
**********************************************************************
*    DATA lt_data TYPE d435c_t_itraveltp.
*
*    io_read->retrieve(
*      EXPORTING
*        iv_node                 = is_ctx-node_key
*        it_key                  = it_key
*   IMPORTING
**    eo_message              =
*        et_data                 = lt_data
**    et_failed_key           =
**    et_node_cat             =
*    ).
*
*    LOOP AT lt_data REFERENCE INTO DATA(lr_data).
*
*      IF lr_data->travelnumber IS INITIAL.
*        lr_data->travelnumber = cl_s4d435_model=>get_next_travelid_for_agency(
*                                 iv_agencynum = lr_data->travelagency
*                               ).
*
*        io_modify->update(
*          EXPORTING
*            iv_node           = is_ctx-node_key
*            iv_key            = lr_data->key
**            iv_root_key       =
*            is_data           = lr_data
*            it_changed_fields = VALUE #( ( if_d435c_i_traveltp_c=>sc_node_attribute-d435c_i_traveltp-travelnumber ) )
*
*         ).
*
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
