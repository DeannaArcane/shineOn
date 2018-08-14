public with sharing class Core {

	// overload to accept subject body and object Id with default visibility and share settings
	public static void CreateNote(String subject, String body, String objId) {
		list<ContentNoteLinkWrapper> links = new List<ContentNoteLinkWrapper>();
		links.add(new ContentNoteLinkWrapper(objId, 'AllUsers', 'I'));
		CreateNote(subject, body, links);
	}
	
	// overload to accept subject body and single contentnotelinkwrapper
	public static void CreateNote(String subject, String body, ContentNoteLinkWrapper link) {
		List<ContentNoteLinkWrapper> links = new List<ContentNoteLinkWrapper>{link};
		CreateNote(subject, body, links);
	}

	// main content note creation
    public static void CreateNote(String subject, String body, List<ContentNoteLinkWrapper> links) {
      
        // instantiate new note
        ContentNote cn = new ContentNote();

        // title cannot be null
        // move ternary here
        cn.Title = (Subject != null && Subject != '') ? Subject : 'No Subject Specified';
 
        // sf content blobs don't like some html characters, is fine with some others
        cn.Content = Blob.valueOf(body.escapeXML().replace('\r\n', '<br>').replace('\r', '<br>').replace('\n', '<br>').replace('&apos;', '&#39;'));
		
       
        // insert note with db.insert to get success/fail message
        Database.SaveResult sr = Database.insert(cn);

        // note was saved successfully
        if (sr.isSuccess()) {
        	if (links != null && !links.isEmpty()) {
        		// ContentDocumentLink list to insert
        		List<ContentDocumentLink> cnList = CreateLinks(cn.Id, links);

			if (!cnList.isEmpty())
        			insert cnList;
        	}
    	}

    }

    // List of notes that have not been inserted
    public static List<ContentNote> UncommittedNotes;
    public static List<ContentNote> getUncommittedNotes() {
        if (UncommittedNotes == null)
            UncommittedNotes = new List<ContentNote>();
        return UncommittedNotes;
    }

    // Instantiates a ContentNote record and adds it to the list of UncommittedNotes
    public static void CreateUncommittedNote(String subject, String body) {
        // instantiate new note
        ContentNote cn = new ContentNote();

        // title cannot be null
        cn.Title = (subject != null && subject != '') ? subject : 'No Subject Specified';
 
        // sf content blobs don't like some html characters, is fine with some others
        cn.Content = Blob.valueOf(body.escapeXML().replace('\r\n', '<br>').replace('\r', '<br>').replace('\n', '<br>').replace('&apos;', '&#39;'));

        getUncommittedNotes().add(cn);
    }

    // Insert ContentNotes and corresponding ContentDocumentLinks related to the objId
    public static Boolean CommitNotes(Id objId) {
        // return value
        Boolean successfullyInsertedAllNotes;

        try {
            insert getUncommittedNotes();

            List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();

            // Loop through the save results and create a ContentDocumentLink linking the cd to the object with objId
            for (ContentNote cd : getUncommittedNotes())
                contentDocumentLinksToInsert.add(new ContentDocumentLink(LinkedEntityId = objId, ContentDocumentId = cd.Id, Visibility = 'AllUsers', ShareType = 'I'));

            insert contentDocumentLinksToInsert;

            // set success boolean
            successfullyInsertedAllNotes = true;

        } catch (Exception e) {
            successfullyInsertedAllNotes = false;
        }

        return successfullyInsertedAllNotes;
    }

    // linking mechanic
    public static List<ContentDocumentLink> CreateLinks(String noteId, List<ContentNoteLinkWrapper> links) {
      
        // see: https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentdocumentlink.htm#topic-title
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink> ();
        // loop and create links
        for (ContentNoteLinkWrapper cnw : links) {
        	ContentDocumentLink cdl = new ContentDocumentLink();

        	// link the link object to the note
        	cdl.ContentDocumentId = noteId;

        	// tell it what to link to by Id
        	cdl.LinkedEntityId = cnw.linkId;
        	cdl.Visibility = cnw.visibility;
        	cdl.ShareType = cnw.shareType;

        	cdlList.add(cdl);
        }

        return cdlList;
    }

    // Wrapper class for requests info
    public class ContentNoteLinkWrapper {
        public string linkId { get; set; }
        public string visibility { get; set; }
        public string shareType { get; set; }
        
        public ContentNoteLinkWrapper(String linkId, String visibility, String shareType) {
            this.linkId = linkId;
            this.visibility = visibility;
            this.shareType = shareType;
        }
    }


    // method used from triggers so that with a custom setting we can disable a trigger from running
    // this can be expanded into features of the trigger itself, or utility methods elsewhere. It's flexible.
    public static boolean CoreSettingActive(String settingName){
        CoreSetting__c core = CoreSetting__c.getInstance(settingName);
        if(core == null){
            // create the setting with default to active
            core = new CoreSetting__c(Name = settingName, Active__c = true);
            insert core;
        }
        return core.Active__c;
    }
}