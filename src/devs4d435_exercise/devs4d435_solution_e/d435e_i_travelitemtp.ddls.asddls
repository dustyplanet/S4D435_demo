@AbapCatalog.sqlViewName: 'D435EI_TRITEMTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Item Transactional View'

@VDM.viewType: #TRANSACTIONAL

@ObjectModel:{

   representativeKey: 'ItemGuid',
   semanticKey: ['TravelAgency','TravelNumber', 'ItemNumber'],

   writeActivePersistence: 'D435E_V_TRITEM',

   writeDraftPersistence: 'D435E_TRITEM_D',

   createEnabled: true,
   updateEnabled: true,
   deleteEnabled: true

}

define view D435E_I_TravelItemTP
  as select from D435E_I_TravelItem
  association [1] to D435E_I_TravelTP as _Travel 
   on $projection.TravelGuid = _Travel.TravelGuid

{
  key ItemGuid,
      @ObjectModel.readOnly: true
      TravelAgency,
      @ObjectModel.readOnly: true
      TravelNumber,
      @ObjectModel.readOnly: true
      ItemNumber,
      TravelGuid,
      @ObjectModel.mandatory: true
      AirlineID,
      @ObjectModel.mandatory: true
      ConnectionNumber,
      @ObjectModel.mandatory: true
      FlightDate,
      @ObjectModel.readOnly: true
      BookingNumber,
      @ObjectModel.mandatory: true
      FlightClass,
      @ObjectModel.mandatory: true
      PassengerName,
      CreatedAt,
      CreatedBy,
      ChangedAt,
      ChangedBy,

      @ObjectModel.association.type: [ #TO_COMPOSITION_PARENT,
                                       #TO_COMPOSITION_ROOT
                                     ]
      _Travel


}
