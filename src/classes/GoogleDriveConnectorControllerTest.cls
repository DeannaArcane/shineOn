@isTest
private class GoogleDriveConnectorControllerTest {

    static testMethod void GoogleDriveConnectorControllerConstructorTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
    }
    
	static testMethod void GoogleDriveConnectorControllerSaveTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
        connectorController.save();
    }
    
	static testMethod void GoogleDriveConnectorControllerCancelTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
        connectorController.cancel();
    }
    
	static testMethod void GoogleDriveConnectorControllerRequestAuthorizationCodeTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
        
        connectorController.RequestAuthorizationCode();        
    }
    
	static testMethod void GoogleDriveConnectorControllerGettersTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController.getServiceName());
        System.assertNotEquals(null, connectorController.getRecordName());
		System.assert(!connectorController.getIsAuthorized());
		System.assert(!connectorController.getIsDirty());
		System.assert(connectorController.getIsConfigured());
    }
    
	static testMethod void GoogleDriveConnectorControllerGetConnectorIdTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('state', String.valueOf(connector.Id));

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
    }
    
	static testMethod void GoogleDriveConnectorControllerBadConnectorIdTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('state', 'BadId');

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
    }
    
	static testMethod void GoogleDriveConnectorControllerExchangeCodeTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('state', String.valueOf(connector.Id));
        pageRef.getParameters().put('code', '1234');        

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
    }
    
	static testMethod void GoogleDriveConnectorControllerErrorTest() {
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

        PageReference pageRef = Page.GoogleDriveConnector;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('error', 'error');        

        ApexPages.StandardController standardController = new ApexPages.StandardController(connector);
        GoogleDriveConnectorController connectorController = new GoogleDriveConnectorController(standardController);
        System.assertNotEquals(null, connectorController);
    }
    
}