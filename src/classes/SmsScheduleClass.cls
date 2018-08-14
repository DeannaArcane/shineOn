/*
Every 2 days Run
*/
global class SmsScheduleClass Implements Schedulable
  {
     global void execute(SchedulableContext sc)
     {
       /*string T = system.Now().adddays(2).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
       string TT = system.Now().adddays(3).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
       String dat = system.Now().adddays(2).format('yyyy-MM-dd');
       String query = 'select id, Account.Text_SMS__c,Stage_Check_Formula__c,Account.Phone, Account.FirstName, Account.LastName, Leasing_Company__r.name, Scheduled_MPU_Derate__c,Scheduled_Install_Date__c,QC_Scheduled_Date__c,PPT_Scheduled_Date__c,AHJ_Inspection_Scheduled__c,Scheduled_Time__c'
                     +' from opportunity where  Leasing_Company__c != null'
                     +' and ((Scheduled_Time__c >='+T+' and Scheduled_Time__c <'+TT+')'+                                
                              +' OR QC_Scheduled_Date__c ='+dat
                              +' OR Scheduled_Install_Date__c = '+dat
                              +' OR PPT_Scheduled_Date__c = '+dat
                              +' OR AHJ_Inspection_Scheduled__c = '+dat
                              +' OR Scheduled_MPU_Derate__c= '+dat
                           +')';
                           
                           If(Test.isrunningtest()){
              query = query + ' limit 5';
          }
          
          Database.executeBatch(new SMSSchedule(query),5);
          */
     }
  }