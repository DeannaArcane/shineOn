Public class ProejctPdf{
    
    Public Id OpportunihtyId{get;set;}
    
    Public Opportunity opprecords{get;set;}
    
    Public ProejctPdf (ApexPages.StandardController controller){
        OpportunihtyId = system.currentPageReference().getParameters().get('Id');
 
        system.debug(OpportunihtyId +'@@@@@@@@@');
 
        if(OpportunihtyId != null){
            opprecords = [SELECT id, name, Job_Number__c, Account.Phone, Account.billingstreet, 
                    Account.Billingcity,Leasing_Company__r.name, Utility_Company__r.name, Permit_Number__c,
                    Project_Manager__r.name, Install_Crew__r.name, Scheduled_Install_Date__c, 
                    Received_From_Jurisdiction_Processing__c, Jurisdiction__c 
                    FROM opportunity where Id =: OpportunihtyId];
        } 
    } 
}