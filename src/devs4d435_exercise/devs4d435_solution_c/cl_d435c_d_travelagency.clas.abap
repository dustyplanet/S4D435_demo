CLASS cl_d435c_d_travelagency DEFINITION
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



CLASS CL_D435C_D_TRAVELAGENCY IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA ls_travel TYPE d435c_s_itraveltp.
    DATA lr_travel TYPE REF TO data.

    DATA lt_changed_fields TYPE /bobf/t_frw_name.

    DATA ls_key LIKE LINE OF it_key.

* Setup changed data

    GET REFERENCE OF ls_travel INTO lr_travel.

    ls_travel-travelagency =  cl_s4d435_model=>get_agency_by_user( iv_user = sy-uname ).

    APPEND if_d435c_i_traveltp_c=>sc_node_attribute-d435c_i_traveltp-travelagency
        TO lt_changed_fields.

    LOOP AT it_key INTO ls_key.


      io_modify->update(
        EXPORTING
          iv_node           = is_ctx-node_key
          iv_key            = ls_key-key
*      iv_root_key       =
          is_data           = lr_travel
          it_changed_fields = lt_changed_fields
      ).

    ENDLOOP.

* Expression-based alternative
**********************************************************************

*    LOOP AT it_key INTO DATA(ls_key).
*
*      io_modify->update(
*        EXPORTING
*          iv_node           = is_ctx-node_key
*          iv_key            = ls_key-key
**      iv_root_key       =
*          is_data           =  NEW d435c_s_itraveltp(  travelagency = cl_s4d435_model=>get_agency_by_user( iv_user = sy-uname ) )
*          it_changed_fields = VALUE #( ( if_d435c_i_traveltp_c=>sc_node_attribute-d435c_i_traveltp-travelagency ) )
*      ).
*
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
