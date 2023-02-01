@AbapCatalog.sqlViewName: 'D435TI_TRITEMTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Item Transactional View'

@VDM.viewType: #TRANSACTIONAL

define view D435T_I_TravelItemTP
  as select from D435T_I_TravelItem

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
      ChangedBy
}
