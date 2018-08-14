@isTest(seeAllData = false)
private class DropboxControllerTest
{
    /*static testmethod void myUnitTest()
    {
        
        RecordType personRecordType = [select id, Name from RecordType where DeveloperName = 'PersonAccount'];
        Account ac = new Account(FirstName='Apostle', Lastname = 'Tech 01', BillingState = 'Louisiana', RecordTypeId = personRecordType.Id);
        insert ac;
        
        RecordType leasingRecordType = [select id, Name from RecordType where DeveloperName = 'Leasing_Company'];
        Account acLeasing = new Account(Name='Leasing Company 01',BillingState = 'Louisiana', Email_Address__c = 'test@gmail.com', RecordTypeId = leasingRecordType.Id);
        insert acLeasing;
        
        Contact c = new Contact(FirstName = 'Test', LastName='Test', AccountId = acLeasing.Id);
        insert c;
        
        RecordType utilityRecordType = [select id, Name from RecordType where DeveloperName = 'Utility_Company'];
        Account acUtility = new Account(Name='Utility Company 01',BillingState = 'Louisiana', RecordTypeId = utilityRecordType.Id);
        insert acUtility; 
        
        Opportunity op = new Opportunity (Name='Opportunity', Job_Num__c = 'AZ-11000', AccountId = ac.Id, Leasing_Company__c = acLeasing.Id, Utility_Company__c = acUtility.Id, stageName = 'Admin Processing',closeDate = system.today());
        insert op;
        //public string accessToken = 'GScS3PuMywcAAAAAAAADojeQKRFyAeCnUE33nJZLwf62-CUZjEbLWT1zZHchpQay';
        List<Document> document  = [select id, Name, Body, DeveloperName from Document where DeveloperName ='QA_Document' limit 1];
        
        Task t = new Task(subject='Call', whoId= c.Id,  QA__c = true, Priority='High', OwnerId = UserInfo.getUserId(), status = 'Open'); 
        insert t;  
        
        DropboxController dc = new DropboxController();
        delete op;
    }*/
    //Create common test data
    @TestSetup static void loadData(){
        //Create trigger handler record
        TriggerHandler__c handler = new TriggerHandler__c();
        handler.name = 'createDropboxFolders';
        handler.IsActive__c = true;
        handler.IsInsert__c = false;
        handler.IsUpdate__c = false;
        handler.IsBefore__c = false;
        handler.IsAfter__c = true;
        handler.IsDelete__c = true;
        insert handler;
        
        RecordType personRecordType = [select id, Name from RecordType where DeveloperName = 'PersonAccount'];
        Account ac = new Account(FirstName='Apostle', Lastname = 'Tech 01', BillingState = 'Louisiana', RecordTypeId = personRecordType.Id);
        insert ac;
        
        RecordType leasingRecordType = [select id, Name from RecordType where DeveloperName = 'Leasing_Company'];
        Account acLeasing = new Account(Name='Leasing Company 01',BillingState = 'Louisiana', Email_Address__c = 'test@gmail.com', RecordTypeId = leasingRecordType.Id);
        insert acLeasing;
        
        Contact c = new Contact(FirstName = 'Test', LastName='Test', AccountId = acLeasing.Id);
        insert c;
        
        RecordType utilityRecordType = [select id, Name from RecordType where DeveloperName = 'Utility_Company'];
        Account acUtility = new Account(Name='Utility Company 01',BillingState = 'Louisiana', RecordTypeId = utilityRecordType.Id);
        insert acUtility; 
        
        Opportunity op = new Opportunity (Name='Opportunity', Job_Num__c='AZ-11000', AccountId = ac.Id, Leasing_Company__c = acLeasing.Id, Utility_Company__c = acUtility.Id, stageName = 'Admin Processing',closeDate = system.today());
        insert op;
        
        List<Document> document  = [select id, Name, Body, DeveloperName from Document where DeveloperName ='QA_Document' limit 1];
        
        Task t = new Task(subject='Call', whoId= c.Id,  QA__c = true, Priority='High', OwnerId = UserInfo.getUserId(), status = 'Open'); 
        insert t; 
    }
    
    /*
*This method is used to test whether folders are created successfully in DropBox.
*/    
    @isTest static void TestDropboxFolderCreationSuccess(){ 
		List<TriggerHandler__c> handlerLst = [select id,name,isUpdate__c from TriggerHandler__c WHERE name = 'createDropboxFolders'];
        handlerLst[0].IsUpdate__c = true;
        update handlerLst;
        Test.startTest();  
        DropBoxMockResponse.serviceStatus = 'Success';
        Test.setMock(HttpCalloutMock.class, new DropBoxMockResponse()); 
        List<Opportunity> oppLst = [select id,name from Opportunity where name='Opportunity'];
        update oppLst;
        Test.stopTest();
    }
     /*
*This method is used to test whether folders are created successfully in DropBox.
*/    
    @isTest static void TestDropboxFolderCreationOnOpptyInsert(){ 
		List<TriggerHandler__c> handlerLst = [select id,name,isUpdate__c from TriggerHandler__c WHERE name = 'createDropboxFolders'];
        handlerLst[0].Isinsert__c = true;
        update handlerLst;
         RecordType personRecordType = [select id, Name from RecordType where DeveloperName = 'PersonAccount'];
        Account ac = new Account(FirstName='Apostle', Lastname = 'Tech02', BillingState = 'Arizona', RecordTypeId = personRecordType.Id);
        insert ac;
        
        RecordType leasingRecordType = [select id, Name from RecordType where DeveloperName = 'Leasing_Company'];
        Account acLeasing = new Account(Name='Leasing Company 02',BillingState = 'Arizona', Email_Address__c = 'test@gmail.com', RecordTypeId = leasingRecordType.Id);
        insert acLeasing;
        
        Contact c = new Contact(FirstName = 'Test1', LastName='Test1', AccountId = acLeasing.Id);
        insert c;
        
        RecordType utilityRecordType = [select id, Name from RecordType where DeveloperName = 'Utility_Company'];
        Account acUtility = new Account(Name='Utility Company 02',BillingState = 'Arizona', RecordTypeId = utilityRecordType.Id);
        insert acUtility; 

        Test.startTest();  
        DropBoxMockResponse.serviceStatus = 'Success';
        Test.setMock(HttpCalloutMock.class, new DropBoxMockResponse()); 
      	Opportunity op = new Opportunity (Name='Opportunity', Job_Num__c='AZ-11000', AccountId = ac.Id, Leasing_Company__c = acLeasing.Id, Utility_Company__c = acUtility.Id, stageName = 'Admin Processing',closeDate = system.today());
        insert op;
        Test.stopTest();
    }
       @isTest static void TestDropboxFolderDeletionSuccess(){ 
        Test.startTest();  
        DropBoxMockResponse.serviceStatus = 'Success';
        Test.setMock(HttpCalloutMock.class, new DropBoxMockResponse()); 
        List<Opportunity> oppLst = [select id,name from Opportunity where name='Opportunity'];
        delete oppLst;
        Test.stopTest();
    }
      
    /*
*This method is used to test whether folders aren't created successfully in Box.
*/    
    @isTest static void TestBatchBoxFolderCreationFailure(){
      	List<TriggerHandler__c> handlerLst = [select id,name,isUpdate__c from TriggerHandler__c WHERE name = 'createDropboxFolders'];
        handlerLst[0].IsUpdate__c = true;
        update handlerLst;
        Test.startTest();  
        DropBoxMockResponse.serviceStatus = 'Failure';
        Test.setMock(HttpCalloutMock.class, new DropBoxMockResponse()); 
        List<Opportunity> oppLst = [select id,name from Opportunity where name='Opportunity'];
        update oppLst;
        Test.stopTest();
    }
    /*
*Callout Service failure.
*/    
    @isTest static void TestBatchBoxFolderCreationServiceFailure(){
		List<TriggerHandler__c> handlerLst = [select id,name,isUpdate__c from TriggerHandler__c WHERE name = 'createDropboxFolders'];
        handlerLst[0].IsUpdate__c = true;
        update handlerLst;
        Test.startTest();  
        DropBoxMockResponse.serviceStatus = 'ServiceFailure';
        Test.setMock(HttpCalloutMock.class, new DropBoxMockResponse()); 
        List<Opportunity> oppLst = [select id,name from Opportunity where name='Opportunity'];
        update oppLst;
        Test.stopTest();
    }
    
}