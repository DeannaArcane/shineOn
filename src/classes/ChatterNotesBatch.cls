global class ChatterNotesBatch implements Database.Batchable<sObject>, Database.Stateful {

	public List<Id> FeedItemIds;
	public List<Id> getFeedItemIds() {
		if (FeedItemIds == null)
			FeedItemIds = new List<Id>();
		return FeedItemIds;
	}

	global ChatterNotesBatch() {
		
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, Body, ParentId, CreatedBy.Name FROM FeedItem WHERE Type = \'TextPost\'';


		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<FeedItem> scope) {

   		// If the scope is larger than 1, notes will not be created properly
		if (scope.size() != 1)
			throw new LimitException('Batch size should be set to one record at a time.');

		FeedItem itm = scope.get(0);

		// If the chatter post is related to a project create a note and delete the post
		if (itm.ParentId.getSObjectType() == Schema.Opportunity.SObjectType) {
			Core.CreateNote('Chatter Post By: ' + itm.CreatedBy.Name, itm.Body.replace('<p>', '').replace('</p>', '\r\n'), itm.ParentId);
			getFeedItemIds().add(itm.Id);
		}
	}

	global void finish(Database.BatchableContext BC) {
		/*List<FeedItem> feedItemsToDelete = new List<FeedItem>();

		// Delete the feed items for which a note was created
		for (Id taskId : getFeedItemIds())
			feedItemsToDelete.add(new FeedItem(Id = taskId));

		delete feedItemsToDelete;*/
	}


}