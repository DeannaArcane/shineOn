@isTest
private class OpportunityGoogleDriveTriggerHandlerTest {

	private static Integer BATCH_SIZE = 1;

    static testMethod void insertTest() {
    	
    	Test.startTest();
    	List<Opportunity> opportunities = newOpportunities();
    	insert opportunities;
    	Test.stopTest();
    	
    }
    
    static testMethod void handleMethodsTest() {
    	Test.startTest();
		OpportunityGoogleDriveTriggerHandler handler = new OpportunityGoogleDriveTriggerHandler();
		handler.handleBeforeInsert(null);
		
		handler.handleBeforeUpdate(null, null, null, null);
		handler.handleAfterUpdate(null, null, null, null);

		handler.handleBeforeDelete(null, null);
		handler.handleAfterDelete(null, null);		
    	
    	Test.stopTest();
    }
    
    static testMethod void getLogLevelTest() {
    	System.assertEquals('FATAL', OpportunityGoogleDriveTriggerHandler.getLogLevel(null));
    	System.assertEquals('ERROR', OpportunityGoogleDriveTriggerHandler.getLogLevel(LoggingLevel.ERROR));
    	System.assertEquals('WARN', OpportunityGoogleDriveTriggerHandler.getLogLevel(LoggingLevel.WARN));
    	System.assertEquals('INFO', OpportunityGoogleDriveTriggerHandler.getLogLevel(LoggingLevel.INFO));
    	System.assertEquals('DEBUG', OpportunityGoogleDriveTriggerHandler.getLogLevel(LoggingLevel.DEBUG));
    }
    
    static testMethod void logCalloutMessageTest() {
    	Test.startTest();
    	OpportunityGoogleDriveTriggerHandler.logCalloutMessage(null, 'test');
    	Test.stopTest();
    }
    
	static testMethod void logFolderNames() {
    	Test.startTest();
    	
    	List<GoogleDriveLog__c> logs = new List<GoogleDriveLog__c>();
    	GoogleDriveLog__c log = new GoogleDriveLog__c();
    	log.Message__c = 'message';
    	log.LogLevel__c = 'DEBUG';
    	log.Timestamp__c = Date.today();
    	logs.add(log);
    	
    	List<String> names = new List<String>();
    	names.add('Test');
    	
    	OpportunityGoogleDriveTriggerHandler.logFolderNames(logs, names, 'test');
    	Test.stopTest();
    }
    
	static testMethod void logFatalCalloutError() {
    	Test.startTest();
    	
    	List<GoogleDriveLog__c> logs = new List<GoogleDriveLog__c>();
    	GoogleDriveLog__c log = new GoogleDriveLog__c();
    	log.Message__c = 'message';
    	log.LogLevel__c = 'DEBUG';
    	log.Timestamp__c = Date.today();
    	logs.add(log);
    	
    	List<String> names = new List<String>();
    	names.add('Test');
    	
    	OpportunityGoogleDriveTriggerHandler.logFatalCalloutError(logs, names, 'message');
    	Test.stopTest();
    }

	static testMethod void composeMailTest() {		
    	System.assertEquals(null, OpportunityGoogleDriveTriggerHandler.composeMail(null, null));    	
    	System.assertNotEquals(null, OpportunityGoogleDriveTriggerHandler.composeMail('test@test.com', 'test'));
    }
    
	static testMethod void sendEmailAlertTest() {
		OpportunityGoogleDriveTriggerHandler.sendEmailAlert('test@test.com', 'test');
    }
    
    public static List<Opportunity> newOpportunities() {
    	List<Opportunity> opportunities = new List<Opportunity>();
    	for (Integer i = 1; i <= BATCH_SIZE; i++) {
    		Opportunity opportunity = new Opportunity();
    		opportunity.Name = 'Test ' + String.valueOf(i);
    		opportunity.Job_Num__c = 'AZ-11000';
    		opportunity.StageName = 'Prospecting';
    		opportunity.CloseDate = Date.today();
    		opportunities.add(opportunity);
    	}
    	return opportunities;
    }
}