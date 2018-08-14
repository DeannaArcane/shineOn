global class StartInstallationToday implements Database.Batchable<sObject>{
     
     global final String query;
     
     global StartInstallationToday(String q){
          Query=q;
     }  
           
     global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator(query);
     }
     
     global void execute(Database.BatchableContext BC, List<Opportunity> Opps)
     {
           List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Set<Id> ids = New Set<Id>();
            Set<Id> PersonIds = New Set<Id>();
            for(Opportunity oppRec : Opps)
            {
                ids.add(oppRec.Leasing_Company__c);
                if(oppRec.AccountId != Null)
                PersonIds.add(oppRec.AccountId);
            }
           Map<id,Account> accRecords = new Map<id,Account>([select id,Email_Address__c,Secondary_Email_CC__c,name,billingstatecode from account where id In: ids]);
           Map<id,Account> accEmails = new Map<id,Account>([select id,Email_Address__c,Secondary_Email_CC__c,name,billingstatecode from account where id In: PersonIds AND IsPersonAccount = true]);
           System.debug(accRecords+'Surya123');
           System.debug(accEmails+'Surya1234');
           PremierSettings__c ps = PremierSettings__c.getOrgDefaults();
           for(Opportunity op : Opps){
                if (op.Install_Completed_Date__c == null || ps.DisableAutoEmailsDate__c == null || op.Install_Completed_Date__c > ps.DisableAutoEmailsDate__c){
                    
                  String OppUrl = '<a href="'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+op.Id+'">'+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+op.Id;
                  String PEmail = accEmails.get(op.AccountId).Email_Address__c;
                  If(PEmail != Null && accRecords.get(op.Leasing_Company__c) !=  null && op.Leasing_Company_Alert__c == true && op.Stage_Check_Formula__c != true )
                  {
                      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                      List<String> sendTo = new List<String>();
                      if(PEmail != Null)
                          sendTo.add(PEmail);
                      mail.setToAddresses(sendTo);
                      mail.setSubject(op.Name+' : Confirmed Install Date');
                      String body = 'You’re scheduled to start installation today. We want to ensure 100% customer satisfaction, if at any time you have any questions or concerns please reach out to us at 855-248-8884. Also, your project manager will be reaching out to you periodically throughout your installation.';
                      mail.setHtmlBody(body);
                      mail.setSenderDisplayName('Premier Solar');
                      mails.add(mail);
                  }
                }
          }
          
          if(!mails.IsEmpty()) {
            if(!Test.isRunningTest())
              Messaging.sendEmail(mails);
          }
     }    
     
     global void finish(Database.BatchableContext BC){
     }   
}