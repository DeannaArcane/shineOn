@isTest
public class TestDataUtility {
	// lets us know the data was created
	public static boolean dataCreated = true;

	// accounts
	public static List<Account> utilAccounts;
	
	// contacts
	public static List<Contact> utilContacts;
    public static Contact jurisdictionContact {
        get {
            if (jurisdictionContact == null) {
                jurisdictionContact = new Contact(
                    FirstName = 'City of ',
                    LastName = 'Glendale',
                    MailingStateCode = 'AZ',
                    MailingState = 'Arizona',
                    RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Jurisdiction').getRecordTypeId()
                );
                insert jurisdictionContact;
            }
            return jurisdictionContact;
        }
        set;
    }

	// opportunity
	public static List<Opportunity> utilOpportunities;

	public static void CreateData() {
		// get acct rec types
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id rt1Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Leasing Company').getRecordTypeId();
        Id rt2Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Utility Company').getRecordTypeId();
		
        //// insert custom settings
        //List<SLASettings__c> slaSettings = new List<SLASettings__c>();
        //SLASettings__c sett1 = new SLASettings__c();
        //sett1.Name = 'Full EPC - Ready to Install';
        //sett1.Criteria__c = 'Time of Change';
        //sett1.ObjectType__c = 'Opportunity';
        //sett1.RecordType__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Full EPC').getRecordTypeId();
        //sett1.Stage__c = 'Ready to Install';
        //sett1.SLAGreenThreshold__c = 13;
        //sett1.SLAYellowThreshold__c = 14;
        //sett1.SLARedThreshold__c = 15;
        //slaSettings.add(sett1);

        //SLASettings__c sett2 = new SLASettings__c();
        //sett2.Name = 'Full EPC - Admin Processing';
        //sett2.Criteria__c = 'CreatedDate';
        //sett2.ObjectType__c = 'Opportunity';
        //sett2.RecordType__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Full EPC').getRecordTypeId();
        //sett2.Stage__c = 'Admin Processing';
        //sett2.SLAGreenThreshold__c = 2;
        //sett2.SLAYellowThreshold__c = 3;
        //sett2.SLARedThreshold__c = 4;
        //slaSettings.add(sett2);

        //insert slaSettings;

		// create peson account
		TestDataUtility.utilAccounts = new List<Account>();
		// ref = [0]
		TestDataUtility.utilAccounts.add(new Account(
			lastname = 'lastname1',
        	firstname = 'firstname',
        	Email_Address__c = 'test@gmail.com',
        	Phone = '9010988988',
        	recordTypeId = rtId,
        	BillingState = 'Indiana'
		));
		// create leasing company account // ref = [1]
		TestDataUtility.utilAccounts.add(new Account(
			name = 'Leasing Company 001',
        	Email_Address__c = 'test1@gmail.com',
        	Phone = '9010988985',
        	BillingState = 'Indiana',
        	recordTypeId = rt1Id
		));
		// create utility account // ref = [2]
		TestDataUtility.utilAccounts.add(new Account(
			name = 'Utility Company 001',
        	Email_Address__c = 'tes1t@gmail.com',
        	Phone = '9010988984',
        	recordTypeId = rt2Id,
        	BillingState = 'Indiana'
		));

		// another person account // ref = [3]
		TestDataUtility.utilAccounts.add(new Account(
        	lastname = 'lastname1 015',
        	firstname = 'firstname',
        	Email_Address__c = 'test@yahoo.com',
        	PersonEmail = 'test@yahoo.com',
        	Phone = '9010988988',
        	recordTypeId= rtId,
        	Text_SMS__c = False,
        	BillingState = 'Indiana'
        ));
        
        // add sunedison account // ref = [4]
        TestDataUtility.utilAccounts.add(new Account(
        	name = 'Sunedison',
        	Email_Address__c = 'test@yahoo.com',
        	Phone = '9010988985',
        	BillingState = 'Indiana',
        	recordTypeId = rt1Id
        ));
        
        // ref = [5]
        TestDataUtility.utilAccounts.add(new Account(
        	name = 'Utility Company 015',
        	Email_Address__c = 'tes1t@gmail.com',
        	Phone = '9010988984',
        	recordTypeId = rt2Id,
        	BillingState = 'Indiana'
        ));

        // person account // ref = [6]
        TestDataUtility.utilAccounts.add(new Account(
            RecordTypeID = rtId,
            LastName = 'Test Account',
            PersonMailingStreet = 'test',
            PersonMailingPostalCode = '12345',
            PersonMailingCity = 'SFO',
            PersonMailingStateCode = 'NY',
            PersonMailingCountryCode = 'US',
            PersonOtherStreet = 'test',
            PersonOtherPostalCode = '12345',
            PersonOtherCity = 'SFO',
            PersonOtherStateCode = 'NY',
            PersonOtherCountryCode = 'US',
            BillingStateCode = 'NY',
            PersonEmail = 'test@yahoo.com',
            Phone = '9010988985',
            Email_Address__c = 'test@yahoo.com',
            Text_SMS__c = true,
            PersonHomePhone = '1234567',
            PersonMobilePhone = '12345678'
        ));

        // leasing account // ref = [7]
        TestDataUtility.utilAccounts.add(new Account(
            RecordTypeID = rt1Id,
            Name = 'APS-Install Only',
            BillingStreet = 'test@yahoo.com',
            BillingPostalCode = '12345',
            BillingCity = 'SFO',
            BillingStateCode = 'AZ',
            BillingCountryCode = 'US',
            Email_Address__c  = 'test@yahoo.com',
            Secondary_Email_CC__c = 'test@gmail.com',
            Phone = '1234567'
        ));

        // aps install only leasing account // ref = [8]
        TestDataUtility.utilAccounts.add(new Account(
        	RecordTypeID = rt1Id,
            Name='APS-Install Only',
            BillingStreet='test@yahoo.com',
            BillingPostalCode='12345',
            BillingCity='SFO',
            BillingStateCode = 'AZ',
            BillingCountryCode= 'US',
            Email_Address__c ='test@yahoo.com',
            Secondary_Email_CC__c = 'test@gmail.com',
            Phone='1234567'
        ));

        // insert accounts
		insert TestDataUtility.utilAccounts;

		TestDataUtility.utilContacts = new List<Contact>();
		// create project manager contact // ref = [0]
		TestDataUtility.utilContacts.add(new Contact(
			LastName = 'Test',
        	Email = 'test@gmail.com',
        	AccountId = TestDataUtility.utilAccounts[1].Id
		));

		// sun edison contact // ref = [1]
		TestDataUtility.utilContacts.add(new Contact(
        	LastName = 'Test 015',
        	Email = 'test@gmail.com',
        	AccountId = TestDataUtility.utilAccounts[4].Id
        ));

        // insert contacts
		insert TestDataUtility.utilContacts;

		// get opp recordtype
        Id rt3Id = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Install Only').getRecordTypeId(); 

        TestDataUtility.utilOpportunities = new List<Opportunity>();
        // ref = [0]
		TestDataUtility.utilOpportunities.add(new Opportunity(
			Name = 'test name',
        	RecordTypeId = rt3Id,
        	AccountId = TestDataUtility.utilAccounts[0].Id,
        	Lease_Id__c = 'test',
        	Contract_Price__c = 233,
        	Received_All_Paperwork__c = system.today(),
        	Number_Of_Panels__c = 45,
        	Panel_Wattage__c = 12,
        	Important_Details__c = 'test',
        	Inverter_Manufacturer1__c = 'SMA',
        	CloseDate = system.today(),
        	StageName = 'Admin Processing',
        	Leasing_Company__c = TestDataUtility.utilAccounts[1].Id,
        	Utility_Company__c = TestDataUtility.utilAccounts[2].Id,
        	Type_of_modules__c = 'LG315',
        	Type_of_Inverter_s__c = 'ABB PVI-3.0',
        	Failed_Inspection__c = system.Today(),
        	Admin_Processing_Completed_Date__c = system.today(),
        	Install_Completed_Date__c = system.Today(),
        	Project_Manager__c = TestDataUtility.utilContacts[0].Id
		));

		// sunedison opp // ref = [1]
		TestDataUtility.utilOpportunities.add(new Opportunity(
        	Name = 'test name 015',
        	RecordTypeId = rt3Id,
        	AccountId = TestDataUtility.utilAccounts[3].Id,
        	Lease_Id__c = 'test',
        	Contract_Price__c = 233,
        	Received_All_Paperwork__c = system.today(),
        	Number_Of_Panels__c = 45,
        	Panel_Wattage__c = 12,
        	Important_Details__c = 'test',
        	Inverter_Manufacturer1__c = 'SMA',
        	CloseDate = system.today(),
        	StageName = 'Admin Processing',
        	Utility_Company__c = TestDataUtility.utilAccounts[5].Id,
        	Leasing_Company__c = TestDataUtility.utilAccounts[4].Id,
        	Type_of_modules__c = 'LG315',
        	Type_of_Inverter_s__c = 'ABB PVI-3.0',
        	Customer_Signature_Required__c = true,
        	Failed_Inspection__c = system.Today(),
        	Admin_Processing_Completed_Date__c = system.today(),
        	Install_Completed_Date__c = system.Today(),
        	Project_Manager__c = TestDataUtility.utilContacts[1].Id,
        	QA_Reviewed_Date__c  = system.today(),
        	FSD_Accepted_Date__c  = system.today(),
        	QC_Scheduled_Date__c =System.today().adddays(2),
        	PPT_Scheduled_Date__c = system.today().adddays(2),
        	Scheduled_MPU_Derate__c  = system.today().adddays(2),
        	Scheduled_Install_Date__c = system.today().adddays(2),
        	AHJ_Inspection_Scheduled__c = system.today().adddays(2),
        	Scheduled_Time__c = system.Now().adddays(2),
        	Sent_Back_to_Leasing_Company__c = true,
        	Interconnection_Submitted__c = system.today(),
        	Received_From_Jurisdiction_Processing__c = system.today(),
        	Project_Design_Complete__c = system.today()
        ));

        // ref = [2]
        TestDataUtility.utilOpportunities.add(new Opportunity(
        	AccountId = TestDataUtility.utilAccounts[6].Id,
        	CloseDate = system.today(),
        	Leasing_Company__c = TestDataUtility.utilAccounts[7].Id,
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Full EPC').getRecordTypeId(),
        	Name = 'Test Opportunity',
        	StageName = 'Admin Processing',
        	Project_Design_Complete__c = system.today(),
        	Countersign_Date__c = system.today(),
        	Drawings_Sent_To_Customer__c = system.today(),
        	Permits_Submitted__c = system.today(),
        	Permits_Approved__c = system.today(),
        	HOA_Submitted__c = system.today(),
        	HOA_Approval__c = system.today()
        ));

        // past opp // ref = [3]
        TestDataUtility.utilOpportunities.add(new Opportunity(
        	AccountId = TestDataUtility.utilAccounts[6].Id,
        	CloseDate = system.today(),
        	Leasing_Company__c = TestDataUtility.utilAccounts[8].Id,
        	Name = 'Test Opportunity',
        	StageName = 'Admin Processing',
        	Project_Design_Complete__c = system.today().adddays(-2),
        	Countersign_Date__c = system.today().adddays(-2),
        	Drawings_Sent_To_Customer__c = system.today().adddays(-2),
        	Permits_Submitted__c = system.today().adddays(-2),
        	Permits_Approved__c = system.today().adddays(-2),
        	HOA_Submitted__c = system.today().adddays(-2),
        	HOA_Approval__c = system.today().adddays(-2)
        ));

        // insert
		insert TestDataUtility.utilOpportunities;

		dataCreated = true;
	}
}