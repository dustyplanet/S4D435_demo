@AbapCatalog.sqlViewName: 'D435TC_TRITEMTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Item Consumption View'

@VDM.viewType: #CONSUMPTION

@Metadata.allowExtensions: true

define view D435T_C_TravelItemTP
  as select from D435T_I_TravelItemTP
  association[1] to D435_I_FlightVH as _FlightVH 
   on $projection.AirlineID        = _FlightVH.AirlineID
  and $projection.ConnectionNumber = _FlightVH.ConnectionNumber
  and $projection.FlightDate       = _FlightVH.FlightDate
 association[1] to D435_I_FlightClassVH as _FlightClassVH
  on $projection.FlightClass       = _FlightClassVH.FlightClass  
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
      _FlightClassVH
}
