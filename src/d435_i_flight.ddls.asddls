@AbapCatalog.sqlViewName: 'D435I_FLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight'

@VDM.viewType: #BASIC

define view D435_I_Flight
  as select from sflight
   association[1] to D435_I_Connection as _Connection
   on $projection.AirlineID = _Connection.AirlineID
  and $projection.ConnectionNumber = _Connection.ConnectionNumber      

{

      // Fields
  key carrid    as AirlineID,
  @ObjectModel.foreignKey.association: '_Connection'
  key connid    as ConnectionNumber,
  key fldate    as FlightDate,

      planetype as AirplaneType,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price     as FlightPrice,
      currency  as CurrencyCode,
      
      _Connection
      
}
