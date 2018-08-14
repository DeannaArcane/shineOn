/**
 * OpportunityGoogleDriveTriggerHandler
 * 
 * This class creates folders in Google Drive for opportunities that are created.
 */

public with sharing class OpportunityGoogleDriveTriggerHandler {
    
    public static final String CLASS_NAME = 'OpportunityGoogleDriveTriggerHandler';
    public static final String EMAIL_ALERT_SENDER = 'Google Drive Salesforce Integration';
    public static final String EMAIL_ALERT_SUBJECT = 'Google Drive Salesforce Integration Alert';
    
    public static List<GoogleDriveLog__c> calloutLogs = new List<GoogleDriveLog__c>();
    public List<GoogleDriveLog__c> logs = new List<GoogleDriveLog__c>();
    
    /*
    * This is the main entry point for the trigger.
    */
    public void execute(List<Opportunity> newList, Map<Id, Opportunity> newMap, List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {
        if (Trigger.isAfter && Trigger.isInsert) {
            handleAfterInsert(newList, newMap);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            handleAfterUpdate (newList, newMap, oldList, oldMap);
        } else if (Trigger.isBefore && Trigger.isInsert) {
            handleBeforeInsert(newList);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handleBeforeUpdate(newList, newMap, oldList, oldMap);
        } else if (Trigger.isBefore && Trigger.isDelete) {
            handleBeforeDelete(oldList, oldMap);
        } else if (Trigger.isAfter && Trigger.isDelete) {
            handleAfterDelete(oldList, oldMap);
        }
    }
    
    /*
    * Handlers for each specific situation: before insert, before update, after insert, after update
    * Some are empty, and included here if needed in the future.
    */
    
    /**
     * After Insert handler
     * 
     * Creates Google Drive folders for Opportunities.
     */
    @testVisible
	private void handleAfterInsert(List<Opportunity> newList, Map<Id, Opportunity> newMap) {
		Map<Id, String> opportunityJobNumbersById = processOpportunities(newList);
        
        if (opportunityJobNumbersById.size() > 0) {
        	List<Id> opportunityIds = new List<Id>();
        	List<String> opportunityFolderNames = new List<String>();
        	List<Id> opportunityRecordTypeIds = new List<Id>();
        	for (Id key : opportunityJobNumbersById.keySet()) {
        		opportunityIds.add(key);
        		opportunityFolderNames.add(opportunityJobNumbersById.get(key));
        		
        		// collect the record type for the opportunity
        		Opportunity opportunity = newMap.get(key);
        		
        		Id recordTypeId = opportunity.recordTypeId;
        		opportunityRecordTypeIds.add(recordTypeId);
        	}
        	
        	createFoldersForOpportunitiesWithCallout(opportunityIds, opportunityFolderNames, opportunityRecordTypeIds);
    	}
    }
    
    @testVisible
    private void handleBeforeInsert(List<Opportunity> newList) {}
    
    @testVisible    
    private void handleBeforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> newMap, List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {}
    
    @testVisible
    private void handleAfterUpdate(List<Opportunity> newList, Map<Id, Opportunity> newMap, List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {}
    
    @testVisible
    private void handleBeforeDelete(List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {}
    
    @testVisible
    private void handleAfterDelete(List<Opportunity> oldList, Map<Id, Opportunity> oldMap) {}
    
    /*
     * Executes business logic with a given list of opportunities.
     * Folder names are created using the opportunities' job numbers and billing states.
     * 
     * @param opportunities The opportunities received from the trigger.
     * @return a list of folder names or null if a fatal error has occurred
     */
    private Map<Id, String> processOpportunities(List<Opportunity> opportunities) {
    	Map<Id, String> opportunityJobNumbersById = new Map<Id, String>();
        List<String> opportunityJobNumbers = new List<String>();
        
		GoogleDriveOpportunityConfiguration__mdt configuration = getConfiguration(false);
        if (configuration == null) {
            return opportunityJobNumbersById;
        }
        
        // determine the folder names for the opportunities, based on their job numbers
        
        // gather the billing states of the new opportunities
        Set<String> opportunityStates = new Set<String>();
        for (Opportunity o : opportunities) {
            opportunityStates.add(o.BillingState__c);
        }
        
		List<Opportunity> opportunitiesInStates = [SELECT Id, Name, Account.BillingState, BillingState__c, Job_Num__c, Job__c
                                                   FROM Opportunity
                                                   WHERE BillingState__c In: opportunityStates
                                                   ORDER BY CreatedDate DESC, Job__c DESC];
        
        // iterate through the opportunities in the states, incrementing the job number counts
        Map<String, Integer> opportunityStateMap = new Map<String, Integer>();
		for (Opportunity o : opportunitiesInStates) {                     
			if (!opportunityStateMap.containsKey(o.BillingState__c) && o.Job_Num__c != null) {
				if (o.Job_Num__c.contains(o.BillingState__c)) {
					String[] split = o.Job_Num__c.split('-');
					opportunityStateMap.put(o.BillingState__c, Integer.valueOf(split[1])); 
				}
			}
		}
        
        // update each opportunity's job number
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
		for (Opportunity o : opportunities) {
			if (opportunityStateMap.containsKey(o.BillingState__c)) {
				Integer count = opportunityStateMap.get(o.BillingState__c)+1;
				opportunityStateMap.remove(o.BillingState__c);
				opportunityStateMap.put(o.BillingState__c, count);
            } else {
                Decimal defaultBillingStateCount = configuration.DefaultBillingStateCount__c;
				opportunityStateMap.put(o.BillingState__c, defaultBillingStateCount.intValue());
			}
            
            String jobNumber = o.BillingState__c + '-' + opportunityStateMap.get(o.BillingState__c);
            opportunityJobNumbers.add(jobNumber);
            opportunityJobNumbersById.put(o.Id, jobNumber);

            Opportunity updatedOpportunity = new Opportunity();
            updatedOpportunity.Id = o.Id;
            updatedOpportunity.Job_Num__c = jobNumber;
            opportunitiesToUpdate.add(updatedOpportunity);
    	}
        
  		update opportunitiesToUpdate;
        
        return opportunityJobNumbersById;
    }
    
    /**
     * Retrieves the active Google Drive Opportunity configuration and verifies its validity. 
     * Returns null if if the configuration is not valid and sends an email alert
     * if an email address is specified in the configuration.
     * 
     * @param validate Verifies the configuration is ready to be used
     * @return the configuration or null if not valid
     **/
    @testVisible
    private static GoogleDriveOpportunityConfiguration__mdt getConfiguration(Boolean validate) {
        // get the active configuration from custom metadata
        GoogleDriveOpportunityConfiguration__mdt configuration = GoogleDriveUtils.getActiveOpportunityConfiguration();
        if (configuration == null) {
            sendEmailAlert(configuration.EmailAlert__c, 'Unable to find an activate Google Drive Opportunity configuration (Custom Metadata). Please activate a configuration and try again.');
            return null;
        }

        // return if validation is not required
        if (!validate) {
            return configuration;
        }
        
		// get the Connector service
        GoogleDriveConnectorService connectorService = GoogleDriveUtils.getConnectorService(configuration.GoogleDriveConnectorTypeName__c);
        if (connectorService == null) {
            sendEmailAlert(configuration.EmailAlert__c, 'Unable to retrieve Google Drive Connector. Please verify your active configuration\'s Google Drive Connector and its Connector Type.');
            return null;
        }
        
        // validate the Connector service
        if (!GoogleDriveUtils.isConnectorValid(connectorService)) {
            sendEmailAlert(configuration.EmailAlert__c, 'Google Drive Connector is invalid. Please verify the Google Drive Connector configuration and re-authenticate.');
            return null;
        }
        
        return configuration;
    }
    
    @testVisible
    private static void logFolderNames(List<GoogleDriveLog__c> logs, List<String> opportunityFolderNames, String message) {
        for (String name : opportunityFolderNames) {
            logMessage(logs, LoggingLevel.ERROR, message + ': "' + name + '"');
        }
    }
        
    public static void logFatalCalloutError(List<GoogleDriveLog__c> logs, List<String> opportunityFolderNames, String message) {
        logMessage(logs, LoggingLevel.ERROR, message);
        logFolderNames(logs, opportunityFolderNames, 'Unable to create folder ');
        writeLogs(logs);
    }
    
    @testVisible
	private static void logMessage(List<GoogleDriveLog__c> logs, LoggingLevel logLevel, String message) {
        GoogleDriveLog__c log = new GoogleDriveLog__c();
        log.LogLevel__c = getLogLevel(logLevel);
        log.Message__c = message;
        log.Timestamp__c = System.now();
        logs.add(log);
        
        System.debug(logLevel, CLASS_NAME + ': ' + message);
    }
    
    @testVisible
    private static void writeLogs(List<GoogleDriveLog__c> logs) {
        insert logs;
        logs.clear();
    }
    
    @future (callout=true)
    public static void createFoldersForOpportunitiesWithCallout(List<Id> opportunityIds, List<String> opportunityFolderNames, List<Id> opportunityRecordTypeIds) {

		System.debug('mh2 createFoldersForOpportunitiesWithCallout v1');
		
		List<Opportunity> opportunitiesForUpdate = new List<Opportunity>();
		Map<ID, Opportunity> opportunitiesMap = new Map<ID, Opportunity>([SELECT Id, Google_File_ID__c FROM Opportunity WHERE Id in :opportunityIds]);      
        
        List<GoogleDriveLog__c> logs = new List<GoogleDriveLog__c>();
        
        GoogleDriveOpportunityConfiguration__mdt configuration = GoogleDriveUtils.getActiveOpportunityConfiguration();
        Map<String,String> subfoldersByRecordTypeMap = GoogleDriveUtils.getSubfoldersByOpportunityRecordTypes();
        
		// get the Google Drive Connector service
        GoogleDriveConnectorService connectorService = GoogleDriveUtils.getConnectorService(configuration.GoogleDriveConnectorTypeName__c);
        if (connectorService == null) {
            // logFatalCalloutError(logs, opportunityFolderNames, 'Unable to retrieve Google Drive Connector. Verify the Google Drive Connector and its Connector Type.');
            return;
        }
        
        // connect to Google Drive
		ffhttp_Client.ICredentials credentials = new ffhttp_Client.AccessTokenCredentials(connectorService.connector.TokenType__c,  connectorService.getAccessToken());
        ffhttp_GoogleDrive client = new ffhttp_GoogleDrive(credentials);
        ffhttp_GoogleDriveFiles files = client.files();
        
        // verify the root folder exists
        ffhttp_GoogleDriveModelFile rootFolder = GoogleDriveUtils.getFolder(files, null, configuration.RootFolder__c);
        if (rootFolder == null) {
            logFatalCalloutError(logs, opportunityFolderNames, 'Root folder specified in the Google Drive Opportunity Configuration does not exist in Google Drive.');
            return;
        }
        
		// create an ffhttp_GoogleDriveModelParent object for the root folder
		ffhttp_GoogleDriveModelParent rootParentFolder = new ffhttp_GoogleDriveModelParent();
		rootParentFolder.setId(rootFolder.getId());
        
        for (Integer i = 0; i < opportunityFolderNames.size(); i++) {
        // for (String folderName : opportunityFolderNames) {
        	String folderName = opportunityFolderNames.get(i);
        	
        	Id recordTypeId = opportunityRecordTypeIds.get(i);
        	String recordTypeName = GoogleDriveUtils.getOpportunityRecordTypeById(recordTypeId);
        	String subfolders = subfoldersByRecordTypeMap.get(recordTypeName);
        	
            String fileId = createFoldersForOpportunity(files, rootParentFolder, folderName, subfolders);
            Opportunity opportunity = opportunitiesMap.get(opportunityIds.get(i));
            opportunity.Google_File_ID__c = fileId;
            opportunitiesForUpdate.add(opportunity);
        }
        
        writeLogs(calloutLogs);
        
		// ensure the connector has the latest token.
		update connectorService.connector;
		
		update opportunitiesForUpdate;
    }
    
    public static String createFoldersForOpportunity(ffhttp_GoogleDriveFiles files, ffhttp_GoogleDriveModelParent rootFolder, String opportunityName, String recordTypeFolders) { 
    	
    	String opportunityFolderId = '';        
        try {
        	// get the state's folder, creating it if necessary
        	String [] splitName = opportunityName.split('-');
        	String state = splitName[0];
			ffhttp_GoogleDriveModelFile stateFolder = GoogleDriveUtils.getFolder(files, rootFolder, state);
			if (stateFolder == null) {
				stateFolder = GoogleDriveUtils.createFolder(files, rootFolder, state);
			}
			
			ffhttp_GoogleDriveModelParent parentStateFolder = new ffhttp_GoogleDriveModelParent();
            parentStateFolder.setId(stateFolder.getId());
        	
            // create the folder for the opportunity
			ffhttp_GoogleDriveModelFile opportunityFolder = GoogleDriveUtils.createFolder(files, parentStateFolder, opportunityName);
            logCalloutMessage(LoggingLevel.INFO, '\"' + opportunityFolder.getTitle() + '"" folder was successfully created.');
            opportunityFolderId = opportunityFolder.getId();
            
            // create an ffhttp_GoogleDriveModelParent object for the new opportunity folder
            ffhttp_GoogleDriveModelParent parentFolder = new ffhttp_GoogleDriveModelParent();
            parentFolder.setId(opportunityFolder.getId());
            
            // get the list of subfolders to create
            String [] subfolders = recordTypeFolders.split('\n');
            
            // iterate through each subfolder name and create it
            for (String subfolder : subfolders) {
                subfolder = subfolder.trim();
                
                // check for nested subfolder
                String [] subfolderWithNestedSubfolder = subfolder.trim().split('\\\\');
                // System.debug('Subfolder: ' + subfolder);
                
                String nestedSubfolder = null;
                if (subfolderWithNestedSubfolder.size() >= 2) {
                	subfolder = subfolderWithNestedSubfolder[0];
                	nestedSubfolder = subfolderWithNestedSubfolder[1];
					// System.debug('Nested Subfolder: ' + nestedSubfolder);	
                }
                
                ffhttp_GoogleDriveModelFile result = GoogleDriveUtils.createFolder(files, parentFolder, subfolder);
                if (result != null) {
                    logCalloutMessage(LoggingLevel.INFO, 'Google Drive folder "' + subfolder + '" was created for ' + opportunityFolder.getTitle());
                    if (String.isNotBlank(nestedSubfolder)) {
						ffhttp_GoogleDriveModelParent parentSubfolder = new ffhttp_GoogleDriveModelParent();
            			parentSubfolder.setId(result.getId());
            			result = GoogleDriveUtils.createFolder(files, parentSubfolder, nestedSubfolder);
            			if (result != null) {
							logCalloutMessage(LoggingLevel.INFO, 'Google Drive folder "' + nestedSubfolder + '" was created for ' + opportunityFolder.getTitle());		
            			} else {
							logCalloutMessage(LoggingLevel.ERROR, 'Google Drive folder "' + nestedSubfolder + '" could not be created for ' + opportunityFolder.getTitle());
            			}            			 
                    } else {
                    	// System.debug('No nested subfolder to create');
                    }
                } else {
                    logCalloutMessage(LoggingLevel.ERROR, 'Google Drive folder "' + subfolder + '" could not be created for ' + opportunityFolder.getTitle());
                }
            }
        } catch (ffhttp_AppException e) {
            logCalloutMessage(LoggingLevel.ERROR, 'Google Drive folder "' + opportunityName + '" could not be created. Exception: ' + e.getMessage());
        }
        
        return opportunityFolderId;
    }
    
    @testVisible
    private static String getLogLevel(LoggingLevel logLevel) {
        if (logLevel == null) {
            return 'FATAL';
        } else if (logLevel == LoggingLevel.ERROR) {
            return 'ERROR';
        } else if (logLevel == LoggingLevel.WARN) {
            return 'WARN';
        } else if (logLevel == LoggingLevel.INFO) {
            return 'INFO';
        } else {
            return 'DEBUG';
        }
    }
    
    @testVisible
	private static void logCalloutMessage(LoggingLevel logLevel, String message) {
        GoogleDriveLog__c log = new GoogleDriveLog__c();
        log.LogLevel__c = getLogLevel(logLevel);
        log.Message__c = message;
        log.Timestamp__c = System.now();
        calloutLogs.add(log);
        
        if (logLevel == null) {
            logLevel = LoggingLevel.ERROR;
        }
        
        System.debug(logLevel, CLASS_NAME + ': ' + message);
    }
    
    @future
    @testVisible
    private static void sendEmailAlert(String emailAddress, String message) {
    	List<Messaging.SingleEmailMessage> mails = composeMail(emailAddress, message);
    	if (mails != null && !Test.isRunningTest()) {
        	try {
        		Messaging.sendEmail(mails);
        	}
			catch (System.EmailException e) {
            	System.debug(LoggingLevel.ERROR, 'Sending email is not allowed. ' + e.getMessage());
        	}
    	}
    }
    
    @testVisible
    private static List<Messaging.SingleEmailMessage> composeMail(String emailAddress, String message) {
        if (String.isBlank(emailAddress)) {
            return null;
        }
        
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage alert = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(emailAddress);
        alert.setToAddresses(sendTo);
        alert.setSenderDisplayName(EMAIL_ALERT_SENDER);
        alert.setSubject(EMAIL_ALERT_SUBJECT);
        alert.setHtmlBody(message);
        mails.add(alert);
		return mails;    	
    }
    
    
}