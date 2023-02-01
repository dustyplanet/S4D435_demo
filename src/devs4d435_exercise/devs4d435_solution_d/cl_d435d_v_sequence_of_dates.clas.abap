CLASS cl_d435d_v_sequence_of_dates DEFINITION
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



CLASS CL_D435D_V_SEQUENCE_OF_DATES IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_travel TYPE d435d_t_itraveltp.
    DATA lt_travel_before TYPE d435d_t_itraveltp.

    "for messages
    DATA lo_msg TYPE REF TO cm_devs4d435.
    DATA lt_msg TYPE  /bobf/cm_frw=>tt_frw.
    DATA ls_location TYPE /bobf/s_frw_location.

    CONSTANTS c_s_initial_travel TYPE d435d_s_itraveltp VALUE IS INITIAL.

* Read required Data
**********************************************************************

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
      IMPORTING
        eo_message              = eo_message
        et_data                 = lt_travel
    ).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>)
                      WHERE startdate IS NOT INITIAL
                        AND enddate IS NOT INITIAL.


* Derive previous image of active data set - for draft szenario
**********************************************************************

*      io_read->retrieve(
*        EXPORTING
*          iv_node                 = is_ctx-node_key
*          it_key                  = VALUE #(  (  key = <ls_travel>-key ) )
*          iv_before_image         = abap_true
*        IMPORTING
*          eo_message              = eo_message
*          et_data                 = lt_travel_before
*      ).
*
*      ASSIGN lt_travel_before[  1 ] TO FIELD-SYMBOL(<ls_travel_before>).
*      IF sy-subrc <> 0. "no previous data - new node instance
*        ASSIGN c_s_initial_travel TO <ls_travel_before>.
*      ENDIF.

      IF <ls_travel>-isactiveentity = abap_true.
        " active entity, compare with before image
        io_read->retrieve(
          EXPORTING
            iv_node                 = is_ctx-node_key
            it_key                  = VALUE #(  (  key = <ls_travel>-key ) )
            iv_before_image         = abap_true
          IMPORTING
            eo_message              = eo_message
            et_data                 = lt_travel_before
        ).

        ASSIGN lt_travel_before[ 1 ]  TO FIELD-SYMBOL(<ls_travel_before>).
        IF sy-subrc <> 0. "no previous data - new node instance
          ASSIGN c_s_initial_travel TO <ls_travel_before>.
        ENDIF.

      ELSEIF <ls_travel>-hasactiveentity = abap_true.
        " draft instance has active instance - compare with active instance
        io_read->retrieve(
          EXPORTING
            iv_node                 = is_ctx-node_key
            it_key                  = VALUE #( ( key = <ls_travel>-activeuuid ) )
          IMPORTING
            eo_message              = eo_message
            et_data                 = lt_travel_before
        ).

        ASSIGN lt_travel_before[  1 ]  TO <ls_travel_before>.
      ELSE.
        " New draft: compare with initial values
        ASSIGN c_s_initial_travel TO <ls_travel_before>.
      ENDIF.


* perform the checks
**********************************************************************

      "sequence of start date and end date
      IF <ls_travel>-enddate < <ls_travel>-startdate.

        CLEAR ls_location.
        ls_location-bo_key   = is_ctx-bo_key.
        ls_location-node_key = is_ctx-node_key.
        ls_location-key      = <ls_travel>-key.
        APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-startdate
            TO ls_location-attributes.
        APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-enddate
           TO ls_location-attributes.

        CREATE OBJECT lo_msg
          EXPORTING
            textid             = cm_devs4d435=>dates_wrong_sequence
            severity           = cm_devs4d435=>co_severity_error
            lifetime           = cm_devs4d435=>co_lifetime_state
            ms_origin_location = ls_location.

        APPEND lo_msg TO lt_msg.

*        APPEND NEW cm_d435d_travel(
*             textid   = cm_devs4d435=>dates_wrong_sequence
*             severity = cm_devs4d435=>co_severity_error
*             lifetime = cm_devs4d435=>co_lifetime_state
*             ms_origin_location =
*                VALUE #( bo_key     = is_ctx-bo_key
*                         node_key   = is_ctx-node_key
*                         Key        = <ls_travel>-key
*                         attributes = value #(
*                              ( if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-startdate    )
*                              ( if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-enddate ) )
*                        )
*               ) TO lt_msg.


      ENDIF.

      "end date
      IF <ls_travel>-enddate < sy-datum.

        CLEAR ls_location.
        ls_location-bo_key   = is_ctx-bo_key.
        ls_location-node_key = is_ctx-node_key.
        ls_location-key      = <ls_travel>-key.
        APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-enddate
        TO ls_location-attributes.

        CREATE OBJECT lo_msg
          EXPORTING
            textid             = cm_devs4d435=>dates_wrong_sequence
            severity           = cm_devs4d435=>co_severity_error
            lifetime           = cm_devs4d435=>co_lifetime_state
            ms_origin_location = ls_location.

        APPEND lo_msg TO lt_msg.

*        APPEND NEW cm_d435d_travel(
*          textid   = cm_devs4d435=>dates_wrong_sequence
*          severity = cm_devs4d435=>co_severity_error
*          lifetime = cm_devs4d435=>co_lifetime_state
*          ms_origin_location =
*               VALUE #( bo_key     = is_ctx-bo_key
*                        node_key   = is_ctx-node_key
*                        key        = <ls_travel>-key
*                        attributes = VALUE #(
*                                ( if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-enddate ) )
*                       )
*           ) TO lt_msg.


      ENDIF.

      "start date
      IF <ls_travel>-startdate = <ls_travel_before>-startdate.
        " ignore - not changed
      ELSEIF <ls_travel>-startdate < sy-datum.

        CLEAR ls_location.
        ls_location-bo_key   = is_ctx-bo_key.
        ls_location-node_key = is_ctx-node_key.
        ls_location-key      = <ls_travel>-key.
        APPEND if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-startdate
        TO ls_location-attributes.

        CREATE OBJECT lo_msg
          EXPORTING
            textid             = cm_devs4d435=>dates_wrong_sequence
            severity           = cm_devs4d435=>co_severity_error
            lifetime           = cm_devs4d435=>co_lifetime_state
            ms_origin_location = ls_location.

        APPEND lo_msg TO lt_msg.

*        APPEND NEW cm_d435d_travel(
*          textid   = cm_devs4d435=>dates_wrong_sequence
*          severity = cm_devs4d435=>co_severity_error
*          lifetime = cm_devs4d435=>co_lifetime_state
*          ms_origin_location =
*               VALUE #( bo_key     = is_ctx-bo_key
*                        node_key   = is_ctx-node_key
*                        key        = <ls_travel>-key
*                        attributes = VALUE #(
*                                ( if_d435d_i_traveltp_c=>sc_node_attribute-d435d_i_traveltp-startdate ) )
*                       )
*           ) TO lt_msg.

      ENDIF.

* if errors found - mark node instance as failed and issue messages
**********************************************************************

      IF lt_msg IS NOT INITIAL.

        INSERT VALUE #(  key = <ls_travel>-key ) INTO TABLE et_failed_key.

        IF eo_message IS NOT BOUND.
          eo_message = /bobf/cl_frw_factory=>get_message( ).
        ENDIF.

        " add collected list of message objects to container
        eo_message->add_cm(
          EXPORTING
            it_message = lt_msg
        ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
