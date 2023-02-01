@AbapCatalog.sqlViewName: 'D435AC_TRAVELTP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight Travel Consumption View'

@VDM.viewType: #CONSUMPTION
@OData.publish: true

@Search.searchable: true

@Metadata.allowExtensions: true

define view D435A_C_TravelTP as select 
       from D435A_I_TravelTP 
{
   key TravelAgency,   
   key TravelNumber,
   
          @Search: { defaultSearchElement: true,
                     fuzzinessThreshold: 0.8
                   }  
   
       TravelDescription,
       Customer,
       StartDate,
       EndDate,
       Status,
       ChangedAt,
       ChangedBy
}
