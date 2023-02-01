@AbapCatalog.sqlViewName: 'D435DI_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #TRANSACTIONAL

@ObjectModel:
  {
     modelCategory: #BUSINESS_OBJECT,
     compositionRoot: true,

//     representativeKey: 'TravelNumber',
     representativeKey: 'TravelGuid',
     semanticKey: ['TravelAgency', 'TravelNumber'],

     transactionalProcessingEnabled: true,
     writeActivePersistence: 'D435D_V_TRAVEL',

//     updateEnabled: true,
     updateEnabled: 'EXTERNAL_CALCULATION',
     createEnabled: true,
          
     draftEnabled: true,
     writeDraftPersistence: 'D435D_TRAVEL_D',
     
     deleteEnabled: 'EXTERNAL_CALCULATION'
     
  }

define view D435D_I_TravelTP
  as select from D435D_I_Travel
{
  key TravelGuid,
      @ObjectModel.readOnly: true
      TravelAgency,
      @ObjectModel.readOnly: true
      TravelNumber,
      TravelDescription,
      
      @ObjectModel.mandatory: true
      @ObjectModel.readOnly: 'EXTERNAL_CALCULATION'
      @ObjectModel.foreignKey.association: '_Customer'
      Customer,
      
      @ObjectModel.mandatory: true
      @ObjectModel.readOnly: 'EXTERNAL_CALCULATION'
      StartDate,
      
      @ObjectModel.mandatory: true
      EndDate,
      
      @ObjectModel.readOnly: true
      Status,
      ChangedAt,
      ChangedBy,

      _Customer
}
