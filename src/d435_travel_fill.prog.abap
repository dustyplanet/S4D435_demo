*&---------------------------------------------------------------------*
*& Report s4d435_travel_fill
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
Report d435_travel_fill Message-Id devs4d435.

CONSTANTS c_template TYPE tabname VALUE 'D435A_TRAVEL'.
TYPES     tt_data TYPE STANDARD TABLE OF d435a_travel
          WITH NON-UNIQUE DEFAULT KEY.

PARAMETERS pa_tab TYPE dd03l-tabname VALUE CHECK.

CLASS lcl_dbtable DEFINITION.

  PUBLIC SECTION.

    DATA mv_tabname TYPE  tabname READ-ONLY.

    METHODS constructor IMPORTING iv_tabname TYPE tabname.

    METHODS is_empty      RETURNING VALUE(rv_result) TYPE abap_bool.
    METHODS has_guid_field RETURNING VALUE(rv_result) TYPE abap_bool.

    METHODS check_compatible RETURNING VALUE(rv_consistent) TYPE abap_bool.

    METHODS generate_data.

    METHODS update_with_guid.

    METHODS delete_data.

  PRIVATE SECTION.

    DATA mr_data TYPE REF TO data.

    DATA mt_components TYPE abap_compdescr_tab.

    DATA mv_guid_field TYPE abap_compname.

    METHODS add_guid_field.

    METHODS dbselect.

    METHODS dbsync.

ENDCLASS.

CLASS lcl_dbtable IMPLEMENTATION.

  METHOD constructor.

    mv_tabname  = iv_tabname.
    mt_components = CAST cl_abap_structdescr(
                         cl_abap_typedescr=>describe_by_name( iv_tabname )
                                           )->components.

    TRY.
        mv_guid_field = mt_components[ type_kind = cl_abap_typedescr=>typekind_hex
                                       length    = 16  ]-name.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    CREATE DATA mr_data TYPE TABLE OF (mv_tabname).

    dbselect( ).

  ENDMETHOD.


  METHOD check_compatible.
    DATA(lo_template) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( c_template ) ).

* remove guid field if any
    DATA(lt_components) = mt_components.
    IF mv_guid_field IS NOT INITIAL.
      DELETE lt_components WHERE name = mv_guid_field.
    ENDIF.
* check for compatibility of type

    rv_consistent = abap_true.

    IF lt_components <> lo_template->components.
      rv_consistent = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD is_empty.
    rv_result = abap_true.
    SELECT SINGLE FROM (pa_tab)
            FIELDS @abap_false
            INTO @rv_result.
  ENDMETHOD.

  METHOD has_guid_field.

    IF mv_guid_field IS NOT INITIAL.
      rv_result = abap_true.
    ELSE.
      rv_result = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD generate_data.

    FIELD-SYMBOLS
       <lt_data> TYPE ANY TABLE.

    DATA(lv_agency)   =  cl_s4d435_model=>get_agency_by_user( sy-uname ).
    GET TIME STAMP FIELD DATA(lv_changedat) .
    DATA(lt_data) = VALUE tt_data(

* Travel in the past
     (
       agencynum = lv_agency
          travelid  = cl_s4d435_model=>get_next_travelid_for_agency( lv_agency )
       trdesc    = 'Travel in the past'
       customid  = 1
       stdat     = sy-datum - 28
       enddat    = sy-datum - 14
       status    = ' '
       changedat = lv_changedat
       changedby = sy-uname
     )

* ongoing travel
     (
          agencynum = lv_agency
          travelid  = cl_s4d435_model=>get_next_travelid_for_agency( lv_agency )
          trdesc    = 'Travel ongoing'
          customid  = 2
          stdat     = sy-datum - 7
          enddat    = sy-datum + 7
          status    = ' '
          changedat = lv_changedat
          changedby = sy-uname
     )

* travel in the future

     (
          agencynum = lv_agency
          travelid  = cl_s4d435_model=>get_next_travelid_for_agency( lv_agency )
          trdesc    = 'Travel in the future'
          customid  = 3
          stdat     = sy-datum + 7
          enddat    = sy-datum + 21
          status    = ' '
          changedat = lv_changedat
          changedby = sy-uname
     )

* travel for travel agency 061
          (
          agencynum = '061'
          travelid  = cl_s4d435_model=>get_next_travelid_for_agency( '061' )
          trdesc    = 'Travel of travel agency 061'
          customid  = 4
          stdat     = sy-datum + 7
          enddat    = sy-datum + 14
          status    = ' '
          changedat = lv_changedat
          changedby = sy-uname
          )

* travel for travel agency 325
          (
          agencynum = '325'
          travelid  = cl_s4d435_model=>get_next_travelid_for_agency( '325' )
          trdesc    = 'Travel of agency 325'
          customid  = 4
          stdat     = sy-datum + 14
          enddat    = sy-datum + 21
          status    = ' '
          changedat = lv_changedat
          changedby = sy-uname
          )

    ).

    ASSIGN mr_data->* TO <lt_data>.

    MOVE-CORRESPONDING lt_data TO <lt_data>.

    IF mv_guid_field IS NOT INITIAL.
      add_guid_field( ).
    ENDIF.

    dbsync( ).

  ENDMETHOD.

  METHOD update_with_guid.

    IF mv_guid_field IS NOT INITIAL.
      add_guid_field( ).
      dbsync( ).

    ENDIF.
  ENDMETHOD.

  METHOD delete_data.
    FIELD-SYMBOLS
    <lt_data> TYPE ANY TABLE.

    ASSIGN mr_data->* TO <lt_data>.

    CLEAR <lt_data>.

    dbsync( ).

  ENDMETHOD.


  METHOD add_guid_field.
    FIELD-SYMBOLS
    <lt_data> TYPE ANY TABLE.

    ASSIGN mr_data->* TO <lt_data>.

    LOOP AT <lt_data> ASSIGNING FIELD-SYMBOL(<ls_data>).

      ASSIGN COMPONENT mv_guid_field OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_guid>).

      IF <lv_guid> IS INITIAL.

        CALL FUNCTION 'GUID_CREATE'
          IMPORTING
            ev_guid_16 = <lv_guid>.

        ASSIGN COMPONENT 'CHANGEDAT' OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_changedat>).
        IF sy-subrc = 0.
          GET TIME STAMP FIELD <lv_changedat>.
        ENDIF.

        ASSIGN COMPONENT 'CHANGEDBY' OF STRUCTURE <ls_data> TO FIELD-SYMBOL(<lv_changedby>).
        IF sy-subrc = 0.
          <lv_changedby> = sy-uname.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD dbselect.
    FIELD-SYMBOLS <lt_data> TYPE ANY TABLE.
    ASSIGN mr_data->* TO <lt_data>.

    SELECT * FROM (mv_tabname) INTO TABLE <lt_data>.

  ENDMETHOD.
  METHOD dbsync.
    FIELD-SYMBOLS <lt_data> TYPE ANY TABLE.

    ASSIGN mr_data->* TO <lt_data>.

    IF <lt_data> IS INITIAL.
      DELETE FROM (mv_tabname).
    ELSEIF is_empty( ) = abap_true.

      INSERT (mv_tabname) FROM TABLE <lt_data>.

    ELSE.

      UPDATE (mv_tabname) FROM TABLE <lt_data>.

    ENDIF.

  ENDMETHOD.


ENDCLASS.


CLASS lcl_alv_display DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        io_dbtable TYPE REF TO lcl_dbtable.

    METHODS display.

  PRIVATE SECTION.

    DATA mo_dbtable TYPE REF TO lcl_dbtable.

    DATA mo_salv TYPE REF TO if_salv_gui_table_ida.

    METHODS configure_toolbar.

    METHODS on_function_selected
      FOR EVENT function_selected
                OF if_salv_gui_toolbar_ida
      IMPORTING ev_fcode.


ENDCLASS.


CLASS lcl_alv_display IMPLEMENTATION.

  METHOD constructor.

    mo_dbtable = io_dbtable.

    mo_salv = cl_salv_gui_table_ida=>create(
        iv_table_name         = mo_dbtable->mv_tabname
*            io_gui_container      =
    ).

    configure_toolbar( ).

  ENDMETHOD.

  METHOD configure_toolbar.

    DATA(lo_toolbar) = mo_salv->toolbar( ).

    lo_toolbar->hide_all_standard_functions( ).

    lo_toolbar->add_button(
    EXPORTING
      iv_fcode                     = 'DELETE'
*    iv_icon                      =                  " Name of an Icon
*      iv_is_disabled               = mo_dbtable->is_empty( )
    iv_text                      = 'Delete All'
*    iv_quickinfo                 =
      ).

    lo_toolbar->add_button(
    EXPORTING
      iv_fcode                     = 'GENERATE'
*    iv_icon                      =                  " Name of an Icon
*    iv_is_disabled               = SWITCH #( mo_dbtable->is_empty( )
*                                             WHEN abap_true THEN abap_false
*                                             WHEN abap_false THEN abap_true )
      iv_text                      = 'Generate Data'
*    iv_quickinfo                 =
      ).

*   IF mo_dbtable->has_guid_field( ) = abap_true.
    lo_toolbar->add_button(
    EXPORTING
      iv_fcode                     = 'GUID'
*    iv_icon                      =                  " Name of an Icon
*    iv_is_disabled               =
      iv_text                      = 'Generate GUID'
*    iv_quickinfo                 =
      ).

*    ENDIF.

    SET HANDLER me->on_function_selected FOR lo_toolbar.

  ENDMETHOD.

  METHOD display.

    mo_salv->fullscreen( )->display( ).

  ENDMETHOD.

  METHOD on_function_selected.

    CASE ev_fcode.
      WHEN 'DELETE'.

        IF mo_dbtable->is_empty( ) <> abap_true.
          mo_dbtable->delete_data( ).
        ELSE.
 message i015.
        ENDIF.

      WHEN 'GENERATE'.

        IF mo_dbtable->is_empty( ) = abap_true.
          mo_dbtable->generate_data( ).
        ELSE.
 message i020.
        ENDIF.

      WHEN 'GUID'.

        IF mo_dbtable->has_guid_field( ) = abap_true.
          mo_dbtable->update_with_guid( ).
        ELSE.
 message i025.
        ENDIF.


    ENDCASE.

    mo_salv->refresh( ).
*    me->configure_toolbar( ).
  ENDMETHOD.

ENDCLASS.


DATA go_dbtable TYPE REF TO lcl_dbtable.

DATA go_alv_display TYPE REF TO lcl_alv_display.

INITIALIZATION.

  IF sy-uname CP 'TRAIN-++'.
    pa_tab = |Z{ sy-uname+6(2) }_TRAVEL|.

  ELSE.
    pa_tab = 'Z00_TRAVEL'.
  ENDIF.


AT SELECTION-SCREEN.

  SELECT SINGLE FROM dd02l
    FIELDS @abap_true
     WHERE tabname = @pa_tab
  AND tabclass = 'TRANSP'
  AND as4local = 'A'
    INTO @DATA(gv_exists).

  IF gv_exists <> abap_true.
Message e005 With pa_tab.
  ENDIF.

  go_dbtable = NEW #( iv_tabname = pa_tab ).

  IF go_dbtable->check_compatible( ) <> abap_true.
    MESSAGE e010 with pa_tab.
  ENDIF.

START-OF-SELECTION.

  go_alv_display = NEW #( io_dbtable = go_dbtable ).

  go_alv_display->display( ).
