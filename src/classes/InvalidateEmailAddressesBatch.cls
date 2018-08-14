/*  This batch is meant to be called from execute anonymous. 
  	It invalidates the email addresses for Contacts, Opportunities, and Acccount in a sandbox.
	
	Before running the batch it is advised to turn off validation rules so that all records are able to be updated
	It is also recommended to deactivate triggers to avoid errors in both update and delete. This is more important since
	it is possible to have records that were not able to be invalidated and cannot be deleted even if it was requested

	When calling the batch you need to specify the object api name and a flag whether or not to delete any records
	whose email addresses were not able to be updated. If the flag is set to false and records fail to update an exception
	wiil be thrown to signal the user and the failing execution's successful updates will be rolled back

	The code can be called in developer console like:

	Database.executeBatch(new InvalidateEmailAddressesBatch('Contact', true));
	Database.executeBatch(new InvalidateEmailAddressesBatch('Account', false));

	Once the batch has finished, manually verify that no records with valid emails remain, since the update/deletion could fail for reasons
	that cannot be prevented by this class
*/

global class InvalidateEmailAddressesBatch implements Database.Batchable<sObject> {
	
	// SObject name to be cleaned
	String myObject;	

	// Set of email field api names to invalidate
	Set<String> myFields;

	// Flag to delete records that failed update
	Boolean deleteFailures;
	
	// TODO: add an additional myDateTime parameter (represents LastModifiedDate) and use it as a LastModifiedDate < :myDateTime
	// TODO: use case for failures after batch completion, in order to rerun without records that were successful being reupdated
	global InvalidateEmailAddressesBatch(String obj, Boolean deleteFailures) {
		myObject = obj;
		this.deleteFailures = deleteFailures;

		// Get the SObjectType of the requested object
		Schema.SObjectType mySObjectType = Schema.getGlobalDescribe().get(myObject);

		// If object name was not valid and SObjectType not found throw an exception
		if (mySObjectType == null)
			throw new SObjectException('Invalid SObject name');
		else {

			// Initialize set of fields that need to be invalidated
			myFields = new Set<String>();

			// Create a list of DescribeFieldResults obtained by the SObjectFields
			List<Schema.DescribeFieldResult> describeFieldResultsList = new List<Schema.DescribeFieldResult>();
			for (Schema.SObjectField mySObjectField : mySObjectType.getDescribe().fields.getMap().values()) 
				describeFieldResultsList.add(mySObjectField.getDescribe());

			// Find all email fields and add them to the set of fields to invalidate
			for (Schema.DescribeFieldResult myDescribeFieldResult : describeFieldResultsList)
				if (myDescribeFieldResult.isAccessible() && myDescribeFieldResult.isUpdateable() && myDescribeFieldResult.getType() == Schema.DisplayType.EMAIL)
					myFields.add(myDescribeFieldResult.getName());

		}

	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {

		// If class is called in production throw an exception 
		if (!Test.isRunningTest() && ![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox)
			throw new LicenseException('You are attempting to invalidate email addresses in a production environment. This class should only be used in a sanbox!');
			
		String selector = '';
		String condition = '';

		// Add specified fields to the select and where parts of the query
		for (String myField : myFields) {
			selector += myField + ', ';
			condition += myField + ' != null OR '; 
		}

		selector = selector.removeEnd(', ');
		condition = condition.removeEnd(' OR ');

		// Set up the query
		String query = 'SELECT Id, ' + selector + ' FROM ' + myObject + ' WHERE ' + condition;

		return Database.getQueryLocator(query);
	}

	// Appending the sanbox name to the end of the email address. This should invalidate the email address.
   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		
   		// Get the sanbox name from the users login
   		// TODO: can append additional static text after the sandbox name eg 'invalidate'
		String sandboxName = UserInfo.getUserName().substringAfterLast('.');
		
		// Append the sanboxName to the email fields of all records
		for (sObject x : scope) 
			for (String myField : myFields) {
				String newEmail = (String) x.get(myField);

				// If preexisting email value was not blank append
				if (!String.isBlank(newEmail)) {
					newEmail += '.' + sandboxName;
					x.put(myField,newEmail);
					
				}
			}

		// Perform dml and store results
		List<Database.SaveResult> srList = database.update(scope, false);
        
		// Create a list of records that were not updated (Id needs to be obtained from scope because saveResult.getId() returns null if failure)
		List<Id> failedUpdateRecordIds = new List<Id>();
		for(Integer i = 0; i < scope.size(); i++) {
			if (!srList.get(i).isSuccess())
				failedUpdateRecordIds.add(scope.get(i).Id);
		}
        

        // If there are records that could not be updated
		if (!failedUpdateRecordIds.isEmpty())
			if (deleteFailures)
				// Delete records that were not updated
				List<Database.DeleteResult> drList = Database.delete(failedUpdateRecordIds, true);
			else
				// throw exception if there are records that were not updated and the deletion flag was set to false
				// Everything in the execution will be rolled back, including the successful updates
				// An easy way to detect the ones that failed is to sort by LastModifiedDate
				throw new DmlException('There were ' + failedUpdateRecordIds.size() + ' ' + myObject + ' records that could not be updated.');

	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}