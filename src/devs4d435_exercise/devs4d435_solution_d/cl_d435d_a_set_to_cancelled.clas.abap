CLASS cl_d435d_a_set_to_cancelled DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_a_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_action~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_D435D_A_SET_TO_CANCELLED IMPLEMENTATION.


  METHOD /bobf/if_frw_action~execute.

    DATA lo_msg TYPE REF TO cm_devs4d435.
    DATA ls_location TYPE /bobf/s_frw_location.

    DATA lt_travel TYPE d435d_t_itraveltp.

    DATA lr_travel TYPE REF TO d435d_s_itraveltp.
    FIELD-SYMBOLS <ls_travel> TYPE d435d_s_itraveltp.

* Read data of the selected node instance(s)
******************************************************************************
    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
*      IV_BEFORE_IMAGE         = ABAP_FALSE
      IMPORTING
        et_data                 = lt_travel
    ).

    IF eo_message IS NOT BOUND.
      eo_message = /bobf/cl_frw_message_factory=>create_container( ).
    ENDIF.


* Update the Status of the Travel if not yet cancelled
********************************************************************************

    LOOP AT lt_travel ASSIGNING <ls_travel>.


      ls_location-bo_key = is_ctx-bo_key.
      ls_location-node_key = is_ctx-node_key.
      ls_location-key = <ls_travel>-key.


      IF <ls_travel>-status = 'C'. " already cancelled

        " Issue error message
        CREATE OBJECT lo_msg
          EXPORTING
            textid             = cm_devs4d435=>already_cancelled
            severity           = cm_devs4d435=>co_severity_error
*           lifetime           =
            travelnumber       = <ls_travel>-travelnumber
            ms_origin_location = ls_location.

        eo_message->add_cm( io_message = lo_msg ).

      ELSE.

        <ls_travel>-status = 'C'.

        GET REFERENCE OF <ls_travel> INTO lr_travel.

        io_modify->update(
          EXPORTING
          iv_node               = is_ctx-node_key
          iv_key                = <ls_travel>-key
          is_data               = lr_travel
*          iv_root_key           =
*          it_changed_fields     =
          ).

        " Issue Success message

        CREATE OBJECT lo_msg
          EXPORTING
            textid             = cm_devs4d435=>cancel_success
            severity           = cm_devs4d435=>co_severity_success
*           lifetime           =
            travelnumber       = <ls_travel>-travelnumber
            startdate          = <ls_travel>-startdate
            ms_origin_location = ls_location.

        eo_message->add_cm( io_message = lo_msg ).
      ENDIF.

    ENDLOOP.


* Expression-based Alternatives (fewer helper variables )
********************************************************************************

*    DATA lt_data TYPE d435d_t_itraveltp.
*
*    io_read->retrieve(
*      EXPORTING
*        iv_node                 = is_ctx-node_key
*        it_key                  = it_key
**      IV_BEFORE_IMAGE         = ABAP_FALSE
**      IV_FILL_DATA            = ABAP_TRUE
**      IT_REQUESTED_ATTRIBUTES =
*      IMPORTING
*        eo_message              = eo_message
*        et_data                 =  lt_data
**      ET_FAILED_KEY           =
**      ET_NODE_CAT             =
*    ).
*
*    IF eo_message IS NOT BOUND.
*      eo_message = /bobf/cl_frw_message_factory=>create_container( ).
*    ENDIF.
*
*    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
*
*      IF <ls_data>-status = 'C'. " already cancelled
*
*        eo_message->add_cm(
*              io_message = NEW cm_devs4d435(
*                  textid             = cm_devs4d435=>already_cancelled
*                  severity           = cm_devs4d435=>co_severity_error
**                  lifetime           =
*                  travelnumber       = <ls_data>-travelnumber
*                  ms_origin_location = VALUE #( bo_key   = is_ctx-bo_key
*                                                node_key = is_ctx-node_key
*                                                key      = <ls_data>-key
*                                              )
*                                            )
*                          ).
*
*      ELSE.
*
*        <ls_data>-status = 'C'.
*
*        io_modify->update(
*         EXPORTING
*         iv_node               = is_ctx-node_key
*         iv_key                = <ls_data>-key
*         is_data               = REF #( <ls_data> )
**         iv_root_key           =
**         it_changed_fields     =
*         ).
*
*        eo_message->add_cm(
*            io_message = NEW cm_devs4d435(
*                textid             = cm_devs4d435=>cancel_success
*                severity           = cm_devs4d435=>co_severity_success
**                 lifetime           =
*                travelnumber       = <ls_data>-travelnumber
*                startdate          = <ls_data>-startdate
*                ms_origin_location = VALUE #( bo_key   = is_ctx-bo_key
*                                              node_key = is_ctx-node_key
*                                              key      = <ls_data>-key
*                                            )
*                                          )
*                          ).
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
