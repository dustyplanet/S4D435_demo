@AbapCatalog.sqlViewName: 'D435CI_TRAVELTP'
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
     writeActivePersistence: 'D435C_V_TRAVEL',

//     updateEnabled: true,
     updateEnabled: 'EXTERNAL_CALCULATION',
     createEnabled: true

  }

define view D435C_I_TravelTP
  as select from D435C_I_Travel
{
      @ObjectModel.readOnly: true
  key TravelAgency,
      @ObjectModel.readOnly: true
  key TravelNumber,
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
