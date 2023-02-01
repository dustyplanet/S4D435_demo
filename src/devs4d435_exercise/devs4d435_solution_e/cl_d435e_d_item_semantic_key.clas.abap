CLASS cl_d435e_d_item_semantic_key DEFINITION
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



CLASS CL_D435E_D_ITEM_SEMANTIC_KEY IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA lt_item TYPE  d435e_t_itravelitemtp.
    DATA lt_travel TYPE d435e_t_itraveltp.

    DATA lt_item_all TYPE d435e_t_itravelitemtp.

* Retrieve data of affected nodes
**********************************************************************

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
      IMPORTING
        et_data                 = lt_item
    ).

    LOOP AT lt_item REFERENCE INTO DATA(lr_item).

* travelagency and travelnumber
**********************************************************************
      IF lr_item->travelagency IS INITIAL OR
         lr_item->travelnumber IS INITIAL.

        " retrieve parent node data

        io_read->retrieve(
        EXPORTING
          iv_node        = is_ctx-root_node_key
          it_key         = VALUE #( ( key = lr_item->parent_key ) )
        IMPORTING
          et_data = lt_travel ).

        " Set Travelagency and Travelnumber
        lr_item->travelagency = lt_travel[  1 ]-travelagency.
        lr_item->travelnumber = lt_travel[  1 ]-travelnumber.

        io_modify->update(
            EXPORTING
              iv_node = is_ctx-node_key
              iv_key  = lr_item->key
              is_data = lr_item
              it_changed_fields = VALUE #( ( if_d435e_i_traveltp_c=>sc_node_attribute-d435e_i_travelitemtp-travelagency )
                                           ( if_d435e_i_traveltp_c=>sc_node_attribute-d435e_i_travelitemtp-travelnumber )
                                                                 )
                                         ).

      ENDIF.

* ItemNumber
**********************************************************************
      IF lr_item->itemnumber IS INITIAL.

        " read all items of the same travel (draft and non-draft)
        io_read->retrieve_by_association(
          EXPORTING
            iv_node                 = is_ctx-root_node_key
            it_key                  = VALUE #( ( key = lr_item->root_key ) )
            iv_association          = if_d435e_i_traveltp_c=>sc_association-d435e_i_traveltp-_travelitem
            iv_fill_data            = abap_true
          IMPORTING
            et_data                 =  lt_item_all
        ).

        "find highest value and increase by 10
        SORT lt_item_all BY itemnumber DESCENDING.

        lr_item->itemnumber = lt_item_all[ 1 ]-itemnumber + 10.

        io_modify->update(
            EXPORTING
              iv_node = is_ctx-node_key
              iv_key  = lr_item->key
              is_data = lr_item
              it_changed_fields = VALUE #(  ( if_d435e_i_traveltp_c=>sc_node_attribute-d435e_i_travelitemtp-itemnumber ) )
          ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
