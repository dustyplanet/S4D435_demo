@AbapCatalog.sqlViewName: 'D435I_FLIGHTVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help for Flight'

@VDM.viewType: #COMPOSITE

@ObjectModel.dataCategory: #VALUE_HELP

define view D435_I_FlightVH as select from D435_I_Flight 
{
     @UI.selectionField: [{position: 50 }]
 key AirlineID,
    @Consumption.filter.hidden: true
 key ConnectionNumber,
     @UI.selectionField: [{position: 30 }]
 key FlightDate,
 
     @UI.selectionField: [{position: 10 }]
  _Connection.OriginCity,
     @UI.selectionField: [{position: 40 }]
 _Connection.DepartureTime,

     @UI.selectionField: [{position: 20 }]
 _Connection.DestinationCity,
     @UI.selectionField: [{position: 50 }]
 _Connection.ArrivalTime,
 
@Consumption.filter.hidden: true
 _Connection.ArrivalDaysLater,
  
 @Consumption.filter.hidden: true
 _Connection
//   
}

