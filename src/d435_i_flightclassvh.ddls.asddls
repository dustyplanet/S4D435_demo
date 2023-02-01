@AbapCatalog.sqlViewName: 'D435I_FLCLAVH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Class Value Help'

@VDM.viewType: #COMPOSITE

@ObjectModel.dataCategory: #VALUE_HELP

define view D435_I_FlightClassVH 
  as select from DS4_I_FlightClass
  association [*] to DS4_I_FLIGHTCLASST as _description 
  on $projection.FlightClass = _description.FlightClass

      {
 @Consumption.filter.hidden: true      
          @ObjectModel.text.association: '_description'
      key FlightClass,
    
          _description
    }
    
      
 