@isTest
private class GoogleDriveUtilsTest {

    static testMethod void getActiveOpportunityConfigurationTest() {
    }
    
	static testMethod void getConnectorServiceTestReturnNewGoogleDriveConnectorService() {
		GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
		type.Name = 'test';
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.AccessToken__c = '1234';
		connector.AccessTokenRequested__c = Date.today();
        connector.AccessTokenExpiry__c = 200;
        connector.RefreshToken__c = '1234';

        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
		
		GoogleDriveConnectorService service = GoogleDriveUtils.getConnectorService('test');
		System.assertNotEquals(null, service);
    }
    
	static testMethod void getConnectorServiceExceptionTest() {
		GoogleDriveConnectorService service = GoogleDriveUtils.getConnectorService('does not exist');
		System.assertEquals(null, service);
    }

	static testMethod void getIsConnectorValidConnectorValidTest() {
		GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
		type.Name = 'test';
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.AccessToken__c = '1234';
		connector.AccessTokenRequested__c = Date.today();
        connector.AccessTokenExpiry__c = 200;
        connector.RefreshToken__c = '1234';

        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
   		GoogleDriveConnectorService service = GoogleDriveUtils.getConnectorService('test');

		System.assert(GoogleDriveUtils.isConnectorValid(service));
    }
    
	static testMethod void getIsConnectorValidConnectorInvalidTest() {
		GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
		type.Name = 'test';
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.AccessToken__c = '1234';
		connector.AccessTokenRequested__c = Date.today();
        connector.AccessTokenExpiry__c = 200;
        connector.RefreshToken__c = null;

        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
		
		GoogleDriveConnectorService service = GoogleDriveUtils.getConnectorService('test');
		System.assertEquals(false, GoogleDriveUtils.isConnectorValid(service));
    }
    
	static testMethod void getCreateFolderTest() {
		ffhttp_GoogleDriveFiles files = new ffhttp_GoogleDriveFiles(null);
		ffhttp_GoogleDriveModelParent parent = new ffhttp_GoogleDriveModelParent();
		String folderName = 'folderName';
		
		ffhttp_GoogleDriveModelFile folder = GoogleDriveUtils.createFolder(files, parent, folderName); 
		System.assertNotEquals(null, folder);
    }
    
	static testMethod void getGetFolderNotFoundTest() {
		ffhttp_GoogleDriveFiles files = new ffhttp_GoogleDriveFiles(null);
		String folderName = 'not found';
		
		ffhttp_GoogleDriveModelFile folder = GoogleDriveUtils.getFolder(files, null, folderName);
		System.assertEquals(null, folder);
    }
    
	static testMethod void getGetFolderFoundMoreThanOneTest() {
		ffhttp_GoogleDriveFiles files = new ffhttp_GoogleDriveFiles(null);
		String folderName = '>';
		
		ffhttp_GoogleDriveModelFile folder = GoogleDriveUtils.getFolder(files, null, folderName);
		System.assertNotEquals(null, folder);
    }

	static testMethod void getGetFolderFoundOneTest() {
		ffhttp_GoogleDriveFiles files = new ffhttp_GoogleDriveFiles(null);
		String folderName = '1';
		
		ffhttp_GoogleDriveModelFile folder = GoogleDriveUtils.getFolder(files, null, folderName);
		System.assertNotEquals(null, folder);
    }
    
}