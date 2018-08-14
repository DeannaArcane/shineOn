/*
Daily Run
*/
global class StartInstallationTodayScheduleClass Implements Schedulable
  {
      global void execute(SchedulableContext sc)
         {
              String query = 'select id, name, Leasing_Company__c,Stage_Check_Formula__c,Leasing_Company_Alert__c, AccountId from opportunity where Scheduled_Install_Date__c = Today';
              Database.executeBatch(new StartInstallationToday(query),5);
         }
  }