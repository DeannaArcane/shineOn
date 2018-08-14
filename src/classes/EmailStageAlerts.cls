// TestClass:EmailAlert_TC

public Class EmailStageAlerts{

    public static void EmailAlert(List<Opportunity> Opps) {
    
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<id> ids = new Set<id>();
        Set<Id> PersonIds = New Set<Id>();

        for(Opportunity oppRec : Opps) {
            
            // gather ids to query accounts
            if (oppRec.Leasing_Company__c <> null) ids.add(oppRec.Leasing_Company__c);
            if (oppRec.AccountId <> Null) PersonIds.add(oppRec.AccountId);            

        }

        Map<id,Account> accRecords = new Map<id,Account>([select id,Email_Address__c,Secondary_Email_CC__c,name,billingstatecode from account where id In: ids]);
        Map<id,Account> accEmails = new Map<id,Account>([select id,Email_Address__c,PersonContactId,Secondary_Email_CC__c,name,billingstatecode from account where id In: PersonIds AND IsPersonAccount = true]);
        
        for(Opportunity op : Opps) {

            Account pAccount = accEmails.get(op.AccountId);
            String pEmail = pAccount.Email_Address__c;
            String pContactId = pAccount.PersonContactId;
            String pName = pAccount.Name;
            

            // Only send emails if enabled for this opp and if Install Completed Date is after the disable date
            if (!op.SkipCustomerProjectEmails__c && pEmail != null && op.Stage_Check_Formula__c != true){
            
                List<String> sendTo = new List<String>();
                sendTo.add(pEmail);
                
                Opportunity old = New Opportunity();
               
                // Tentative/Confirmed Install Date Alert to Customer
                if (op.Scheduled_Install_Date__c != null){

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
                    List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                    lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Project_Tentative_Install_Update'];
                    
                    if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                        
                        mail.setToAddresses(sendTo);
                        mail.saveAsActivity = false;
                        mail.setTargetObjectId(pContactId);
                        mail.setTemplateId(lstEmailTemplates[0].Id);
                        mail.setWhatId(op.id);
                        mail.setSenderDisplayName('Premier Solar');
                        mails.add(mail);
                        
                    }

                }
                
                //AHJ Inspection Scheduled Customer Alert
                if (op.AHJ_Inspection_Scheduled__c!= null) {   

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String body1 ='';
                    String AHJDate = op.AHJ_Inspection_Scheduled__c.month()+'/'+op.AHJ_Inspection_Scheduled__c.day()+'/'+op.AHJ_Inspection_Scheduled__c.Year();
                    
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Drawings Approved By Customer Moving Further Update');
                    body1 = 'Dear ' + pName + ',<br/> <br/>A tech from your local jurisdiction will be coming out on '+AHJDate +' to inspect your solar system. Please make sure the main panel is accessible, the back gate is unlocked if necessary, and all animals are put away.<br/><br/>Please direct any questions you have to cs@premiersolar.com';
                    mail.setHtmlBody(body1);
                    mail.setSenderDisplayName('Premier Solar');
                    mails.add(mail); 
                 
                }
                
                //PPT Scheduled Date Customer Date Alert
                if (op.PPT_Scheduled_Date__c!= null ) {        

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String body1 ='';
                    String PTTDATE = op.PPT_Scheduled_Date__c.month()+'/'+op.PPT_Scheduled_Date__c.day()+'/'+op.PPT_Scheduled_Date__c.Year();
                    
                    mail.setToAddresses(sendTo);                    
                    mail.setSubject('Site Visit for Installation Touch-Ups');
                    body1 = 'Dear ' + pName + ',<br/><br/>A tech will be comingout on '+PTTDATE+'. The visit consists of final touch-ups of your solar installation. Items that may be addressed during this visit would be replacing of broken roof tiles, patch work or conduit location review. The tech will ensure that the property is returned to the condition in which it was received prior to installation.';
                    mail.setHtmlBody(body1);
                    mail.setSenderDisplayName('Premier Solar');
                    mails.add(mail); 
                    
                }

                //===============================================
                //Leasing Company Emails:                
                //===============================================
                if (op.Leasing_Company__c != null && accRecords.get(op.Leasing_Company__c) != null  && op.Leasing_Company_Alert__c == true) {
                    
                    Account leasingCo = accRecords.get(op.Leasing_Company__c);

                    /* Design Approval */
                    if ((leasingCo.name != 'SR-Install Only' 
                                && leasingCo.name != 'Sunedison' 
                                && leasingCo.name != 'SR-Install Only PERMITTED') 
                                && op.Site_Audit_Completed__c != null) {                
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Design_Approval'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                        
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }

                    /* Permitting Email Alerts */
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && op.Project_Design_Complete__c != null) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Permitting_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //Installation Update
                    if (leasingCo.name != 'SR-Install Only PERMITTED'
                                && op.Permits_Approved__c != null) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>(); 
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Installation_Update'];
            
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //City/County Inspections
                    if (op.Install_Completed_Date__c != null 
                                && ( 
                                     op.Installation_Outline__c == null 
                                     || 
                                     op.Installation_Outline__c.containsIgnoreCase('Ground Mount') != true 
                                    )
                        ) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>(); 
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'City_County_Inspections_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                                    
                    //Utility Interconnection
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && leasingCo.name != 'SR-Install Only' 
                                && op.AHJ_Inspection_Approved__c != null) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();  
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Utility_Interconnection_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //Turn It On And Start Saving(a) 
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && leasingCo.name != 'SR-Install Only' 
                                && op.Commissioning_Completed_Date__c != null) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>(); 
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'PTO_Received_Date'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //Turn It On And Start Saving(b)
                    if (
                            (leasingCo.name == 'SR-Install Only PERMITTED' 
                                || leasingCo.name == 'SR-Install Only') 
                            && op.Project_Design_Complete__c != null ) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                        String body6 ='';

                        mail.setToAddresses(sendTo);
                        mail.setSubject('Project Assignment to Premier Solar Solutions');
                        body6 = 'Congratulations, your project has been assigned to Premier Solar Solutions a certified solar installer for Sunrun. Our team is excited to assist you with your installation. A member will be reaching out to you shortly to discuss the installation timeline. <br/><br/>Should you have any questions, please call us at 855.248.8884 or email cs@premiersolar.com.';
                        mail.setHtmlBody(body6);
                        mail.setSenderDisplayName('Premier Solar');
                        mails.add(mail);
                        
                    }
                }               
            }          
        }
        
        
        Utility.isFutureUpdate = true;

        if (!mails.isEmpty()) {
            // help prevent email errors in tests
            if (!Test.isRunningTest())
                Messaging.sendEmail(mails);
        }
    }
    
    /***************** Update *********************************/
    public static void EmailAlertForUpdate(List<Opportunity> Opps, Map<Id, Opportunity> oldOpps) {
    
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Set<id> ids = new Set<id>();
        Set<id> PersonIds = new Set<id>();

        for(Opportunity oppRec : Opps) {
            //system.debug('does this work: ' + Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(oppRec.RecordTypeId).getname());

            ids.add(oppRec.Leasing_Company__c);
                
            if (oppRec.AccountId != Null)
                PersonIds.add(oppRec.AccountId);
        }
    
        Map<id,Account> accRecords = new Map<id,Account>([select id,Email_Address__c,Secondary_Email_CC__c, billingstatecode, name from account where id In: ids]);
        Map<id,Account> accEmails = new Map<id,Account>([select id,Email_Address__c,PersonContactId,Secondary_Email_CC__c,name,billingstatecode from account where id In: PersonIds AND IsPersonAccount = true]);
        
        for(Opportunity op : Opps){

            Account pAccount = accEmails.get(op.AccountId);
            String pEmail = pAccount.Email_Address__c;
            String pContactId = pAccount.PersonContactId;
            String pName = pAccount.Name;

            // Only send emails if enabled for this opp and if Install Completed Date is after the disable date
            if (!op.SkipCustomerProjectEmails__c && pEmail != null && op.Stage_Check_Formula__c != true){

                List<String> sendTo = new List<String>();
                sendTo.add(pEmail);
                
                Opportunity old = New Opportunity();
                old = oldOpps.get(op.Id);
                

                //AHJ Inspection Scheduled Customer Alert
                if (op.AHJ_Inspection_Scheduled__c != null 
                            && op.AHJ_Inspection_Scheduled__c != old.AHJ_Inspection_Scheduled__c ){          
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String body1 ='';
                    String AHJDate = op.AHJ_Inspection_Scheduled__c.month()+'/'+op.AHJ_Inspection_Scheduled__c.day()+'/'+op.AHJ_Inspection_Scheduled__c.Year();
                    
                    mail.setToAddresses(sendTo);
                    mail.setSubject('Drawings Approved By Customer Moving Further Update');
                    body1 = 'Dear ' + pName + ',<br/> <br/>A tech from your local jurisdiction will be coming out on '+AHJDate +' to inspect your solar system. Please make sure the main panel is accessible, the back gate is unlocked if necessary, and all animals are put away.<br/><br/>Please direct any questions you have to cs@premiersolar.com';
                    mail.setHtmlBody(body1);
                    mail.setSenderDisplayName('Premier Solar');
                    mails.add(mail); 
                
                }

                // Tentative/Confirmed Install Date Alert to Customer
                if (op.Scheduled_Install_Date__c != null 
                            && op.Scheduled_Install_Date__c != old.Scheduled_Install_Date__c ){
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                    lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Project_Tentative_Install_Update'];
                    
                    if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                        
                        mail.setToAddresses(sendTo);
                        mail.saveAsActivity = false;
                        mail.setTargetObjectId(pContactId);
                        mail.setTemplateId(lstEmailTemplates[0].Id);
                        mail.setWhatId(op.id);
                        mail.setSenderDisplayName('Premier Solar');
                        mails.add(mail);
                        
                    }
                  
                }
                
                 //PPT Scheduled Date Customer Date Alert
                if (op.PPT_Scheduled_Date__c != null 
                            && op.PPT_Scheduled_Date__c != old.PPT_Scheduled_Date__c){

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String body1 ='';
                    String PTTDATE = op.PPT_Scheduled_Date__c.month()+'/'+op.PPT_Scheduled_Date__c.day()+'/'+op.PPT_Scheduled_Date__c.Year();

                    mail.setToAddresses(sendTo);
                    mail.setSubject('Drawings Approved By Customer Moving Further Update');
                    body1 = 'Dear ' + pName + ',<br/><br/>A tech will be comingout on '+PTTDATE +'to replace any broken tile, patch any holes, and paint the conduit.Please give us a call if you have any questions or concerns.<br/><br/>Please direct any questions you have to cs@premiersolar.com';
                    mail.setHtmlBody(body1);
                    mail.setSenderDisplayName('Premier Solar');
                    mails.add(mail); 
                
                }

                //===============================================
                //Leasing Company Emails:                
                //===============================================
                if (op.Leasing_Company__c != null && accRecords.get(op.Leasing_Company__c) != null  && op.Leasing_Company_Alert__c == true) {

                    Account leasingCo = accRecords.get(op.Leasing_Company__c);

                    // Welcome call notice                            
                    if (leasingCo.name != 'SR-Install Only' 
                                && leasingCo.name != 'SR-Install Only PERMITTED'
                                && op.Welcome_Call_Completed__c != null 
                                && old.Welcome_Call_Completed__c == null ) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Welcome_Call_Notice'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setWhatId(op.id);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                        }
                    }


                    // Design approval
                    if (leasingCo.name != 'SR-Install Only' 
                                && leasingCo.name != 'Sunedison' 
                                && leasingCo.name != 'SR-Install Only PERMITTED' 
                                && op.Site_Audit_Completed__c != null 
                                && op.Site_Audit_Completed__c != old.Site_Audit_Completed__c) {   
                    
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Design_Approval'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setWhatId(op.id);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);  
                            
                        }
                    }
                    
                
                    //Permitting Email Alerts
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && op.Project_Design_Complete__c != null 
                                && op.Project_Design_Complete__c != old.Project_Design_Complete__c) {
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Permitting_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                       
                    //Installation Update
                    if (leasingCo.name != 'SR-Install Only PERMITTED'
                                && op.Permits_Approved__c != null 
                                && op.Permits_Approved__c != old.Permits_Approved__c ) {
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Installation_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //City/County Inspections
                    if (op.Install_Completed_Date__c != null 
                                && op.Install_Completed_Date__c != old.Install_Completed_Date__c 
                                && (
                                        op.Installation_Outline__c == null
                                        ||
                                        op.Installation_Outline__c.containsIgnoreCase('Ground Mount') != true
                                    )
                                ) {
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'City_County_Inspections_Update' LIMIT 1];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                                 
                    
                    //Utility Interconnection
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && leasingCo.name != 'SR-Install Only' 
                                && op.AHJ_Inspection_Approved__c != null 
                                && op.AHJ_Inspection_Approved__c != old.AHJ_Inspection_Approved__c) {
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Utility_Interconnection_Update'];
                        
                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //Turn It On And Start Saving(a)
                    if (leasingCo.name != 'SR-Install Only PERMITTED' 
                                && leasingCo.name != 'SR-Install Only' 
                                && op.Commissioning_Completed_Date__c != null 
                                && op.Commissioning_Completed_Date__c != old.Commissioning_Completed_Date__c) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        List<EmailTemplate> lstEmailTemplates = new List<EmailTemplate>();
                        lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'PTO_Received_Date'];

                        if (lstEmailTemplates != null && !lstEmailTemplates.isEmpty()) {
                            
                            mail.setToAddresses(sendTo);
                            mail.saveAsActivity = false;
                            mail.setTargetObjectId(pContactId);
                            mail.setTemplateId(lstEmailTemplates[0].Id);
                            mail.setWhatId(op.id);
                            mail.setSenderDisplayName('Premier Solar');
                            mails.add(mail);
                            
                        }
                    }
                    
                    //Turn It On And Start Saving(b)
                    if (
                            (  leasingCo.name == 'SR-Install Only PERMITTED' 
                              || leasingCo.name == 'SR-Install Only'
                            )
                            && op.Project_Design_Complete__c != null 
                            && op.Project_Design_Complete__c != old.Project_Design_Complete__c ) {

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String body6 ='';
                        
                        mail.setToAddresses(sendTo);
                        mail.setSubject('Project Assignment to Premier Solar Solutions');
                        body6 = 'Congratulations, your project has been assigned to Premier Solar Solutions a certified solar installer for Sunrun. Our team is excited to assist you with your installation. A member will be reaching out to you shortly to discuss the installation timeline. <br/><br/>Should you have any questions, please call us at 855.248.8884 or email cs@premiersolar.com.';
                        mail.setHtmlBody(body6);
                        mail.setSenderDisplayName('Premier Solar');
                        mails.add(mail);
                        
                    }
                }
            }
            
        }
       
        Utility.isFutureUpdate = true;
        if (!mails.isEmpty()) {
            // help prevent email errors in tests
            if (!Test.isRunningTest())
                Messaging.sendEmail(mails);
        }
    }
}