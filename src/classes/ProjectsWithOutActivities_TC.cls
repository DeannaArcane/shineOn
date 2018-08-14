@isTest(seeAllData=true) 
public class ProjectsWithOutActivities_TC{
    static testMethod void test() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 004';
        acc1.Email_Address__c = 'test@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 005';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name';
        op.RecordTypeId = rt3.id;
        op.AccountId = acc.id;
        op.Lease_Id__c = 'test';
        op.Contract_Price__c = 233;
        op.Received_All_Paperwork__c = system.today();
        op.Number_Of_Panels__c = 45;
        op.Panel_Wattage__c = 12;
        op.Important_Details__c = 'test';
        op.Inverter_Manufacturer__c = 'test';
        op.CloseDate = system.today();
        op.StageName = 'Admin Processing';
        op.Utility_Company__c = acc2.id;
        op.Leasing_Company__c = acc1.id;
        op.Panel_Type__c = 'test';
        op.Inverter_s__c = 'test';
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        insert op;
        
        User Us = [Select Id, Name from User where Id =: UserInfo.getUserId()];
       
        Task Ts = New Task();
        Ts.subject = 'Test Task';
        Ts.ActivityDate = system.today().adddays(-70);
        Ts.Status = 'completed';
        Ts.Priority = 'normal';
        Ts.WhatId = op.Id;
        Ts.OwnerId = Us.Id;
        
        //String q = 'select id, name from opportunity limit 1';
        //Id batchInstanceId = Database.executeBatch(new ProjectsWithOutActivities(q), 5); 
         
    }
 }