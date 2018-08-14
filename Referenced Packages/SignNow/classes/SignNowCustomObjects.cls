/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SignNowCustomObjects {
    global SignNowCustomObjects() {

    }
    global static void deleteTemplate(String user_id, String document_id) {

    }
    global static cuda_signnow__SNAccess__c getAccessRecord(String user_id) {
        return null;
    }
    global static String getApiBase(String org_id) {
        return null;
    }
    global static String getClientId(String org_id) {
        return null;
    }
    global static Map<String,String> getReturnMap(String apibase, String copy_name, String signnow_email, String copy_id, String org_id, String org_name, String signnow_user_id, String sf_user_id, String account_id, String template_id) {
        return null;
    }
    global static String getSecret(String org_id) {
        return null;
    }
    global static String getSignnowAuthUrl(String org_id) {
        return null;
    }
    global static System.HttpResponse getSignnowDocument(String apibase, String access_token, String document_id) {
        return null;
    }
    global static String getSignnowWebUrl(String org_id) {
        return null;
    }
    global static Map<String,Object> getTemplateMap(System.HttpResponse res) {
        return null;
    }
    global static System.HttpResponse postMetadata(String apibase, String token, String document_id, String org_id, String org_name, String account_id) {
        return null;
    }
    global static System.HttpResponse postTemplateCopy(String apibase, String access_token, String document_id, String document_name) {
        return null;
    }
    global static System.HttpResponse putQuoteId(String apibase, String access_token, String document_id, String quoteId) {
        return null;
    }
    global static void storeInvite(String template_id, String document_id, String document_name, String signnow_user_id, String account_id, String salesforce_user_id) {

    }
    global static void storeTemplate(String document_name, String document_id, String signnow_user_id, String salesforce_user_id, Integer team_template, String document_owner, String updated, Boolean containsFields) {

    }
    global static Boolean templateRecordExists(String document_id) {
        return null;
    }
    global static void updateTemplate(Map<String,Object> template_map) {

    }
}
