@AbapCatalog.sqlViewName: 'D435EI_TRITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Item Interface View'

@VDM.viewType: #BASIC

define view D435E_I_TravelItem
  as select from d435e_tritem
  association[1] to D435E_I_Travel as _Travel
  on $projection.TravelGuid = _Travel.TravelGuid
{
  key itguid    as ItemGuid,
      agencynum as TravelAgency,
      travelid  as TravelNumber,
      tritemno  as ItemNumber,
      trguid    as TravelGuid,
      carrid    as AirlineID,
      connid    as ConnectionNumber,
      fldate    as FlightDate,
      bookid    as BookingNumber,
      class     as FlightClass,
      passname  as PassengerName,
      @Semantics.systemDateTime.createdAt: true
      createdat as CreatedAt,
      @Semantics.user.createdBy: true
      createdby as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changedat as ChangedAt,
      @Semantics.user.lastChangedBy: true
      changedby as ChangedBy,
      
      _Travel
      

}
