// This test class if for SMS Trigger and DrawingsSenttoCustomerDate 
@IsTest()
Public class EmailAlert_TC {
  
    @TestSetup
    static void dataSetup() {
        insert new PremierSettings__c(DisableAutoEmailsDate__c = Date.newInstance(2016, 12, 31));
    }

    Static testmethod void unittest()
    {
        system.debug('line 242 test 1');
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='Arizona',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        Account Leasing1 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing1;

        Account Leasing2 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='Sunrun',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing2;

            Test.startTest();
        Opportunity Op = New opportunity();
        Op.AccountId = Acc.id;
        Op.CloseDate = system.today();
        Op.Leasing_Company__c = Leasing2.Id;
        Op.Name = 'Test Name';
        Op.StageName = 'Admin Processing';
        Op.Site_Audit_Completed__c = system.today();
        Op.AHJ_Inspection_Approved__c = system.today();
        Op.Permits_Approved__c= system.today();
        Op.Install_Completed_Date__c = system.today();
        Op.PTO_Received__c = system.today();
        Op.Scheduled_Install_Date__c = system.today();
        Op.Project_Design_Complete__c = system.today();
        Op.Countersign_Date__c = system.today();
        insert Op;
        
        Opportunity Op1 = New opportunity();
        Op1.AccountId = Acc.id;
        Op1.CloseDate = system.today();
        Op1.Leasing_Company__c = Leasing.Id;
        Op1.Name = 'Test Opportunity';
        Op1.StageName = 'Admin Processing';
        Op1.Project_Design_Complete__c = system.today();
        Op1.Countersign_Date__c = system.today();
        Op1.Project_Design_Complete__c = system.today();
        Op1.Drawings_Sent_To_Customer__c = system.today();
        Op1.Permits_Submitted__c = system.today();
        op1.AHJ_Inspection_Approved__c  = system.today();
        Op1.Permits_Approved__c = system.today();
        Op1.HOA_Submitted__c = system.today();
        Op1.HOA_Approval__c = system.today();
        op1.Site_Audit_Completed__c = system.today().adddays(+2);
        op1.Commissioning_Completed_Date__c = system.today().adddays(-2);
        Insert Op1;
        
       Utility.isFutureUpdate = False;
     
        op1.Site_Audit_Completed__c = system.today();
        op1.AHJ_Inspection_Approved__c = system.today();
        op1.Permits_Approved__c= system.today();
        op1.Install_Completed_Date__c = system.today();
        op1.Commissioning_Completed_Date__c = system.today();
        op1.Scheduled_Install_Date__c = system.today();
        op1.Project_Design_Complete__c = system.today();
        op1.Countersign_Date__c = system.today();
        op1.Project_Design_Complete__c = system.today().adddays(+3);
        op1.Drawings_Sent_To_Customer__c = system.today();
        op1.Permits_Submitted__c = system.today();
        op1.Permits_Approved__c = system.today();
        op1.HOA_Submitted__c = system.today();
        op1.HOA_Approval__c = system.today();
        Update Op1;  

      Test.stopTest();  
    }
    
    Static testmethod void Cusotmeralert(){
    
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        Account Leasing1 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='AZSS',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing1;
        
         Account Leasing2 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='Sunrun',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing2;
        Test.startTest();
        
        Opportunity Op1 = New opportunity();
        Op1.AccountId = Acc.id;
        Op1.CloseDate = system.today();
        Op1.Leasing_Company__c = Leasing1.Id;
        Op1.Name = 'Test Opportunity';
        Op1.StageName = 'Admin Processing';
        Op1.Project_Design_Complete__c = system.today().adddays(-2);
        Op1.Tentative_Install_Date__c = system.today().adddays(-2);
        Op1.Scheduled_Install_Date__c = system.today().adddays(-2);
        op1.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        op1.Site_Audit_Completed__c = system.today().adddays(+1);
        op1.AHJ_Inspection_Scheduled__c = system.today();
        op1.PPT_Scheduled_Date__c = system.today();
        op1.Countersign_Date__c = system.today().adddays(-1);
        op1.Install_Completed_Date__c = system.today();
        op1.Installation_Outline__c = 'Trenching';
        Insert Op1;
         
         op1.Install_Completed_Date__c = system.today().adddays(+2);
         Op1.Tentative_Install_Date__c = system.today();
         Op1.Scheduled_Install_Date__c = system.today();
         Op1.Leasing_Company__c = Leasing2.Id;
         op1.Site_Audit_Completed__c = system.today().adddays(+1);
         op1.Countersign_Date__c = system.today().adddays(+4);
         op1.PPT_Scheduled_Date__c = system.today().adddays(+2);
         Op1.Project_Design_Complete__c = system.today().adddays(+2);
         op1.AHJ_Inspection_Scheduled__c = system.today().adddays(+2);
        Update Op1;
        
        
       Opportunity Op2 = New opportunity();
        Op2.AccountId = Acc.id;
        Op2.CloseDate = system.today();
        Op2.Leasing_Company__c = Leasing1.Id;
        Op2.Name = 'Test Opportunity';
        Op2.StageName = 'cancel';
        op2.Countersign_Date__c = system.today();
        op2.Site_Audit_Completed__c = system.today();
        Insert Op2;
        op2.Site_Audit_Completed__c = system.today().adddays(-1);
        op2.Countersign_Date__c = system.today().adddays(-1);
        Update Op2;

        Opportunity Op3 = New opportunity();
        Op3.AccountId = Acc.id;
        Op3.CloseDate = system.today();
        Op3.Leasing_Company__c = Leasing2.Id;
        Op3.Name = 'Test Opportunity';
        Op3.StageName = 'Admin Processing';
        Op3.Project_Design_Complete__c = system.today().adddays(-2);
        Op3.Tentative_Install_Date__c = system.today().adddays(-2);
        Op3.Scheduled_Install_Date__c = system.today().adddays(-2);
        op3.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        op3.Site_Audit_Completed__c = system.today().adddays(+1);
        op3.AHJ_Inspection_Scheduled__c = system.today();
        op3.PPT_Scheduled_Date__c = system.today();
        op3.Countersign_Date__c = system.today().adddays(-1);
        op3.Install_Completed_Date__c = system.today();
        op3.Installation_Outline__c = 'Trenching';
        Insert Op3;
        op3.Site_Audit_Completed__c = system.today().adddays(-1);
        op3.Countersign_Date__c = system.today();
        Update Op3;
        
        Test.stopTest();
        
        
    }
    
   Static testmethod void CusotmerDrawinsApprovedalert(){
    system.debug('line 242 test 2');
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
    
    }
    
    Static testmethod void CusotmerDrawinsfrwdApprovedalert(){
    system.debug('line 242 test 3');
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        Opportunity Op2= New opportunity();
        Op2.AccountId = Acc.id;
        Op2.CloseDate = system.today();
        Op2.Leasing_Company__c = Leasing.Id;
        Op2.Name = 'Test Opportunity';
        Op2.StageName = 'Admin Processing';
        Op2.Drawings_Sent_To_Customer__c = system.today().adddays(-3);

        Op2.Project_Design_Complete__c = system.today(); 
        Insert Op2;
        
        
    }
    
 Static testmethod void  ConfirmedDateAlertToFillInstallComplete()
    {
        system.debug('line 242 test 4');
        String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        Account Leasing1 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing1;
        
        Opportunity Op1 = New opportunity();
        Op1.AccountId = Acc.id;
        Op1.CloseDate = system.today();
        Op1.Leasing_Company__c = Leasing.Id;
        Op1.Name = 'Test Opportunity';
        Op1.StageName = 'Admin Processing';
        Op1.Project_Design_Complete__c = system.today();
        Op1.Countersign_Date__c = system.today();
        Op1.Project_Design_Complete__c = system.today();
        Op1.Drawings_Sent_To_Customer__c = system.today();
        Op1.Permits_Submitted__c = system.today();
        Op1.Permits_Approved__c = system.today();
        Op1.HOA_Submitted__c = system.today();
        Op1.HOA_Approval__c = system.today();
        Op1.Scheduled_Install_Date__c = system.today();
        Insert Op1;
        /*String dat = system.Now().adddays(-2).format('yyyy-MM-dd');
              String query = 'select id, Name, Account.Name, Scheduled_Install_Date__c , Install_Completed_Date__c'
                             +' from Opportunity where Account.name != null'
                             +' and Scheduled_Install_Date__c != NUll'
                             +' and Install_Completed_Date__c = null'
                             +' and Scheduled_Install_Date__c ='+dat;
                             Database.executeBatch(new ConfirmedDateAlertToFillInstallComplete(query),5);   */
    }

    Static testmethod void CusotmerAlertStagesTest(){
    
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        Account Leasing1 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='AZSS',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing1;
        
         Account Leasing2 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='Sunrun',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing2;
        Test.startTest();
        
        Opportunity Op1 = New opportunity();
        Op1.AccountId = Acc.id;
        Op1.CloseDate = system.today();
        Op1.Leasing_Company__c = Leasing1.Id;
        Op1.Name = 'Test Opportunity';
        Op1.StageName = 'Admin Processing';
        Op1.Project_Design_Complete__c = system.today().adddays(-2);
        Op1.Tentative_Install_Date__c = system.today().adddays(-2);
        Op1.Scheduled_Install_Date__c = system.today().adddays(-2);
        op1.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        op1.Site_Audit_Completed__c = system.today().adddays(+1);
        op1.AHJ_Inspection_Scheduled__c = system.today();
        op1.PPT_Scheduled_Date__c = system.today();
        op1.Countersign_Date__c = system.today().adddays(-1);
        op1.Install_Completed_Date__c = system.today();
        op1.Installation_Outline__c = 'Trenching';
        op1.AHJ_Inspection_Approved__c = system.today();
        Insert Op1;
         
         op1.Install_Completed_Date__c = system.today().adddays(+2);
         Op1.Tentative_Install_Date__c = system.today();
         Op1.Scheduled_Install_Date__c = system.today();
         Op1.Leasing_Company__c = Leasing2.Id;
         op1.Site_Audit_Completed__c = system.today().adddays(+1);
         op1.Countersign_Date__c = system.today().adddays(+4);
         op1.PPT_Scheduled_Date__c = system.today().adddays(+2);
         Op1.Project_Design_Complete__c = system.today().adddays(+2);
         op1.AHJ_Inspection_Scheduled__c = system.today().adddays(+2);
        Update Op1;
        
        
       Opportunity Op2 = New opportunity();
        Op2.AccountId = Acc.id;
        Op2.CloseDate = system.today();
        Op2.Leasing_Company__c = Leasing1.Id;
        Op2.Name = 'Test Opportunity';
        Op2.StageName = 'Cancel';
        op2.Countersign_Date__c = system.today();
        op2.Site_Audit_Completed__c = system.today();
        op2.AHJ_Inspection_Approved__c = system.today();
        op2.Commissioning_Completed_Date__c = system.today();
        Insert Op2;
        op2.Site_Audit_Completed__c = system.today().adddays(-1);
        op2.Countersign_Date__c = system.today().adddays(-1);
        Update Op2;

        Opportunity Op3 = New opportunity();
        Op3.AccountId = Acc.id;
        Op3.CloseDate = system.today();
        Op3.Leasing_Company__c = Leasing2.Id;
        Op3.Name = 'Test Opportunity';
        Op3.StageName = 'Admin Processing';
        Op3.Project_Design_Complete__c = system.today().adddays(-2);
        Op3.Tentative_Install_Date__c = system.today().adddays(-2);
        Op3.Scheduled_Install_Date__c = system.today().adddays(-2);
        op3.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        op3.Site_Audit_Completed__c = system.today().adddays(+1);
        op3.AHJ_Inspection_Scheduled__c = system.today();
        op3.PPT_Scheduled_Date__c = system.today();
        op3.Countersign_Date__c = system.today().adddays(-1);
        op3.Install_Completed_Date__c = system.today();
        op3.Installation_Outline__c = 'Trenching';
        op3.AHJ_Inspection_Approved__c = system.today();
        Insert Op3;
        op3.Site_Audit_Completed__c = system.today().adddays(-1);
        op3.Countersign_Date__c = system.today();
        Update Op3;
        
        Test.stopTest();
        
        
    }

    Static testmethod void CusotmerDrawinsApprovedalert2(){
    system.debug('line 261 test NEW');
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;
        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        Opportunity Op2= New opportunity();
        Op2.AccountId = Acc.id;
        Op2.CloseDate = system.today();
        Op2.Leasing_Company__c = Leasing.Id;
        Op2.Name = 'Test Opportunity';
        Op2.StageName = 'Admin Processing';
        Op2.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        Op2.Derate_MPU__c = 'SES';
        Op2.Received_From_Underwriting__c = system.Today().adddays(+3);
        Op2.AHJ_Jurisdiction__c = TestDataUtility.jurisdictionContact.Id;
        Op2.Permits_Submitted__c = system.today();
        Op2.Permit_Number__c = '12345';
        Op2.Permits_Approved__c = system.today();
        Op2.ISA_Granted__c = true;
        Op2.Jurisdiction_Completed_Date__c = system.today();
        Op2.MPU_Derate_Material_Ordered__c = system.today();
        Op2.Scheduled_MPU_Derate__c = system.today();
        Op2.Derate_MPU_Completed__c = system.today(); 
        Op2.Project_Design_Complete__c = system.today(); 
        Op2.Commissioning_Completed_Date__c = system.today().addDays(1);
        Insert Op2;
        Op2.StageName = 'Ready To Install';
        update op2;
        //String query = 'select id, Name, Account.Name, Account.PersonEmail,Stage_Check_Formula__c,Leasing_Company__r.name, Account.Email_Address__c, Drawings_Sent_To_Customer__c, Drawings_Approved_By_Customer__c, Project_Manager__r.Email, Project_Manager__r.Name from Opportunity where Account.name != null AND Drawings_Sent_To_Customer__c != NUll and Drawings_Approved_By_Customer__c = null and Leasing_Company__r.name != \'SR-Install Only PERMITTED\'';
          //    Database.executeBatch(new DrawingsSenttoCustomerDate(query),5);
    
    }

    Static testmethod void CusotmerDrawinsApprovedalert3(){
    system.debug('line 261 test NEW 2');
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;

      
        
        Account Leasing2 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'TX',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing2;
        
        Opportunity Op3= New opportunity();
        Op3.AccountId = Acc.id;
        Op3.CloseDate = system.today();
        Op3.Leasing_Company__c = Leasing2.Id;
        Op3.Name = 'Test Opportunity';
        Op3.StageName = 'Admin Processing';
        Op3.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        Op3.Derate_MPU__c = 'SES';
        Op3.Received_From_Underwriting__c = system.Today().adddays(+3);
        Op3.AHJ_Jurisdiction__c = TestDataUtility.jurisdictionContact.Id;
        Op3.Permits_Submitted__c = system.today();
        Op3.Permit_Number__c = '12345';
        Op3.Permits_Approved__c = system.today();
        Op3.ISA_Granted__c = true;
        Op3.Jurisdiction_Completed_Date__c = system.today();
        Op3.MPU_Derate_Material_Ordered__c = system.today();
        Op3.Scheduled_MPU_Derate__c = system.today();
        Op3.Derate_MPU_Completed__c = system.today(); 
        Op3.Project_Design_Complete__c = system.today(); 
        //Op2.Commissioning_Completed_Date__c = system.today().addDays(1);
        Insert Op3;

        Utility.isFutureUpdate = false;
        Op3.StageName = 'Ready To Install';
        update op3;
    }

    Static testmethod void UpdateTests(){
    system.debug('line Tests test');
    TriggerHandler__c tc = new TriggerHandler__c();
     tc.Name = 'EmailAlertToCusotmer';
     tc.isActive__c = true;
     tc.isInsert__c = true;
     tc.isUpdate__c = true;
     tc.isAfter__c = true;
     insert tc;
     tc = new TriggerHandler__c();
     tc.Name = 'EmailAlert';
     tc.isActive__c = true;
     insert tc;
     
   
    String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account Acc = new Account(
                          RecordTypeID=RecTypeId,
                          LastName='Test Account',
                          FirstName = 'KickName',
                          PersonMailingStreet='test',
                          PersonMailingPostalCode='12345',
                          PersonMailingCity='SFO',
                          PersonMailingStateCode='NY',
                          PersonMailingCountryCode='US',
                          PersonOtherStreet='test',
                          PersonOtherPostalCode='12345',
                          PersonOtherCity='SFO',
                          PersonOtherStateCode='NY',
                          PersonOtherCountryCode='US',
                          BillingStateCode = 'NY',
                          PersonEmail='test@yahoo.com',
                          Phone = '9010988985',
                          Email_Address__c = 'test@yahoo.com',
                          Text_SMS__c = true,
                          PersonHomePhone='1234567',
                          PersonMobilePhone='12345678'
                        );
        insert Acc;
        
        String RecTypeLea= [select Id from RecordType where (Name='Leasing Company') and (SobjectType='Account')].Id;

        Account Leasing = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='APS-Install Only',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'AZ',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing;
        
        
        Opportunity Op2= New opportunity();
        Op2.AccountId = Acc.id;
        Op2.CloseDate = system.today();
        Op2.Leasing_Company__c = Leasing.Id;
        Op2.Name = 'Test Opportunity';
        Op2.StageName = 'Admin Processing';
        Op2.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        Op2.Derate_MPU__c = 'SES';
        Op2.Received_From_Underwriting__c = system.Today().adddays(+3);
        Op2.AHJ_Jurisdiction__c = TestDataUtility.jurisdictionContact.Id;
        Op2.Permits_Submitted__c = system.today();
        Op2.Permit_Number__c = '12345';
        Op2.Permits_Approved__c = system.today();
        Op2.ISA_Granted__c = true;
        Op2.Jurisdiction_Completed_Date__c = system.today();
        Op2.MPU_Derate_Material_Ordered__c = system.today();
        Op2.Scheduled_MPU_Derate__c = system.today();
        Op2.Derate_MPU_Completed__c = system.today(); 
        Op2.Project_Design_Complete__c = system.today(); 
        Op2.Site_Audit_Completed__c = system.today();
        op2.AHJ_Inspection_Scheduled__c = system.today();
        op2.Tentative_Install_Date__c = system.today();
        Op2.Scheduled_Install_Date__c = system.today();
        op2.PPT_Scheduled_Date__c = system.today();
        op2.Install_Completed_Date__c = system.today();
        op2.Installation_Outline__c = 'Trenching';
        op2.AHJ_Inspection_Approved__c = system.today();
        op2.Commissioning_Completed_Date__c = system.today();
        //Op2.Commissioning_Completed_Date__c = system.today().addDays(1);
        Insert Op2;

        Utility.isFutureUpdate = false;
        op2.Commissioning_Completed_Date__c = system.today().addDays(2);
        op2.AHJ_Inspection_Approved__c = system.today().addDays(2);
        op2.Install_Completed_Date__c = system.today().addDays(2);
        op2.Permits_Approved__c = system.today().addDays(2);
        op2.Project_Design_Complete__c = system.today().addDays(2);
        op2.PPT_Scheduled_Date__c = system.today().addDays(2);
        op2.Tentative_Install_Date__c = system.today().addDays(2);
        Op2.Scheduled_Install_Date__c = system.today().adddays(2);
        op2.AHJ_Inspection_Scheduled__c = system.today().addDays(2);
        Op2.Site_Audit_Completed__c = system.today().addDays(2);
        Op2.StageName = 'Ready To Install';
        update op2;

        Account Leasing2 = new Account(
                          RecordTypeID = RecTypeLea,
                          Name='SR-Install Only PERMITTED',
                          BillingStreet='test@yahoo.com',
                          BillingPostalCode='12345',
                          BillingCity='SFO',
                          BillingStateCode = 'TX',
                          BillingCountryCode= 'US',
                          Email_Address__c ='test@yahoo.com',
                          Secondary_Email_CC__c = 'test@gmail.com',
                          Phone='1234567'
                          );
        insert Leasing2;
        
        Opportunity Op3= New opportunity();
        Op3.AccountId = Acc.id;
        Op3.CloseDate = system.today();
        Op3.Leasing_Company__c = Leasing2.Id;
        Op3.Name = 'Test Opportunity';
        Op3.StageName = 'Admin Processing';
        Op3.Drawings_Sent_To_Customer__c = system.today().adddays(-2);
        Op3.Derate_MPU__c = 'SES';
        Op3.Received_From_Underwriting__c = system.Today().adddays(+3);
        Op3.AHJ_Jurisdiction__c = TestDataUtility.jurisdictionContact.Id;
        Op3.Permits_Submitted__c = system.today();
        Op3.Permit_Number__c = '12345';
        Op3.Permits_Approved__c = system.today();
        Op3.ISA_Granted__c = true;
        Op3.Jurisdiction_Completed_Date__c = system.today();
        Op3.MPU_Derate_Material_Ordered__c = system.today();
        Op3.Scheduled_MPU_Derate__c = system.today();
        Op3.Derate_MPU_Completed__c = system.today(); 
        Op3.Project_Design_Complete__c = system.today(); 
        Op3.Site_Audit_Completed__c = system.today();
        op3.AHJ_Inspection_Scheduled__c = system.today();
        op3.Tentative_Install_Date__c = system.today();
        Op3.Scheduled_Install_Date__c = system.today();
        op3.PPT_Scheduled_Date__c = system.today();
        op3.Install_Completed_Date__c = system.today();
        op3.Installation_Outline__c = 'Trenching';
        op3.AHJ_Inspection_Approved__c = system.today();
        op3.Commissioning_Completed_Date__c = system.today();
        //Op2.Commissioning_Completed_Date__c = system.today().addDays(1);
        Insert Op3;

        Utility.isFutureUpdate = false;
        op3.Commissioning_Completed_Date__c = system.today().addDays(2);
        op3.AHJ_Inspection_Approved__c = system.today().addDays(2);
        op3.Install_Completed_Date__c = system.today().addDays(2);
        op3.Permits_Approved__c = system.today().addDays(2);
        op3.Project_Design_Complete__c = system.today().addDays(2);
        op3.PPT_Scheduled_Date__c = system.today().addDays(2);
        op3.Tentative_Install_Date__c = system.today().addDays(2);
        Op3.Scheduled_Install_Date__c = system.today().adddays(2);
        op3.AHJ_Inspection_Scheduled__c = system.today().addDays(2);
        Op3.Site_Audit_Completed__c = system.today().addDays(2);
        Op3.StageName = 'Ready To Install';
        update op3;
    }
 
 
 
}