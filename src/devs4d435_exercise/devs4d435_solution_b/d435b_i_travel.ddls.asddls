@AbapCatalog.sqlViewName: 'D435BI_TRAVEL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #BASIC

define view D435B_I_Travel as select 
       from d435b_travel 
{
  key agencynum as TravelAgency,
  key travelid  as TravelNumber,
  trdesc        as TravelDescription,
  customid      as Customer,
  stdat         as StartDate,
  enddat        as EndDate,
  status        as Status,
  changedat     as ChangedAt,
  changedby     as ChangedBy
}
