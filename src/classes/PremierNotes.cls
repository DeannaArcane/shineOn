public with sharing class PremierNotes {
	
    // constructor
    public PremierNotes() {}
    
    // get pre-determined note subjects
    @AuraEnabled
	public static List<String> getSubjects(String objName) {
		
        // holds queried notesubject object, sort by name alphabetically
		List<NoteSubject__c> SubjectRecs = new List<NoteSubject__c>();
		SubjectRecs = [SELECT Id, Name FROM NoteSubject__c WHERE AllowedObjects__c INCLUDES (:objName) OR AllowedForAllObjects__c = true ORDER BY Name ASC];
		
        // list to return subject strings
        List<String> Subjects = new List<String>();
        
        // add in empty subject string, also helps in validation
        Subjects.add('--None--');
        for (NoteSubject__c n : SubjectRecs)
            Subjects.add(n.Name);
		
        return Subjects;
	}
    
    // take the input from the component
    @AuraEnabled
    public static void takeInput(String subj, String body, String recId) {
        system.debug('In takeInput: ' + subj + ' ' + body + ' ' + recId);
        
        Core.CreateNote(subj, body, recId);
    }
}