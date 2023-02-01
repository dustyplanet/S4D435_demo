CLASS cl_d435d_a_issue_message DEFINITION
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



CLASS CL_D435D_A_ISSUE_MESSAGE IMPLEMENTATION.


   METHOD /bobf/if_frw_action~execute.

    DATA lo_msg TYPE ref to cm_d435d_travel.

    IF eo_message IS NOT BOUND.
      eo_message = /bobf/cl_frw_message_factory=>create_container( ).
    ENDIF.

   CREATE OBJECT lo_msg
     EXPORTING
       textid                  = cm_d435d_travel=>cm_d435d_travel
       severity                = cm_d435d_travel=>co_severity_success
*       symptom                 =
*       lifetime                =
*       ms_origin_location      =
     .


   eo_message->add_cm( io_message = lo_msg ).

    ev_static_action_failed = abap_false.

* Expression-based Alternative (fewer helper variables )
********************************************************************************

*    IF eo_message IS NOT BOUND.
*      eo_message = /bobf/cl_frw_message_factory=>create_container( ).
*    ENDIF.
*
*   eo_message->add_cm(
*        io_message = NEW cm_d435d_travel(
*                          textid   = cm_d435d_travel=>cm_d435d_travel
*                           severity = cm_d435d_travel=>co_severity_success
**                          symptom                 =
**                          lifetime                =
**                          ms_origin_location      =
*                                         )
*                      ).
*
*    ev_static_action_failed = abap_false.

  ENDMETHOD.
ENDCLASS.
