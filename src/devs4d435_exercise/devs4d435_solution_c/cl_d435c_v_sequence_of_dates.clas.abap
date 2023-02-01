CLASS cl_d435c_v_sequence_of_dates DEFINITION
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



CLASS CL_D435C_V_SEQUENCE_OF_DATES IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA lt_travel TYPE d435c_t_itraveltp.
    DATA lt_travel_before TYPE d435c_t_itraveltp.


    "for messages
    DATA lo_msg TYPE REF TO cm_devs4d435.
    DATA lt_msg TYPE  /bobf/cm_frw=>tt_frw.

    CONSTANTS c_s_initial_travel TYPE d435c_s_itraveltp VALUE IS INITIAL.

* Read required Data
**********************************************************************

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
*     iv_before_image         = abap_false
      IMPORTING
        eo_message              = eo_message
        et_data                 = lt_travel
    ).


    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>)
                      WHERE startdate IS NOT INITIAL
                        AND enddate IS NOT INITIAL.


* Derive previous image of active data set
**********************************************************************

*      DATA lt_key_single TYPE /bobf/t_frw_key.
*      DATA ls_key_single TYPE /bobf/s_frw_key.
*
*      ls_key_single-key = <ls_travel>-key.
*      APPEND ls_key_single TO lt_key_single.

*      io_read->retrieve(
*        EXPORTING
*          iv_node                 = is_ctx-node_key
*          it_key                  = lt_key_single
*          iv_before_image         = abap_true
*        IMPORTING
*          eo_message              = eo_message
*          et_data                 = lt_travel_before
*      ).
*
*      FIELD-SYMBOLS <ls_travel_before> LIKE LINE OF lt_travel_before.
*      READ TABLE lt_travel_before ASSIGNING <ls_travel_before> INDEX 1.

      io_read->retrieve(
        EXPORTING
          iv_node                 = is_ctx-node_key
          it_key                  = VALUE #(  (  key = <ls_travel>-key ) )
          iv_before_image         = abap_true
        IMPORTING
          eo_message              = eo_message
          et_data                 = lt_travel_before
      ).

      ASSIGN lt_travel_before[  1 ] TO FIELD-SYMBOL(<ls_travel_before>).
      IF sy-subrc <> 0. "no previous data - new node instance
        ASSIGN c_s_initial_travel TO <ls_travel_before>.
      ENDIF.

* perform the checks
**********************************************************************

      "sequence of start date and end date
      IF <ls_travel>-enddate < <ls_travel>-startdate.

        CREATE OBJECT lo_msg
          EXPORTING
            textid   = cm_devs4d435=>dates_wrong_sequence
            severity = cm_devs4d435=>co_severity_error
*           lifetime =
          .

        APPEND lo_msg TO lt_msg.

      ENDIF.

      "end date
      IF <ls_travel>-enddate < sy-datum.

        CREATE OBJECT lo_msg
          EXPORTING
            textid   = cm_devs4d435=>end_date_past
            severity = cm_devs4d435=>co_severity_error
*           lifetime =
          .

        APPEND lo_msg TO lt_msg.

      ENDIF.

      "start date
      IF <ls_travel>-startdate = <ls_travel_before>-startdate.
        " ignore - not changed
      ELSEIF <ls_travel>-startdate < sy-datum.

        CREATE OBJECT lo_msg
          EXPORTING
            textid   = cm_devs4d435=>start_date_past
            severity = cm_devs4d435=>co_severity_error
*           lifetime =
          .

        APPEND lo_msg TO lt_msg.

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
