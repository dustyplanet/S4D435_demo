@AbapCatalog.sqlViewName: 'D435_ICUSTOM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Customer'

@VDM.viewType: #BASIC

define view D435_I_Customer as select from scustom 
{
      @ObjectModel.text.element: ['full_name']
  key id    as Customer,
      name  as CustomerName ,
      form  as CustomerForm,
      concat_with_space(form, name, 1) as full_name,
      street,
      postbox,
      postcode,
      city,
      country,
      region,
      telephone,
      custtype as CustomerType,
      discount,
      langu,
      email,
      webuser    
}
