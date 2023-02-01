@AbapCatalog.sqlViewName: 'D435EC_TRITEMTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Item Consumption View'

@VDM.viewType: #CONSUMPTION

@Metadata.allowExtensions: true


@ObjectModel:{

   semanticKey: ['TravelAgency','TravelNumber', 'ItemNumber'],

   createEnabled: true,
   updateEnabled: true,
   deleteEnabled: true

}

define view D435E_C_TravelItemTP
  as select from D435E_I_TravelItemTP
  association [1] to D435_I_FlightVH      as _FlightVH      
   on  $projection.AirlineID        = _FlightVH.AirlineID
  and $projection.ConnectionNumber  = _FlightVH.ConnectionNumber
  and $projection.FlightDate        = _FlightVH.FlightDate
  association [1] to D435_I_FlightClassVH as _FlightClassVH 
   on  $projection.FlightClass      = _FlightClassVH.FlightClass
  association [1] to D435E_C_TravelTP     as _Travel        
   on  $projection.TravelGuid       = _Travel.TravelGuid
{
  key ItemGuid,
      TravelAgency,
      TravelNumber,
      ItemNumber,
      TravelGuid,

      @Consumption.valueHelp: '_FlightVH'
      AirlineID,
      @Consumption.valueHelp: '_FlightVH'
      ConnectionNumber,
      @Consumption.valueHelp: '_FlightVH'

      FlightDate,
      BookingNumber,
      @Consumption.valueHelp: '_FlightClassVH'
      FlightClass,
      PassengerName,
      CreatedAt,
      CreatedBy,
      ChangedAt,
      ChangedBy,

      _FlightVH,
      _FlightClassVH,

      @ObjectModel.association.type: [ #TO_COMPOSITION_PARENT, 
                                       #TO_COMPOSITION_ROOT
                                     ]
      _Travel
}
