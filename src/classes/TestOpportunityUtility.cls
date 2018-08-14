@isTest
private class TestOpportunityUtility {
	
	// purely replacing coverage from deprecating smsmagic
	@isTest static void test_method_one() {
        	TestDataUtility.CreateData();
                if (TestDataUtility.dataCreated) {
        		Opportunity Op1 = TestDataUtility.utilOpportunities[2];
        	
        		Op1.Project_Design_Complete__c = system.today();
                	Op1.Countersign_Date__c = system.today();
                	Op1.Project_Design_Complete__c = system.today();
                	Op1.Drawings_Sent_To_Customer__c = system.today();
                	Op1.Permits_Submitted__c = system.today();
                	Op1.Permits_Approved__c = system.today();
                	Op1.HOA_Submitted__c = system.today();
                	Op1.HOA_Approval__c = system.today();
                        Op1.Derate_MPU__c = 'None';
                        Op1.Jurisdiction__c = 'JSD';        	
                        Op1.Jurisdiction_Completed_Date__c = system.today();
                        Op1.Received_From_Underwriting__c = system.today();
                        Op1.Permit_Number__c = '123';
                        op1.StageName = 'Design Approval';
                        Update Op1;
        	
                	Opportunity Op2 = TestDataUtility.utilOpportunities[3];
        	
                	Op2.Project_Design_Complete__c = system.today();
                	Op2.Countersign_Date__c = system.today();
                	Op2.Project_Design_Complete__c = system.today();
                	Op2.Drawings_Sent_To_Customer__c = system.today();
                	Op2.Permits_Submitted__c = system.today();
                	Op2.Permits_Approved__c = system.today();
                	Op2.HOA_Submitted__c = system.today();
                	Op2.HOA_Approval__c = system.today();
                        Op2.Derate_MPU__c = 'None';
                        Op2.Jurisdiction__c = 'JSD';
                        Op2.Jurisdiction_Completed_Date__c = system.today();
                        Op2.Received_From_Underwriting__c = system.today();
                        Op2.Permit_Number__c = '123';
                        op2.StageName = 'Ready to Install';
                	Update Op2;
                }
	}
	
	
}