@isTest
private class AccountDuplicateCheckTrigger_TC{

    static testMethod void validateaccount() {
	    RecordType rt = [select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1];
	    Account acc = new Account();
	    acc.lastname ='test';
	    acc.firstname = 'first';
	    acc.Email_Address__c = 'test@gmail.com';
	    acc.Phone = '1234567890';
	    acc.BillingStateCode = 'AZ';
	    acc.recordtypeid =rt.id;
	    insert acc;
	    
	    Account acc1 = new Account();
	    acc1.lastname ='test';
	    acc1.firstname = 'first';
	    acc1.Email_Address__c = 'test@gmail.com';
	    acc1.Phone = '1234567890';
	    acc1.BillingStatecode = 'AZ';
	    acc1.recordtypeid =rt.id;
	    try {
	    	upsert acc1; 
	    } catch (exception e) {
	    	system.debug(e + ' successfully caught dupe');
	    }
    
    
    }
 }