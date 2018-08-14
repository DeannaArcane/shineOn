@isTest
private class GoogleDriveConnectorServiceTest {
	
	static testMethod void retrieveConnectorNoConnectorSetTest() {
    	String connectorId = 'id';
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connectorId);
        service.connectorId = null;
    	System.assertEquals(null, service.retrieveConnector());
    }
    
	static testMethod void retrieveConnectorFoundConnectorSetTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	String connectorId = connector.Id;
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connectorId);
        
        GoogleDriveConnector__c c = service.retrieveConnector();
    	System.assertEquals(connectorId, c.Id);
    }

    static testMethod void validateConnectorNullConnectorTest() {
    	String connectorId = '123456789012345678';
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connectorId);
        service.connectorId = null;
    	System.assertEquals('No connector found.', service.validateConnector());
    }
    
	static testMethod void validateConnectorNullAccessTokenConnectorTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals('The connector ' + connector.Name + ' has not been authorized.', service.validateConnector());
    }
    
    static testMethod void accessTokenExpiredUnknownRequestTimeTest() {
		GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
        System.assertEquals(false, service.accessTokenExpired());
    }
    
    static testMethod void accessTokenExpiredHasRequestTimeTest() {
		GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.AccessTokenRequested__c = Date.today();
        connector.AccessTokenExpiry__c = 200;
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
        System.assertEquals(true, service.accessTokenExpired());
    }

    static testMethod void getAccessTokenTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        String accessToken = 'abcd';
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.AccessToken__c = accessToken;
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(accessToken, service.getAccessToken());
    }
    
    
	static testMethod void getAccessTokenValidateConnectorNullTest() {
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService('');
        service.connectorId = null;
        
    	System.assertEquals(null, service.getAccessToken());
    }
    
	static testMethod void getAuthorizationEndpointTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.getAuthorizationEndpoint());
    }
    
	static testMethod void getTokenEndpointTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.getTokenEndpoint());
    }
    
	static testMethod void getClientIdTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.getClientId());
    }
    
	static testMethod void getClientSecretTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.getClientSecret());
    }
    
	static testMethod void getRedirectsUriTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.getRedirectUri());
    }
    
	static testMethod void getExtraUrlParametersTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals('', service.getExtraUrlParameters());
    }
    
    
	static testMethod void validateConnectorNullRefreshTokenTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
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
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals('The connector ' + connector.Name + ' needs to be reauthorized.', service.validateConnector());
    }
    
	static testMethod void validateConnectorExchangeCodeTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
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
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	System.assertEquals(null, service.validateConnector());
    }
    
	static testMethod void exchangeCodeHasAuthCodeTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	service.exchangeCode('1234', true);
    }
    
	static testMethod void exchangeCodeNoAuthCodeTest() {
        GoogleDriveConnectorType__c type = new GoogleDriveConnectorType__c();
        type.AuthorizationEndpoint__c = 'authorizationEndpoint';
        type.ClientId__c = 'clientId';
        type.ClientSecret__c = 'clientSecret';
        type.RedirectUri__c = 'redirectUri';
        type.TokenEndpoint__c = 'tokenEndpoint';
        insert type;
        
        GoogleDriveConnector__c connector = new GoogleDriveConnector__c();
        connector.Name = 'Google Test';
        connector.GoogleDriveConnectorType__c = type.Id;
        insert connector;
        
    	GoogleDriveConnectorService service = new GoogleDriveConnectorService(connector);
    	service.exchangeCode('1234', false);
    }
}