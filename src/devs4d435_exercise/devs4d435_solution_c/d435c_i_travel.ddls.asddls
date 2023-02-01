@AbapCatalog.sqlViewName: 'D435CI_TRAVEL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #BASIC

define view D435C_I_Travel as select 
       from d435c_travel 
       association[1..1] to D435_I_Customer as _Customer
                         on $projection.Customer = _Customer.Customer
{
  key agencynum as TravelAgency,
  key travelid  as TravelNumber,
  trdesc        as TravelDescription,
  customid      as Customer,
  stdat         as StartDate,
  enddat        as EndDate,
  status        as Status,
  @Semantics.systemDateTime.lastChangedAt: true
  changedat     as ChangedAt,
  @Semantics.user.lastChangedBy: true
  changedby     as ChangedBy,
  
  _Customer
}
