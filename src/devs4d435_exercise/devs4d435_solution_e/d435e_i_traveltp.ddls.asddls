@AbapCatalog.sqlViewName: 'D435EI_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Interface View'

@VDM.viewType: #TRANSACTIONAL

@ObjectModel:
  {
     modelCategory: #BUSINESS_OBJECT,
     compositionRoot: true,

     representativeKey: 'TravelGuid',
     semanticKey: ['TravelAgency', 'TravelNumber'],

     transactionalProcessingEnabled: true,
     writeActivePersistence: 'D435E_V_TRAVEL',

     updateEnabled: 'EXTERNAL_CALCULATION',
     createEnabled: true,
          
     draftEnabled: true,
     writeDraftPersistence: 'D435E_TRAVEL_D',
     
     deleteEnabled: 'EXTERNAL_CALCULATION'
     
  }

define view D435E_I_TravelTP
  as select from D435E_I_Travel
 association [*] to D435E_I_TravelItemTP as _TravelItem 
  on $projection.TravelGuid = _TravelItem.TravelGuid
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

      _Customer,
      
      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      _TravelItem
}
