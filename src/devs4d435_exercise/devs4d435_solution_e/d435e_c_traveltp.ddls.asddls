@AbapCatalog.sqlViewName: 'D435EC_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Consumption View'

@VDM.viewType: #CONSUMPTION
@OData.publish: true

@Search.searchable: true

@ObjectModel: {

   transactionalProcessingDelegated: true,
   semanticKey: ['TravelAgency', 'TravelNumber'],

   updateEnabled: 'EXTERNAL_CALCULATION',
   createEnabled: true,

   draftEnabled: true,
   compositionRoot: true,

   deleteEnabled: 'EXTERNAL_CALCULATION'

              }

@Metadata.allowExtensions: true

define view D435E_C_TravelTP
  as select from D435E_I_TravelTP
  association [*] to D435E_C_TravelItemTP as _TravelItem 
  on $projection.TravelGuid = _TravelItem.TravelGuid
{
  key TravelGuid,
      TravelAgency,
      TravelNumber,
      @Search: { defaultSearchElement: true,
                 fuzzinessThreshold: 0.8
               }
      TravelDescription,
      Customer,
      StartDate,
      EndDate,
      Status,
      ChangedAt,
      ChangedBy,

      _Customer,
      
      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      _TravelItem
}
