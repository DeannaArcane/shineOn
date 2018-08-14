@IsTest(SeeAllData = True)
Public class SendEmail_TC
{
  Public Static testmethod void unitTest()
  {
    RecordType rt = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' AND DeveloperName = 'Leasing_Company' limit 1];
    Account acc = new Account();
    acc.Name ='Last Acc';
    acc.Email_Address__c = 'test@gmail.com';
    acc.Phone = '1234567890';
    acc.BillingState = 'idaho';
    acc.recordtypeid =rt.id;
    insert acc;
    
    Contact c = new Contact();
    c.LastName = 'Test';
    c.Email = 'test1@gmail.com';
    c.AccountId = acc.Id;
    insert c;
    
    User Us = [select Id,Name,CompanyName from User where Id =: UserInfo.getUserId()  limit 1];
    
    Task Ts = New Task();
    Ts.subject = 'Test Task';
    Ts.ActivityDate = system.today();
    Ts.Status = 'completed';
    Ts.Priority = 'normal';
    Ts.WhoId = c.Id;
    Ts.OwnerId = Us.Id;
    Insert Ts;
    
    c.Email = 'Test3@gmail.com';
    Update c;
  }
}