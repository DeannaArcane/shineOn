@isTest
private class TestProjectDetail {
	
    @isTest static void test_method_one() {
		
        TestDataUtility.CreateData();
        if (TestDataUtility.dataCreated) {
        
        	// create pfd rec
        	ProjectFieldDisplay__c p = new ProjectFieldDisplay__c();
        	p.name = 'Install Only';
        	p.ProjectRecordTypeId__c =TestDataUtility.utilOpportunities[0].RecordTypeId;
        	p.Section1Label__c = 'Project Info';
        	p.Section1Tab__c = 'Project Info';
        	p.Section1__c = 'name;recordtypeid;BLANK;accountid';
                p.Section1Order__c = 1;
        	insert p;
	
        	// start functionality/coverage testing
        	// instantiate controller
        	ProjectDetail pd = new ProjectDetail();
        	
        	// populate required info
        	pd.TabName = 'Project Info';
        	pd.RecordId = TestDataUtility.utilOpportunities[0].Id;
        	pd.RTypeId = TestDataUtility.utilOpportunities[0].RecordTypeId;
        	
        	// coverage
        	pd.editMode = false;
        	pd.ReloadMainPage = false;
        	string s = pd.ReloadURL;
        	
        	// test bulk of field gathering and query building
        	boolean test = pd.isMapEmpty;
        	system.debug('before assert: ' + test);
        	// make sure the field map isn't empty
        	system.assert(!test);
	
        	// test opp query builder and query
        	Opportunity o = pd.TheProject;
        	// make sure the opp gathered in the class matches the opp created here
        	system.assertEquals(TestDataUtility.utilOpportunities[0].Id, o.id);
	
        	// action tests
        	// edit mode test
        	pd.goEdit();
        	// make sure edit mode was activated
        	system.assert(pd.editMode);
        	
        	pd.Cancel();
        	// make sure edit mode was deactivated
        	system.assert(!pd.editMode);
	
        	// switch record type
        	RecordType rt4 = [SELECT id,Name 
        	                         FROM RecordType 
        	                         WHERE SobjectType='opportunity' AND Name='Partial EPC'];
	
        	pd.TheProject.RecordTypeId = rt4.Id;
        	pd.Save();
        	// test that the op in the class was updated
        	system.assertNotEquals(TestDataUtility.utilOpportunities[0].RecordTypeId, pd.TheProject.RecordTypeId);
        	Opportunity reopp = [SELECT id, RecordTypeId FROM Opportunity WHERE id = :TestDataUtility.utilOpportunities[0].Id];
        	system.assertEquals(reopp.RecordTypeId, pd.TheProject.RecordTypeId);

            pd.editModeCancel();
            pd.editModeSave();
        }
	}
		
}