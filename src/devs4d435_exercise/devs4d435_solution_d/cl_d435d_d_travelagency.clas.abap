class CL_D435D_D_TRAVELAGENCY definition
  public
  inheriting from /BOBF/CL_LIB_D_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_DETERMINATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS CL_D435D_D_TRAVELAGENCY IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA ls_travel TYPE d435d_s_itraveltp.
    DATA lr_travel TYPE REF TO data.

    DATA lt_changed_fields TYPE /bobf/t_frw_name.

    DATA ls_key LIKE LINE OF it_key.

* Setup changed data

    GET REFERENCE OF ls_travel INTO lr_travel.

    ls_travel-travelagency =  cl_s4d435_model=>get_agency_by_user( iv_user = sy-uname ).

    APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-travelagency
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
**          iv_root_key       =
*          is_data           =  NEW d435d_s_itraveltp(  travelagency = cl_s4d435_model=>get_agency_by_user( iv_user = sy-uname ) )
*          it_changed_fields = VALUE #( ( if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-travelagency ) )
*      ).
*
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
