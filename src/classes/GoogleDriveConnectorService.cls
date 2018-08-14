/**
 * Copyright (c) 2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
 
/**
 * GoogleDriveConnectorService
 */
public with sharing class GoogleDriveConnectorService implements ffhttp_IConnectorType
{

	//Statics
	public static final String CLASS_NAME = 'GoogleDriveConnectorService';
	public static final Integer EXPIRY_HEADROOM_TIME_SECONDS = 600; //10 minutes
	
	//Instance variables
	public String connectorId { get; set; }
	public GoogleDriveConnector__c connector { get;set; }
	
	/**
	 * Constructor
	 */
	public GoogleDriveConnectorService(String connectorId)
	{
		this.connectorId = connectorId;
	}
	
	public GoogleDriveConnectorService(GoogleDriveConnector__c connector)
	{
		this.connector = connector;
	}
	
	/**
	 * Retrieve the connector for the given connectorId
	 *
	 * Note: for separation of concerns consider using a selector pattern.
	 * See https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Selector_Layer
	 */
	public GoogleDriveConnector__c retrieveConnector()
	{	
        if (connectorId == null)
		{
			return null;
		}
		
		if (connector == null)
		{
			connector = (GoogleDriveConnector__c)
			[
				SELECT c.TokenType__c, c.RefreshToken__c, c.RefreshTokenRequested__c, c.Name, c.Id, c.AccessToken__c, 
					   c.AccessTokenRequested__c, c.AccessTokenExpiry__c, c.Active__c, 
					   GoogleDriveConnectorType__r.TokenEndpoint__c, GoogleDriveConnectorType__r.Scope__c, GoogleDriveConnectorType__r.ScopeRequired__c, 
					   GoogleDriveConnectorType__r.RedirectUri__c, GoogleDriveConnectorType__r.Name, GoogleDriveConnectorType__r.Id, 
					   GoogleDriveConnectorType__r.ExtraUrlParameters__c, GoogleDriveConnectorType__r.DeveloperName__c, 
					   GoogleDriveConnectorType__r.ClientSecret__c, GoogleDriveConnectorType__r.ClientId__c, GoogleDriveConnectorType__r.CallbackURL__c, 
					   GoogleDriveConnectorType__r.AuthorizationEndpoint__c
				FROM GoogleDriveConnector__c c 
				WHERE c.Id = :connectorId
				LIMIT 1
			];
		}
		return connector;
	}
	
	/**
     * Determines whether the connector is valid.
     * Returns the appropriate error message. 
     */
    public String validateConnector()
    {
    	if (this.connector == null)
        {
        	return 'No connector found.';
        }
        else if (this.connector.AccessToken__c == null)
        {
        	return 'The connector ' + connector.Name + ' has not been authorized.';
        }
        else if (accessTokenExpired())
        {
        	if (connector.RefreshToken__c == null)
        	{
        		return 'The connector ' + connector.Name + ' needs to be reauthorized.';
        	}
        	else
        	{
	        	//In this case the access_token has expired and needs reauthorising.
	        	//Given that we have the refresh token we can use an OAuthClient call to do this.
	        	if (Test.isRunningTest()) {
	        		System.debug('Running in test mode');
	        	} else {
	        		exchangeCode(connector.RefreshToken__c, false);
	        	}
        	}
        }
        
        return null;
    }
    
    /**
     * Check whether the access token has expired.
     * If a token is within 10 minutes of expiring then deal with it as if it has expired.
     */
    @testVisible
    private Boolean accessTokenExpired()
    {
    	//If we don't know when the token was requested, or when it will expire, then treat it like it hasn't expired.
    	DateTime accessTokenRequested = connector.AccessTokenRequested__c;
    	Integer accessTokenExpiry = (Integer)connector.AccessTokenExpiry__c;
    	if (accessTokenRequested == null
    	  || accessTokenExpiry == null)
    	{
    		return false;
    	}
    	
    	Integer cutoff = accessTokenExpiry - EXPIRY_HEADROOM_TIME_SECONDS;
    	
    	DateTime dtNow = System.now();
    	DateTime dtExpiry = accessTokenRequested.addSeconds(cutoff);
    	return dtExpiry < dtNow;
    }
    
    public void exchangeCode(String code, boolean authCode)
    {
    	connector.AccessTokenRequested__c = System.now();
		connector.RefreshTokenRequested__c = connector.AccessTokenRequested__c;
		
		ffhttp_OAuthClient client = new ffhttp_OAuthClient();
		
		ffhttp_OAuthClient.AccessTokenResponse response = new ffhttp_OAuthClient.AccessTokenResponse();
		
		if (authCode)
		{
			if (Test.isRunningTest()) {
				System.debug('Running in test mode');
			} else {
				ffhttp_OAuthClient.ExchangeAuthCodeRequest accessRequest = client.exchangeAuthCodeRequest(this, code);
				response = (ffhttp_OAuthClient.AccessTokenResponse)accessRequest.execute();
			}
		}
		else
		{
			if (Test.isRunningTest()) {
				System.debug('Running in test mode');
			} else {
				ffhttp_OAuthClient.ExchangeRefreshTokenRequest refreshRequest = client.exchangeRefreshTokenRequest(this, code);
				response = (ffhttp_OAuthClient.AccessTokenResponse)refreshRequest.execute();
			}
		}
		
		System.debug(CLASS_NAME + ': refresh token received: ' + response.refresh_token);
    	connector.AccessToken__c = response.access_token;
    	
    	if (String.isNotBlank(response.refresh_token)) {
    		System.debug(CLASS_NAME + ': saving refresh token');
	    	connector.RefreshToken__c = response.refresh_token;
    	} else {
    		System.debug(CLASS_NAME + ': refresh token not saved, as it was empty');
    	}
	    connector.TokenType__c = response.token_type;
	    connector.AccessTokenExpiry__c = response.expires_in;
    }
    
    /**
     * Returns the access token for this connector
     */
	public String getAccessToken()
	{	
		if (validateConnector() != null)
		{
			return null;
		}
		
		return connector.AccessToken__c;
	}

	/**
	 * IConnectorType implementation
	 */
	public String getAuthorizationEndpoint()
	{
		return connector == null ? null : connector.GoogleDriveConnectorType__r.AuthorizationEndpoint__c;
	}
	public String getTokenEndpoint()
	{
		return connector == null ? null : connector.GoogleDriveConnectorType__r.TokenEndpoint__c;
	}
	public String getClientId()
	{
		return connector == null ? null : connector.GoogleDriveConnectorType__r.ClientId__c;
	}
	public String getClientSecret()
	{
		return connector == null ? null : connector.GoogleDriveConnectorType__r.ClientSecret__c;
	}
	public String getRedirectUri()
	{
		return connector == null ? null : connector.GoogleDriveConnectorType__r.RedirectUri__c;
	}
	public String getExtraUrlParameters()
	{
		if (connector == null)
		{ 
			return '';
		}
		
		if (connector.GoogleDriveConnectorType__r.ScopeRequired__c == true)
		{
			return 'scope=' + connector.GoogleDriveConnectorType__r.Scope__c + '&' + connector.GoogleDriveConnectorType__r.ExtraUrlParameters__c;
		}
		
		if (!String.isEmpty(connector.GoogleDriveConnectorType__r.ExtraUrlParameters__c))
		{
			return connector.GoogleDriveConnectorType__r.ExtraUrlParameters__c;
		}
		
		return '';
	}
}