global class ProjectNotesBatch implements Database.Batchable<sObject>, Database.Stateful{


    Set<Id> FailedProjectIds;
    Set<Id> getFailedProjectIds() {
        if (FailedProjectIds == null)
            FailedProjectIds = new Set<Id>();
        return FailedProjectIds;
    }

    global ProjectNotesBatch() {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id';

        //list of all the note fields for the opportunity object
        /*List<DescribeFieldResult> NoteFields = new List<DescribeFieldResult>();

        DescribeFieldResult tempFieldDescribe;

        // Loop trhough the SObjectFields for the Opportunity object
        for (Schema.SObjectField field : Schema.SObjectType.Opportunity.fields.getMap().values()) {
            tempFieldDescribe = field.getDescribe();
            // add fields that contain the word note and are of type string or textArea
            if (tempFieldDescribe.getName().containsIgnoreCase('note') && (tempFieldDescribe.getType() + '' == 'String' || tempFieldDescribe.getType() + '' == 'TextArea'))
                NoteFields.add(tempFieldDescribe);
            
            if (tempFieldDescribe.getName().equals('Important_Details__c')
                || tempFieldDescribe.getName().equals('QC_Comments__c'))
                NoteFields.add(tempFieldDescribe);
            // The following are fields that could possibly be added
            //Issues__c
            //Corrections_needed_at_Commissioning__c
            //QA_Issues__c
            //Burnham_Issues__c
            //Follow_up__c
            //Referral_Comments__c
        }



        // Add fields to the query from the API name of the DescribeFieldResult
        for (DescribeFieldResult noteField : NoteFields)
            query += ', ' + noteField.getName();*/

        query += ', AHJ_Notes__c, Battery_Notes__c, Commissioning_Notes__c, Initial_Call_Notes__c, Jurisdiction_Notes__c, Material_Take_Off_Notes__c, MPU_Derate_Schedule_Date_Notes__c, PPT_Notes__c, Revisit_Notes__c, Redesign_Notes__c, Repair_Notes__c, Site_Survey_Notes__c, Admin_Processing_Notes__c, Billing_Closeout_Notes__c, Customer_Service_Notes__c, Cancellation_Notes__c, Customer_Experience_Comments__c, Failed_Status_Notes__c, FSD_Notes__c, Important_Details__c, Installation_Notes__c, Notes__c, Notes_Installed__c, NPS_Survey_Comments__c, Pending_Customer__c, Has_this_cust_had_a_negative_experience__c, QC_Comments__c, QA_Issues__c, Underwriting_Notes__c ';

        query += ' FROM Opportunity';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {

        // If the scope is larger than 1 notes will not be created properly
        if (scope.size() != 1)
            throw new LimitException('Batch size should be set to one record at a time.');

        //list of all the note fields for the opportunity object
        List<DescribeFieldResult> NoteFields = new List<DescribeFieldResult>();

        DescribeFieldResult tempFieldDescribe;

        set<String> fields2Get = new set<String>{'AHJ_Notes__c', 'Battery_Notes__c', 'Commissioning_Notes__c', 'Initial_Call_Notes__c', 'Jurisdiction_Notes__c', 'Material_Take_Off_Notes__c', 'MPU_Derate_Schedule_Date_Notes__c', 'PPT_Notes__c', 'Revisit_Notes__c', 'Redesign_Notes__c', 'Repair_Notes__c', 'Site_Survey_Notes__c', 'Admin_Processing_Notes__c', 'Billing_Closeout_Notes__c', 'Customer_Service_Notes__c', 'Cancellation_Notes__c', 'Customer_Experience_Comments__c', 'Failed_Status_Notes__c', 'FSD_Notes__c', 'Important_Details__c', 'Installation_Notes__c', 'Notes__c', 'Notes_Installed__c', 'NPS_Survey_Comments__c', 'Pending_Customer__c', 'Has_this_cust_had_a_negative_experience__c', 'QC_Comments__c', 'QA_Issues__c', 'Underwriting_Notes__c'};


        // Loop trhough the SObjectFields for the Opportunity object
        for (Schema.SObjectField field : Schema.SObjectType.Opportunity.fields.getMap().values()) {
            tempFieldDescribe = field.getDescribe();
            // add fields that contain the word note and are of type string or textArea
            /*if (tempFieldDescribe.getName().containsIgnoreCase('note') && (tempFieldDescribe.getType() + '' == 'String' || tempFieldDescribe.getType() + '' == 'TextArea'))
                NoteFields.add(tempFieldDescribe);
            
            if (tempFieldDescribe.getName().equals('Important_Details__c')
                || tempFieldDescribe.getName().equals('QC_Comments__c'))
                NoteFields.add(tempFieldDescribe);*/
            // The following are fields that could possibly be added
            //Issues__c
            //Corrections_needed_at_Commissioning__c
            //QA_Issues__c
            //Burnham_Issues__c
            //Follow_up__c
            //Referral_Comments__c

            if (fields2Get.contains(tempFieldDescribe.getName())) {
                NoteFields.add(tempFieldDescribe);
            }
        }


        Opportunity opp = scope.get(0);

        // Loop through the Opportunity fields and create ContentDocument notes for each note field
        for (DescribeFieldResult field : NoteFields)
            if (String.isNotBlank((String) opp.get(field.getName())))
                // Call method that creates but doesnt insert each ContentNote
                Core.CreateUncommittedNote(field.getLabel(), (String) opp.get(field.getName()));

        // Commit the notes and hold the boolean of the successful insertion of all notes
        Boolean successful = Core.CommitNotes(opp.Id);

        // If the insertion of ContentDocument records was not successful add the opportunity id to the set of ids
        if (!successful)
            getFailedProjectIds().add(opp.Id);

    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Notes from ' + getFailedProjectIds().size() + 'projects could not be created');
        System.debug(getFailedProjectIds());

        // Document the opportunities for which notes were not created
        // in case of sandbox create a task 
        if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
            String emailBody = 'List of project Ids:';
            for(Id projId : getFailedProjectIds())
                emailBody += '\n' + projId;

            insert new Task(Subject = 'Notes from ' + getFailedProjectIds().size() + 'projects could not be created',
                            Description = emailBody);
        // Send email to the running user
        } else {

            String emailBody = 'Notes from ' + getFailedProjectIds().size() + 'projects could not be created';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            // send email to the current user running the batch
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setPlainTextBody(emailBody);
            mail.saveAsActivity = false;
            Messaging.SendEmail(new List<Messaging.SingleEmailMessage> { mail });
        }
        

    }
    
}