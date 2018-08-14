/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GlobalSendSMSController {
    global static String strRecordId;
    global GlobalSendSMSController() {

    }
    global static Boolean checkOptOut(String recordId) {
        return null;
    }
    global static tdc_tsw.GlobalSendSMSController.MessageDataWprCls findMessageData(String recordId, String selectedPhoneApi, String selectedNameApi, Map<String,String> mapPhoneToName) {
        return null;
    }
    global static tdc_tsw.GlobalSendSMSController.SMSConfigWrpCls findSMSConfigRecord(String currentObject) {
        return null;
    }
    global static tdc_tsw.GlobalSendSMSController.SMSTemplateWprCls findSMSTemplateRecord(String recordId) {
        return null;
    }
    global static List<System.SelectOption> findSenderNumberList() {
        return null;
    }
    global static String findTemplateText(Map<String,tdc_tsw__Message_Template__c> mapIdToTemplate, String selectedTemplate, String recordId, String optionalId) {
        return null;
    }
    global static tdc_tsw__UserSMSConfig__c findUserSMSConfigResult(String senderPhoneKey) {
        return null;
    }
    global static List<String> getRecordsIdList(String attachmentId) {
        return null;
    }
    global static String getparsedSMSText(String messageText, String recordId, String anotherRecordId) {
        return null;
    }
    global static String makeScheduleSMS(String senderPhoneKey, String scheduledDatetime, String endDate, String schedulePeriod, String selectedPhoneApi, String selectedTemplate, String messageText, String recordId) {
        return null;
    }
    global static String scheduleBatchSMS(String senderPhoneKey, String scheduledDatetime, String endDate, String schedulePeriod, String selectedPhoneApi, String selectedTemplate, String messageText, List<String> lstIds) {
        return null;
    }
    global static String scheduleReportSMS(String senderPhoneKey, String scheduledDatetime, String endDate, String schedulePeriod, String selectedPhoneApi, String selectedTemplate, String messageText, List<String> lstIds, String strReportId, String strReportColumn, Boolean runReportonScheduleTime) {
        return null;
    }
    global static String sendBatchTextFromReport(String senderPhoneKey, String selectedPhoneApi, Map<String,String> mapPhoneToName, String selectedTemplate, String messageText, List<String> lstIds, String strReportId) {
        return null;
    }
    global static String sendBatchText(String senderPhoneKey, String selectedPhoneApi, Map<String,String> mapPhoneToName, String selectedTemplate, String messageText, List<String> lstIds) {
        return null;
    }
    global static String sendTextMessage(String senderPhoneKey, String toNumber, String selectedTemplate, String messageText, String recordId) {
        return null;
    }
global class MessageDataWprCls {
    global String errorMsg;
    global String phoneNumber;
    global String receiverName;
    global MessageDataWprCls() {

    }
}
global class SMSConfigWrpCls {
    global String defaultPhoneApi;
    global String errorMsg;
    global Boolean isSchedulable;
    global List<System.SelectOption> lstSendTo;
    global Map<String,String> mapPhoneToName;
    global String nameApi;
    global SMSConfigWrpCls() {

    }
}
global class SMSTemplateWprCls {
    global String errorMsg;
    global Map<String,tdc_tsw__Message_Template__c> mapIdToTemplate;
    global List<System.SelectOption> templateList;
    global SMSTemplateWprCls() {

    }
}
}
