CLASS cl_d435e_au_i_traveltp DEFINITION
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



CLASS CL_D435E_AU_I_TRAVELTP IMPLEMENTATION.


  METHOD /bobf/if_lib_auth_draft_active~check_instance_authority.

    DATA:
    lt_travels        TYPE d435e_t_itraveltp.    " Instance data typed with node's combined table type

    DATA:
       lv_activity TYPE activ_auth.

    DATA:
      lt_items TYPE d435e_t_itravelitemtp.

    DATA:
      lv_agency   TYPE s_agency.

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

      LOOP AT it_key ASSIGNING FIELD-SYMBOL(<ls_key>).

* retrieve the data of the requested node instance
************************************************************************

        CASE is_ctx-node_key.
          WHEN if_d435e_i_traveltp_c=>sc_node-d435e_i_traveltp.
            io_read->retrieve(
                EXPORTING
                    iv_node         = is_ctx-node_key
                    it_key          = VALUE #( (  <ls_key> ) )
                IMPORTING
                    et_data         = lt_travels
                    et_failed_key   = et_failed_key
            ).

            lv_agency = lt_travels[  1 ]-travelagency.

          WHEN if_d435e_i_traveltp_c=>sc_node-d435e_i_travelitemtp.

            io_read->retrieve(
                EXPORTING
                    iv_node         = is_ctx-node_key
                    it_key          = VALUE #( (  <ls_key> ) )
                IMPORTING
                    et_data         = lt_items
                    et_failed_key   = et_failed_key
            ).

            lv_agency = lt_items[  1 ]-travelagency.

        ENDCASE.

* Perform authorization check
**********************************************************************

        "Use simulation for different roles for different users
        cl_s4d435_model=>authority_check(
        EXPORTING
          iv_agencynum = lv_agency
          iv_actvt     = lv_activity
          RECEIVING
            rv_rc        = DATA(lv_subrc)
          ).

        IF lv_subrc <> 0.

          INSERT <ls_key> INTO TABLE et_failed_key.

        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD /bobf/if_lib_auth_draft_active~check_static_authority.
  ENDMETHOD.
ENDCLASS.
