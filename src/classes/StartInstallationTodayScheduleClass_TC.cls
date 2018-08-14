@IsTest
Public class StartInstallationTodayScheduleClass_TC{
    static testMethod void scheduleBatch(){
        insert new PremierSettings__c(DisableAutoEmailsDate__c = Date.newInstance(2016, 12, 31));
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
        
        Opportunity Op = New opportunity();
        Op.AccountId = Acc.id;
        Op.CloseDate = system.today();
        Op.Leasing_Company__c = Leasing.Id;
        Op.Name = 'APS-Install Only';
        Op.StageName = 'Admin Processing';
        Op.Scheduled_Install_Date__c = system.today();
        Op.Install_Completed_Date__c = system.today();
        insert Op;
        
        String query = 'select id, name, Install_Completed_Date__c, Stage_Check_Formula__c,Leasing_Company__c, Leasing_Company_Alert__c, AccountId from opportunity where Scheduled_Install_Date__c = Today';

        Test.startTest();
        Database.executeBatch(new StartInstallationToday(query),5);
        Test.stopTest();
       /* 
        StartInstallationTodayScheduleClass sh1 = new StartInstallationTodayScheduleClass();
        String sch = '0 0 23 * * ?';
        system.schedule('Start Installation', sch, sh1);
        */
    }

    static testMethod void scheduleBatchOldInstallDate(){
        insert new PremierSettings__c(DisableAutoEmailsDate__c = Date.newInstance(2016, 12, 31));
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
        
        Opportunity Op = New opportunity();
        Op.AccountId = Acc.id;
        Op.CloseDate = system.today();
        Op.Leasing_Company__c = Leasing.Id;
        Op.Name = 'APS-Install Only';
        Op.StageName = 'Admin Processing';
        Op.Scheduled_Install_Date__c = system.today();
        Op.Install_Completed_Date__c = Date.newInstance(2016,11,11);
        insert Op;
        
        String query = 'select id, name, Install_Completed_Date__c, Stage_Check_Formula__c,Leasing_Company__c, Leasing_Company_Alert__c, AccountId from opportunity where Scheduled_Install_Date__c = Today';
        
        Test.startTest();
        Database.executeBatch(new StartInstallationToday(query),5);
        Test.stopTest();
       /* 
        StartInstallationTodayScheduleClass sh1 = new StartInstallationTodayScheduleClass();
        String sch = '0 0 23 * * ?';
        system.schedule('Start Installation', sch, sh1);
        */
    }
    
    static testMethod void scheduleTest() {
        StartInstallationTodayScheduleClass sh1 = new StartInstallationTodayScheduleClass();
        String sch = '0 0 23 * * ?';
        try {
          system.schedule('Start Installation', sch, sh1);
        } catch(Exception e) {
          system.debug(e.getMessage());
        }
    }

}