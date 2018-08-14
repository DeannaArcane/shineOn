@isTest(seeAllData=true) 
public class AHJScheduleEmailAlertsTest{
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
        acc1.name = 'Leasing Company - 000';
        acc1.Email_Address__c = 'test@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company - 000';
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
       
        //String q = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name from Opportunity where Install_Completed_Date__c != null and (QC_Scheduled_Date__c = null OR PPT_Scheduled_Date__c = null OR AHJ_Inspection_Scheduled__c = null) limit 5';
        //Id batchInstanceId = Database.executeBatch(new AHJScheduleEmailAlerts(q,'Daily')); 
    }
    
    static testMethod void test1() {    
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
        acc1.name = 'Leasing Company 001';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 001';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 001';
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
        
        //String q1 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name from Opportunity where Failed_Inspection__c != null and AHJ_Inspection_Approved__c = null limit 5';
        //Id batchInstanceId1 = Database.executeBatch(new AHJScheduleEmailAlerts(q1, 'Every 3 days'));
    }
    static testMethod void test2() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname02';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 002';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 002';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 002';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 002';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
        //String q2 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Customer_Signature_Required__c, Requested_Signature_Date__c, Permits_Submitted__c from Opportunity where Customer_Signature_Required__c = True And Requested_Signature_Date__c = null AND Permits_Submitted__c = null limit 5';
        //Id batchInstanceId1 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q2, 'CustomerSignature'));
    }
    static testMethod void test3() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname 003';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 003';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 003';
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
        op.Name = 'test name 003';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
       
        //String q3 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, QC_Scheduled_Date__c, QA_Reviewed_Date__c from Opportunity where QA_Reviewed_Date__c = null AND QC_Scheduled_Date__c != null limit 5';
        //Id batchInstanceId2 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q3, 'QAReviewd')); 
    }     
        
    static testMethod void test4() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname004';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 004';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 004';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 004';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 004';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
        //String q4 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, QA_Approved_Date__c, QC_Grade__c from Opportunity where QC_Grade__c = null AND QA_Approved_Date__c != null limit 5';
        //Id batchInstanceId3 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q4, 'QCGrade')); 
    }
    static testMethod void test5() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname 005';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 005';
        acc1.Email_Address__c = 'test1@gmail.com';
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
        c.LastName = 'Test 005';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
     }
    static testMethod void test6() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname 006';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 006';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 006';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 006';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 006';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
        //String q6 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Status_Update_Reported__c, FSD_Scheduled_Date__c from Opportunity where FSD_Scheduled_Date__c < Today AND Status_Update_Reported__c = null limit 5';
        //Id batchInstanceId5 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q6, 'StatusUpdate')); 
    }
    static testMethod void test7() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 007';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 007';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 007';
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
        op.Name = 'test name 007';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
        //String q13 = 'select id, Name, Utility_Company__c, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Projected_Permit_Approval_Date_f__c,Tentative_Install_Date__c from Opportunity where Projected_Permit_Approval_Date_f__c != null AND Tentative_Install_Date__c = null limit 5';
        //Id batchInstanceId12 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q13, 'Tentative'));
    }
    static testMethod void test8() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 008';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 008';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'APS001';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 008';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 008';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QC_Scheduled_Date__c  = system.today();
        op.QA_Approved_Date__c = system.today();
        op.Missing_Photos__c = true;
        op.FSD_Scheduled_Date__c = system.today().addDays(-1);
        
        op.Reservation_Id__c = 'test';
        insert op;
        
        //String q15 = 'select id, Name, Utility_Company__c, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Reservation_Id__c, Utility_Company__r.Name, Interconnection_Submitted__c from Opportunity where Utility_Company__r.Name = \''+'APS001'+'\' and Reservation_Id__c != null and Interconnection_Submitted__c = null limit 5';
        //Id batchInstanceId14 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q15,'APSApproval')); 
    }
    
    
    static testMethod void test9() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 009';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 009';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 009';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 009';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 009';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
       
        //String q7 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, QA_Reviewed_Date__c, QA_Approved_Date__c from Opportunity where QA_Approved_Date__c = null AND QA_Reviewed_Date__c != null limit 5';
        //Id batchInstanceId6 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q7, 'QAApproved')); 
   }
    static testMethod void test10() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 010';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 010';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 010';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 010';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 010';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q8 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, FSD_Accepted_Date__c, FSD_Scheduled_Date__c, Sent_Back_to_Leasing_Company__c from Opportunity where FSD_Accepted_Date__c != null AND FSD_Scheduled_Date__c = null AND Sent_Back_to_Leasing_Company__c != null limit 5';
        //Id batchInstanceId7 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q8, 'FSDScheduled'));
    }
    static testMethod void test11() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 011';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 011';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 011';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 011';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 011';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q9 = 'select id, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Name, FSD_Final_Findings_Reported__c, Status_Update_Reported__c from Opportunity where Status_Update_Reported__c != null AND FSD_Final_Findings_Reported__c = null limit 5';
        //Id batchInstanceId8 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q9, 'FinalFindings')); 
    }
    static testMethod void test12() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
        Test.startTest();                      
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 012';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 012';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 012';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 012';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 012';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q10 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Scheduled_Install_Date__c, Projected_Permit_Approval_Date_f__c from Opportunity where Projected_Permit_Approval_Date_f__c = null AND Scheduled_Install_Date__c = THIS_WEEK limit 5';
        //Id batchInstanceId9 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q10, 'PermitsApproval'));
    }
    static testMethod void test13() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 013';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 013';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 013';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 013';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 013';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q11 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Utility_Company__c from Opportunity where Interconnection_Submitted__c != null and Interconnection_Approved__c = null limit 5';
        //Id batchInstanceId10 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q11, 'InterconnectionApproved'));
    }
    static testMethod void test14() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 014';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 014';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 014';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 014';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 014';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q14 = 'select id, Name, Utility_Company__c, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Tentative_Install_Date__c from Opportunity where Project_Design_Complete__c != null and (HOA_Submitted__c = null OR Interconnection_Submitted__c = null) limit 5';
        //Id batchInstanceId13 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q14, 'PojectDesign'));
   }
    static testMethod void test15() {    
        RecordType rt = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Person Account'];
        RecordType rt1 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Leasing Company'];
        RecordType rt2 = [SELECT id,Name FROM RecordType WHERE SobjectType='Account' AND Name='Utility Company'];
                             
                             
        Account acc = new Account();
        acc.lastname = 'lastname1 015';
        acc.firstname = 'firstname';
        acc.Email_Address__c = 'test@gmail.com';
        acc.Phone = '9010988988';
        acc.recordTypeId= rt.id;
        acc.BillingState = 'Indiana';
        insert acc;
        
        Account acc1 = new Account();
        acc1.name = 'Leasing Company 015';
        acc1.Email_Address__c = 'test1@gmail.com';
        acc1.Phone = '9010988985';
        acc1.BillingState = 'Indiana';
        acc1.recordTypeId=rt1.id;
        insert acc1;
        
        Account acc2 = new Account();
        acc2.name = 'Utility Company 015';
        acc2.Email_Address__c = 'tes1t@gmail.com';
        acc2.Phone = '9010988984';
        acc2.recordTypeId=rt2.id;
        acc2.BillingState = 'Indiana';
        insert acc2;
        
        Contact c = new Contact();
        c.LastName = 'Test 015';
        c.Email = 'test@gmail.com';
        c.AccountId = acc2.Id;
        insert c;
    
        RecordType rt3 = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE SobjectType='opportunity' AND Name='Install Only']; 
                                 
        opportunity op = new opportunity();
        op.Name = 'test name 015';
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
        op.Customer_Signature_Required__c = true;
        op.Failed_Inspection__c = system.Today();
        op.Admin_Processing_Completed_Date__c = system.today();
        op.Install_Completed_Date__c = system.Today();
        op.Project_Manager__c = c.Id;
        op.QA_Reviewed_Date__c  = system.today();
        op.FSD_Accepted_Date__c  = system.today();
        op.Sent_Back_to_Leasing_Company__c = true;
        //op.Status_Update_Reported__c = true;
        op.Scheduled_Install_Date__c = system.today();
        op.Interconnection_Submitted__c = system.today();
        op.Received_From_Jurisdiction_Processing__c = system.today();
        op.Project_Design_Complete__c = system.today();
        insert op;
        
        //String q12 = 'select id, Name, Project_Manager__c, Project_Manager__r.Email, Project_Manager__r.Name, Received_From_Jurisdiction_Processing__c, Tentative_Install_Date__c from Opportunity where Received_From_Jurisdiction_Processing__c != null and Tentative_Install_Date__c = null limit 5';
        //Id batchInstanceId11 = Database.executeBatch(new ReadyToInstallScheduleEmailAlerts(q12, 'TentativeInstall'));
    }
 }