@AbapCatalog.sqlViewName: 'D435EI_TRAVEL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #BASIC

define view D435E_I_Travel
  as select from d435e_travel
  association [1..1] to D435_I_Customer as _Customer 
  on $projection.Customer = _Customer.Customer
  association[*] to D435E_I_TravelItem as _TravelItem
  on $projection.TravelGuid = _TravelItem.TravelGuid 
{
  key  trguid    as TravelGuid,
       agencynum as TravelAgency,
       travelid  as TravelNumber,
       trdesc    as TravelDescription,
       customid  as Customer,
       stdat     as StartDate,
       enddat    as EndDate,
       status    as Status,
       @Semantics.systemDateTime.lastChangedAt: true
       changedat as ChangedAt,
       @Semantics.user.lastChangedBy: true
       changedby as ChangedBy,

       _Customer,
       _TravelItem
}
