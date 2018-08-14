@istest
Public class ProjectPDF_TC
{
  Public Static testmethod void proejctcover()
  {
    RecordType rt = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' AND DeveloperName = 'PersonAccount' limit 1];
    RecordType rtu = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' AND DeveloperName = 'Utility_Company' limit 1];
    RecordType rtl = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' AND DeveloperName = 'Leasing_Company' limit 1];
    RecordType rtc = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Contact' AND DeveloperName = 'Site_Survey_Tech' limit 1];
    Account acc = new Account();
    acc.lastname = 'test';
    acc.Email_Address__c ='test@gmail.com';
    acc.PersonEmail ='test@gmail.com';
    acc.phone = '1234567789';
    acc.BillingState = 'idaho';
    acc.recordtypeid = rt.id;
    insert acc;
    
    Account acc1 = new Account();
    acc1.name = 'test';
    acc1.BillingState = 'idaho';
    acc1.phone = '1234567789';
    acc1.recordtypeid = rtu.id;
    insert acc1;
    
    Account acc2 = new Account();
    acc2.name = 'test12';
    acc2.Email_Address__c ='test1@gmail.com';
    acc2.phone = '1234567787';
    acc2.BillingState = 'idaho';
    acc2.recordtypeid = rtl.id;
    insert acc2;
    
    Contact c = new contact();
    c.lastname = 'test';
    c.accountid = acc1.id;
    c.email = 'test@gmail.com';
     insert c;
    
     RecordType rt1 = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Opportunity' AND DeveloperName = 'Full_EPC' limit 1];
     Opportunity opp = new Opportunity();
     opp.name ='test';
     opp.accountid = acc.id;
     opp.Lease_Id__c = '123';
     opp.Utility_Company__c = acc1.id;
     opp.Leasing_Company__c = acc2.id;
     opp.Panel_Manufacturer__c = '234';
     opp.Number_Of_Panels__c =23;
     opp.Inverter_Manufacturer__c = 'test';
     opp.Admin_Processing_Completed_Date__c = system.today();
     opp.Stagename = 'Admin Processing';
     opp.Contract_Price__c = 12.00;
     opp.CloseDate = system.today();
     opp.Panel_Type__c = 'test';
     opp.Inverter_s__c = 'test';
     opp.Panel_Wattage__c =23;
     opp.Project_Manager__c = c.id;
     opp.Jurisdiction__c  ='test';
     opp.Received_From_Jurisdiction_Processing__c = system.today();
     insert opp;
     
     
     Apexpages.StandardController stdController = new Apexpages.StandardController(opp);
     ApexPages.currentPage().getParameters().put('id', opp.id);
     ProejctPdf ppdf = new ProejctPdf(stdController);
     
   }
 }