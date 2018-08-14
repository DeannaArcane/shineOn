@isTest
public class TestPremierNotes {
    static testMethod void test1() {
        // cover constructor
        PremierNotes p = new PremierNotes();
        
        // create notesubjects to pull
        list<NoteSubject__c> testSubs = new list<NoteSubject__c>();
        testSubs.add(new NoteSubject__c(Name = 'test', AllowedObjects__c = 'Account'));
        testSubs.add(new NoteSubject__c(Name = 'another test', AllowedForAllObjects__c = true));
        insert testSubs;
        
        // create account for insert of note later
        Account a = new Account (Name = 'test', BillingState = 'Pennsylvania');
        insert a;
        
        // start tests
        test.startTest();
        
        // get notesubs for account, both above, plus the --None-- standard entry = 3
        list<String> testGetSubsOne = PremierNotes.getSubjects('Account');
        system.assert(testGetSubsOne.size() == 3);
        
        // only the allowedforallobjects=true from above plus the --None-- standard entry = 2
        list<String> testGetSubsTwo = PremierNotes.getSubjects('Contact');
        system.assert(testGetSubsTwo.size() == 2);
        
        // insert a note
        PremierNotes.takeInput(testGetSubsOne[1], 'test', a.Id);
        test.stopTest();
    }
}