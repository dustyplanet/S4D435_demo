@AbapCatalog.sqlViewName: 'D435TI_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Transactional View'

@VDM.viewType: #TRANSACTIONAL

define view D435T_I_TravelTP
  as select from D435T_I_Travel

{
  key TravelAgency,
  key TravelNumber,
      TravelDescription,
      Customer,
      StartDate,
      EndDate,
      Status,
      ChangedAt,
      ChangedBy
}
