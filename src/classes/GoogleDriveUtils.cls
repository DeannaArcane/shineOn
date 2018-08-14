/**
 * GoogleDriveUtils
 * 
 * Support methods for Google Drive API v2. 
 */
public class GoogleDriveUtils {

    public static final String CLASS_NAME = 'GoogleDriveUtils';
	public static final String FOLDER_MIME_TYPE = 'application/vnd.google-apps.folder';
	
	private static Map<Schema.SObjectType,Map<Id,String>> recordTypesCache;
	private static List<sObject> recordTypesResults;
	
	static {
	    recordTypesCache = new Map<Schema.SObjectType,Map<Id,String>>();
		recordTypesResults = new List<sObject>();
	}
    
    /**
     * Returns the active Google Drive Opportunity Configuration custom metadata record.
     * If more than one record is found to be active, only one configuration is returned.
     * 
     * @return the GoogleDriveOpportunityConfiguration record
     */
    public static GoogleDriveOpportunityConfiguration__mdt getActiveOpportunityConfiguration() {
        GoogleDriveOpportunityConfiguration__mdt config = [SELECT RootFolder__c, GoogleDriveConnectorTypeName__c, DefaultBillingStateCount__c, EmailAlert__c
															FROM GoogleDriveOpportunityConfiguration__mdt
															WHERE Active__c = TRUE
															LIMIT 1];        
        return config;
    }
    
    /**
     * Returns the configured subfolders for each opportunity record type, keyed by record type name.
     * 
     * @return a map of subfolders keyed by record type name
     */
    public static Map<String,String> getSubfoldersByOpportunityRecordTypes() {
    	Map<String, String> subfoldersMap = new Map<String, String>();
    	for (GoogleDriveOpportunityRecordType__mdt record : [SELECT DeveloperName__c, Subfolders__c FROM GoogleDriveOpportunityRecordType__mdt]) {
    		subfoldersMap.put(record.DeveloperName__c, record.Subfolders__c);
    	}        
        return subfoldersMap;
    }
    
    /**
     * Returns the GoogleDriveConnectorService for a given Google Drive Connector Type's Name.
     * 
     * @param connectorTypeName The Name of a Google Drive Connector Type 
     * 
     * @return the GoogleDriveConnectorService or null if it isn't found
     */
    public static GoogleDriveConnectorService getConnectorService(String connectorTypeName) {
        try {
            GoogleDriveConnector__c c = [
                SELECT 
                c.TokenType__c, c.RefreshToken__c, c.RefreshTokenRequested__c, c.Name, c.Id, c.AccessToken__c, 
                c.AccessTokenRequested__c, c.AccessTokenExpiry__c, c.Active__c, 
                GoogleDriveConnectorType__r.TokenEndpoint__c, GoogleDriveConnectorType__r.Scope__c, GoogleDriveConnectorType__r.ScopeRequired__c, 
                GoogleDriveConnectorType__r.RedirectUri__c, GoogleDriveConnectorType__r.Name, GoogleDriveConnectorType__r.Id, 
                GoogleDriveConnectorType__r.ExtraUrlParameters__c, GoogleDriveConnectorType__r.DeveloperName__c, 
                GoogleDriveConnectorType__r.ClientSecret__c, GoogleDriveConnectorType__r.ClientId__c, GoogleDriveConnectorType__r.CallbackURL__c, 
                GoogleDriveConnectorType__r.AuthorizationEndpoint__c
                FROM GoogleDriveConnector__c c
                WHERE GoogleDriveConnectorType__r.Name =: connectorTypeName
                LIMIT 1
            ];
            
            if (c != null) {
                return new GoogleDriveConnectorService(c);
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, CLASS_NAME + ': getConnectorService exception: ' + e.getMessage() + ' for connector type named: ');
        }
        
        return null;
    }
    
    /**
     * Answers if the GoogleDriveConnectorService is found to be in a good state.
     * 
     * @param connectorService The Google Drive Connector Service to verify
     * 
     * @return true if valid, false otherwise
     */
    public static Boolean isConnectorValid(GoogleDriveConnectorService connectorService) {
        String message = connectorService.validateConnector();
        if (String.isEmpty(message)) {
            System.debug(LoggingLevel.INFO, CLASS_NAME + ': Google Drive connector is valid');
            return true;            
        } else {
            System.debug(LoggingLevel.ERROR, CLASS_NAME + ': Google Drive connector is not valid. ' + message);
            return false;
        }
    }
    
    /**
     * Creates a folder for a given name and within a given parent.
     * 
     * @param ffhttp_GoogleDriveFiles The Google Drive Files API class
     * @param ffhttp_GoogleDriveModelParent The parent
     * @param String folderName The name of the folder to create
     * 
     * @return the created folder
     */
    public static ffhttp_GoogleDriveModelFile createFolder(ffhttp_GoogleDriveFiles files, ffhttp_GoogleDriveModelParent parent, String folderName) {
        ffhttp_GoogleDriveModelParent [] parents = new ffhttp_GoogleDriveModelParent [] {parent};
		ffhttp_GoogleDriveModelFile folder = new ffhttp_GoogleDriveModelFile();
		folder.setTitle(folderName);
        folder.setParents(new ffhttp_GoogleDriveModelParent [] {parent});
		folder.setMimeType(FOLDER_MIME_TYPE);
		if (Test.isRunningTest()) {
			System.debug('Running in test mode');
		} else {
        	folder = (ffhttp_GoogleDriveModelFile) files.insertRequest(folder, null).execute();
		}
        return folder;
    }
    
    /**
     * Returns a folder for a given name.
     * 
     * @param ffhttp_GoogleDriveFiles The Google Drive Files API class
     * @param ffhttp_GoogleDriveModelParent The parent
     * @param String folderName The name of the folder to find
     * 
     * @return the found folder or null
     */
    public static ffhttp_GoogleDriveModelFile getFolder(ffhttp_GoogleDriveFiles files, ffhttp_GoogleDriveModelParent parent, String folderName) {
    	ffhttp_GoogleDriveFiles.ListRequest request = files.listRequest();
    	if (parent != null) {
			request.setQ('title = \'' + folderName + '\' and \'' + parent.getId() + '\' in parents and mimeType = \'' + FOLDER_MIME_TYPE + '\' and trashed = false');
    	} else {
    		request.setQ('title = \'' + folderName + '\' and mimeType = \'' + FOLDER_MIME_TYPE + '\' and trashed = false');
    	}
		
		ffhttp_GoogleDriveModelFile.ItemList folders = null;
		Integer found = 0;
		
		if (Test.isRunningTest()) {
			if (folderName.equals('1')) {
				return new ffhttp_GoogleDriveModelFile();
			} else if (folderName.equals('>')) {
				found = 2;
			}
		} else {
			folders = (ffhttp_GoogleDriveModelFile.ItemList) request.execute();
			found = folders.getItems().size();
		}
		
        if (found == 0) {
            return null;
        } else if (found > 1) {
            System.debug(LoggingLevel.WARN, 'Found more than one folder named ' + folderName + '! Using the first folder out of ' + found + ' found.');
        }
        
        if (Test.isRunningTest()) {
        	return new ffhttp_GoogleDriveModelFile();	
        } else {
        	return (ffhttp_GoogleDriveModelFile) folders.getItems().get(0);
        }
    }
    
	/**
	* Returns a map of active, user-available RecordType IDs for a given SObjectType,
	* keyed by each RecordType's unique, unchanging DeveloperName
	* 
	* @param the SobjectType
	* @return a map of record type developer names with their IDs
	* 
	* @see https://salesforce.stackexchange.com/questions/11968/what-would-be-the-best-approach-to-get-the-recordtype-id
	*/	
	private static Map<Id, String> getRecordTypeMapForObject(Schema.SObjectType token) {
		Map<Id, String> mapRecordTypes = recordTypesCache.get(token);
		if (mapRecordTypes == null) {
			mapRecordTypes = new Map<Id, String>();
			recordTypesCache.put(token, mapRecordTypes);
		} else {
			return mapRecordTypes;
		}

		Schema.DescribeSObjectResult obj = token.getDescribe();

		if (recordTypesResults == null || recordTypesResults.isEmpty()) {
			String soql = 'SELECT Id, Name, DeveloperName, sObjectType FROM RecordType WHERE IsActive = TRUE';
        	try {
            	recordTypesResults = Database.query(soql);
        	} catch (Exception ex) {
            	recordTypesResults = new List<SObject>();
        	}
    	}

	    Map<Id,Schema.RecordTypeInfo> recordTypeInfos = obj.getRecordTypeInfosByID();
		for (SObject recordType : recordTypesResults) { 
        	if (recordTypeInfos.get(recordType.Id) != null) {
				if (recordTypeInfos.get(recordType.Id).isAvailable()) {
					mapRecordTypes.put(recordType.Id, String.valueOf(recordType.get('DeveloperName')));
				} else {
	                System.debug('The record type ' + recordType.get('DeveloperName') + ' for object ' + recordType.get('sObjectType') + ' is not availiable for the user.');
    	        }
        	}
		}

		return mapRecordTypes;
	}
	
	public static String getOpportunityRecordTypeById(Id id) {
		Map<Id, String> recordTypes = getRecordTypeMapForObject(Opportunity.SObjectType);
		return recordTypes.get(id);
	}
}