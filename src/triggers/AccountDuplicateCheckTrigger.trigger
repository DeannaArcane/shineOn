trigger AccountDuplicateCheckTrigger on Account (before insert) {


       //Preparing Account names in Set from trigger.new

        Set<String> nameSetfirst = new Set<String>();
        Set<String> nameSetlast = new Set<String>();

        for(Account acc : trigger.new){
            nameSetfirst.add(acc.firstname);
            nameSetlast.add(acc.lastname); 
        }

        // getting the list of accounts in database  with the account name we entered ( trigger.new)

        List<Account> accList = new List<Account>(
            [select id,firstname,lastname,ispersonaccount from Account where ispersonaccount = true and firstname in: nameSetfirst and lastname in:nameSetlast ]);

        Map<Id,RecordType> rtype = new Map<Id, RecordType>([select id, Name from RecordType where SObjectType = 'Account' and DeveloperName = 'PersonAccount']);
        for(Account a : trigger.new){
            string newUnqStr = '';
            if(a.LastName != null) newUnqStr = newUnqStr + a.LastName.trim();
            if(a.BillingCity != null) newUnqStr = newUnqStr + a.BillingCity.trim();
            if(a.BillingState != null) newUnqStr = newUnqStr + a.BillingState.trim();
            if(rtype.ContainsKey(a.RecordTypeId)) {
            	for(Account ac : accList ){
            		string oldUnqStr = '';
		            if(a.LastName != null) oldUnqStr = oldUnqStr + a.LastName.trim();
		            if(a.BillingCity != null) oldUnqStr = oldUnqStr + a.BillingCity.trim();
		            if(a.BillingState != null) oldUnqStr = oldUnqStr + a.BillingState.trim();
		            if(oldUnqStr == newUnqStr){
	            	    a.addError('Account already exists in your Organization with this Account Name and Billing Address');
		            }
            	}
            }
        }

}