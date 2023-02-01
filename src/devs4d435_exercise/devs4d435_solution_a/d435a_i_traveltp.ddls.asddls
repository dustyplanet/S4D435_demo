@AbapCatalog.sqlViewName: 'D435AI_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #TRANSACTIONAL

define view D435A_I_TravelTP as select 
       from D435A_I_Travel

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
