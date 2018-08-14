@isTest
public with sharing class TestCore {
	static testMethod void testNotes() {

		// create account
		Account a = new Account(
			FirstName = 'Test', 
			Lastname = 'Test',
			BillingState = 'Pennsylvania'
		);
        insert a;
		
		// create opp
		Opportunity o = new Opportunity(
			Name = 'Test Opp', 
			Job_Num__c = 'PA-11000', 
			AccountId = a.Id, 
			StageName = 'Admin Processing',
			CloseDate = system.today()
		);
        insert o;

        // strings to pass
        String subject = 'test subj';
        String body = 'body body body body';

        // create note single id
        Core.CreateNote(subject, body, a.Id);

        // create note wrapper
        Core.ContentNoteLinkWrapper cnlw = new Core.ContentNoteLinkWrapper(a.Id, 'AllUsers', 'I');

        // send to overflow for wrapper use
        Core.CreateNote(subject, body, cnlw);

        // list of wrappers
        list<Core.ContentNoteLinkWrapper> cnlwList = new list<Core.ContentNoteLinkWrapper>();
        cnlwList.add(new Core.ContentNoteLinkWrapper(a.Id, 'AllUsers', 'I'));
        cnlwList.add(new Core.ContentNoteLinkWrapper(o.Id, 'AllUsers', 'I'));

        // send to main create note
        Core.CreateNote(subject, body, cnlwList);

        Core.CreateUncommittedNote(subject, body);
        Core.CommitNotes(o.Id);

	}
}