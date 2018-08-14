@isTest
private class testInvalidateEmailAddressesBatch {
    
    static String sandboxName = UserInfo.getUserName().substringAfterLast('.');

    static testMethod void testInvalidateEmailAddressesAccount() {
        Account x = new Account();
        x.Name = 'test123';
        x.Email_Address__c = 'test123@salesforcetest.com';
        x.BillingState = 'Pennsylvania';
        x.RecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1][0];
        x.Phone = '1234567890';

        insert x;

        Test.startTest();
            Database.executeBatch(new InvalidateEmailAddressesBatch('Account', true));
        Test.stopTest();

        // There should just be 1
        for (Account i : [SELECT Email_Address__c FROM Account WHERE Name = 'test123'])
            x = i;

        // Confirming the sandbox name was appended to the end of the email address.
        System.assert(x.Email_Address__c.substringAfterLast('.') == sandboxName);
            
    }
    
    static testMethod void testInvalidateEmailAddressesContact() {
        Contact x = new Contact();
        x.LastName = 'test123';
        x.Email = 'test123@salesforcetest.com'; 
        insert x;

        Test.startTest();
            Database.executeBatch(new InvalidateEmailAddressesBatch('Contact', true));
        Test.stopTest();

        // There should just be 1
        for (Contact i : [SELECT Email FROM Contact WHERE LastName = 'test123'])
            x = i;

        // Confirming the sandbox name was appended to the end of the email address.
        System.assert(x.Email.substringAfterLast('.') == sandboxName);
    }

}