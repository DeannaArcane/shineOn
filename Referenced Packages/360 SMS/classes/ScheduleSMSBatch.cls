/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ScheduleSMSBatch implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global ScheduleSMSBatch(List<SObject> lstScheduledRecords, String messageText, String sPhoneField, String sObjectName, List<tdc_tsw__Scheduled_Sms__c> lstScheduledSms) {

    }
    global ScheduleSMSBatch(List<SObject> lstScheduledRecords, String messageText, String sPhoneField, String sObjectName, Map<Id,tdc_tsw__Scheduled_Sms__c> mapSobjectIdToScheduleRecord, String jobId) {

    }
    global ScheduleSMSBatch(List<SObject> lstScheduledRecords, String messageText, String sPhoneField, String sObjectName, Map<Id,tdc_tsw__Scheduled_Sms__c> mapSobjectIdToScheduleRecord, String jobId, Id smsTempId) {

    }
    global ScheduleSMSBatch(List<SObject> lstScheduledRecords, String messageText, String sPhoneField, String sObjectName, Map<Id,tdc_tsw__Scheduled_Sms__c> mapSobjectIdToScheduleRecord, String jobId, Id smsTempId, String relatedObjId) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> objectList) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global System.Iterable start(Database.BatchableContext BC) {
        return null;
    }
}
