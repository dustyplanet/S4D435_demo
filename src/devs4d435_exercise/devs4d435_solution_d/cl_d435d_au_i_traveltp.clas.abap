CLASS cl_d435d_au_i_traveltp DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_auth_draft_active
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_lib_auth_draft_active~check_instance_authority
        REDEFINITION .
    METHODS /bobf/if_lib_auth_draft_active~check_static_authority
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_D435D_AU_I_TRAVELTP IMPLEMENTATION.


  METHOD /bobf/if_lib_auth_draft_active~check_instance_authority.

    DATA:
    lt_travels        TYPE d435d_t_itraveltp.    " Instance data typed with node's combined table type

  DATA:
      lv_activity TYPE activ_auth.


* Set activity for authority check
**********************************************************************

    CASE is_ctx-activity.
      WHEN /bobf/cl_frw_authority_check=>sc_activity-create   " '01'
        OR /bobf/cl_frw_authority_check=>sc_activity-change   " '02'
        OR /bobf/cl_frw_authority_check=>sc_activity-display. " '03' .

        lv_activity = is_ctx-activity.

      WHEN /bobf/cl_frw_authority_check=>sc_activity-execute. " '16'
        "special case Execute
        CASE is_ctx-action_name.
          WHEN 'SET_TO_CANCELLED'.
            lv_activity = /bobf/cl_frw_authority_check=>sc_activity-change.
          WHEN OTHERS.
            lv_activity = /bobf/cl_frw_authority_check=>sc_activity-display.
        ENDCASE.
    ENDCASE.

    IF lv_activity IS NOT INITIAL.

* retrieve the data of the requested node instances
************************************************************************

      io_read->retrieve(
           EXPORTING
               iv_node         = is_ctx-node_key
               it_key          = it_key
           IMPORTING
               et_data         = lt_travels
               et_failed_key   = et_failed_key
       ).

      LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>)
                         WHERE travelagency IS NOT INITIAL.

* Perform authorization check
**********************************************************************

*           AUTHORITY-CHECK OBJECT 'S_AGENCY'
*             ID 'AGENCYNUM' FIELD lv_agency
*             ID 'ACTVT'     FIELD lv_activity.
*
*          IF sy-subrc <> 0.

        "Use simulation for different roles for different users
        cl_s4d435_model=>authority_check(
        EXPORTING
          iv_agencynum = <ls_travel>-travelagency
          iv_actvt     = lv_activity
          RECEIVING
            rv_rc        = DATA(lv_subrc)
          ).

        IF lv_subrc <> 0.

          et_failed_key = VALUE #( BASE et_failed_key ( key = <ls_travel>-key ) ).

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD /bobf/if_lib_auth_draft_active~check_static_authority.
  ENDMETHOD.
ENDCLASS.
