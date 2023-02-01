@AbapCatalog.sqlViewName: 'D435I_CONN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Connection'

@VDM.viewType: #BASIC

define view D435_I_Connection as select from spfli 
{
  key carrid                                 as AirlineID, 
  key connid                                 as ConnectionNumber,

      fltype                                 as FlightType,

      airpfrom                               as OriginAirport,    
      cityfrom                               as OriginCity,
      countryfr                              as OriginCountry,

      airpto                                 as DestinationAirport,
      cityto                                 as DestinationCity,
      countryto                              as DestinationCoutry,

      @Semantics.quantity.unitOfMeasure: 'UnitForDistance'
      distance                               as FlightDistance,
      distid                                 as UnitForDistance,

      deptime                                as DepartureTime,
      arrtime                                as ArrivalTime,

      period                                 as ArrivalDaysLater,
      fltime                                 as FlightDuration

}
