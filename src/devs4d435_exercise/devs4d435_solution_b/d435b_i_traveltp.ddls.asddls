@AbapCatalog.sqlViewName: 'D435BI_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #TRANSACTIONAL

@ObjectModel: 
  {
     modelCategory: #BUSINESS_OBJECT,
     compositionRoot: true,
     
     representativeKey: 'TravelNumber',
     semanticKey: ['TravelAgency', 'TravelNumber'],
     
     transactionalProcessingEnabled: true,
     writeActivePersistence: 'D435B_V_TRAVEL'
  }

define view D435B_I_TravelTP as select 
       from D435B_I_Travel
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
