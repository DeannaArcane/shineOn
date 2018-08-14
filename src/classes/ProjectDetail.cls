public with sharing class ProjectDetail {
	// constructor
	public ProjectDetail() {
		
	}

	/////////////////
	// Data Setup
	/////////////////

	// flag for edit mode
	public boolean editMode { get; set;}

	// string for start mode
	public string startMode { get; set; }

	// flag for empty map
	public boolean isMapEmpty { get {
		return FieldsMap.isEmpty();
		} 
		set;
	}

	// for reload on record type changes
	public boolean ReloadMainPage { get; set; }
	public String ReloadURL { get {
			return  URL.getSalesforceBaseUrl().toExternalForm() + '/' + RecordId;
		} 
		set; 
	}

	// attributes from vf page -> component
	public String TabName { get; set; }
	public String RecordId { get; set; }
	public String RTypeId { get; set; }

	// query the opp for desired fields
	public Opportunity theProject { get{
		if (theProject == null) {
			theProject = new Opportunity();
			theProject = Database.query(getProjectSoqlQuery(FieldsMap));
		}

		system.debug(theproject);

		return theProject;

		} 
		set; 
	}

	// list to side load order of keys displayed (sections as keys)
	public List<String> Sections { get; set;}

	// set to hold fields, built out while query is built so they match
	public Set<String> PFDFields { get {
		if (PFDFields == null)
			PFDFields = new Set<String>();

		return PFDFields;
		} 
		set; 
	}

	// query the fielddisplay obj for fields to show
	public Map<String, List<String>> FieldsMap { get {
		
		if (FieldsMap == null) {
			// instantiated ordered list previously declared globally
			Sections = new List<String>();

			// instantiate map
			FieldsMap = new Map<String, List<String>>();

			// list to hold query result
			List<ProjectFieldDisplay__c> PFDTemp = Database.query(getPFDSoqlQuery());

			// convert record into sorted wrapper
			list<PFDSection> PFDSect = HardSort(PFDTemp);

			// debug delete w/ done
			for (PFDSection p : PFDSect)
				system.debug(p);

			// build string map based on section wrapper
			if (!PFDSect.isEmpty() && !PFDFields.isEmpty()) {
				for (PFDSection p : PFDSect) {
					// loop through fields map
					for (String s : PFDFields) {
						// at this point we're only interested in sectionXXtab__c fields
						if (s.containsIgnoreCase('section') && s.containsIgnoreCase('tab')) {
							if (TabName == 'ALL')
								FieldsMap.put(p.Label, p.Section.split(';'));
							else if (TabName == p.Tab)
								FieldsMap.put(p.Label, p.Section.split(';'));
	
						}
					}
				}
				// use keyset to populate ordered list<string> retaining query order 
				for (String s : FieldsMap.keySet())
					Sections.add(s);

			}

			// old way deprecated because of ordering necessity
			/*// build map based on tab/sections only if data exists
			if (!PFDTemp.isEmpty() && !PFDFields.isEmpty()) {
				// initial loop through results
				for (ProjectFieldDisplay__c pfd : PFDTemp) {
					// loop through set<string> populated during query build method, this allows looping through wanted fields dynamically
					for (String s : PFDFields) {
						// at this point we're only interested in sectionXXtab__c fields
						if (s.containsIgnoreCase('section') && s.containsIgnoreCase('tab')) {
							
							// displays all (now the default)
							if (TabName == 'ALL') {

								// string manipulations to get corresponding fields for label and opp field listings for display
								String label = (String)pfd.get(s.replace('tab', 'label'));
								String section = (String)pfd.get(s.replace('tab', ''));
								
								// populate map
								if (label != null && section != null)
									FieldsMap.put(label, section.split(';'));

							// ensure tab field matches current tab passed down from apex page
							} else if (pfd.get(s) == TabName) {
								//system.debug('we got tab: ' + TabName);
								
								// string manipulations to get corresponding fields for label and opp field listings for display
								String label = (String)pfd.get(s.replace('tab', 'label'));
								String section = (String)pfd.get(s.replace('tab', ''));
								
								// populate map
								if (label != null && section != null)
									FieldsMap.put(label, section.split(';'));
							}
						}
					}
				}

				// use keyset to populate ordered list<string> retaining query order 
				for (String s : FieldsMap.keySet())
					Sections.add(s);

				//system.debug('field map: ' + FieldsMap);
				
			}*/
		}

		return FieldsMap;
		}
		set;
	}

	/////////////////
	// Actions
	/////////////////
    
    // activate editmode                         
    public void goEdit() { 
    	system.debug('in go edit');
    	editMode = true; 
    	Refresh();
    }
    
    // save edits                            
    public void Save() {
    	// reload outside of the iframe on recordtype changes
    	if (RTypeId != theProject.RecordTypeId) {
    		ReloadMainPage = true;

    	}

    	editMode = false;
        update theProject;
        
        // redirect to record detail or refresh for rerender
        /*system.debug('startMode: ' + startMode);
        if (startMode == 'edit') {
        	//Refresh();
        	redirectToView();
        }
        else*/
        // clear nulls on save
        Refresh();

    }

    // special redirect version of save
    public PageReference EditModeSave() {
    	update theProject;
    	return redirectToView();
    }

    // nulling method
    public void Refresh() {
    	FieldsMap = null;
        theproject = null;
        PFDFields = null;
    }
    
    // cancel edit                         
    public void Cancel() { 
    	// redirect to record detail or refresh for rerender
    	/*system.debug('startMode: ' + startMode);
        if (startMode == 'edit') {
        	editMode = false; 
        	redirectToView();
        } else*/

        // disable edit mode
        editMode = false; 
    }

    // special redirect version of cancel
    public PageReference EditModeCancel() {
    	
    	return redirectToView();
    }

    // helper - redirect to record (needed for classic edit, can depricate after lightning adoption)
    public PageReference redirectToView() {
    	
    	PageReference p = new ApexPages.StandardController(theProject).view();
    	p.setRedirect(true);
		return p;
	}

    /////////////////
    // Helpers
    /////////////////

    // clean the list and return query for dynamic soql
    public String getProjectSoqlQuery(Map<String, List<String>> theMap) {
    	
    	// set for unique field listing, helps avoid multiple fields in a query
    	Set<String> queryFields = new Set<String>();
    	
    	// build field set based off of map results, exclude BLANK spacer listings
    	for (String key : theMap.keySet())
    		for (String f : theMap.get(key))
    			if (!f.equalsIgnoreCase('id') && !f.equalsIgnoreCase('BLANK'))
    				queryFields.add(f);

    	// build query string using set<string>
    	String soql = 'SELECT Id, ';

    	for (String f : queryFields)
    		soql += f + ', ';

    	// string manip to clean/finish query string
    	soql = soql.removeEnd(', ') + ' FROM Opportunity WHERE Id = \'' + RecordId + '\' LIMIT 1';

        return soql;
    }

    // helpers for PFD query
    public String getPFDSoqlQuery() {
        // access schema for fields
        Map<String, Schema.SobjectField> schFields = getSchFields('ProjectFieldDisplay__c');

        // build soql String
        String soql = 'SELECT Id, ';
        for(String f : schFields.keySet()) 
        	if (f != 'id') {
            	soql += f + ', ';
            	if (f.containsIgnoreCase('section'))
            		PFDFields.add(f);
        	}
        
        soql = soql.removeEnd(', ') + ' FROM ProjectFieldDisplay__c WHERE ProjectRecordTypeId__c INCLUDES(\'' + RTypeId + '\') LIMIT 1';

        system.debug('pfd soql:' + soql);
        system.debug('pfd fields: ' + pfdfields);

        return soql;
    }

    // gathers fields
    public Map<String, Schema.SobjectField> getSchFields(String obj) {
        // access schema for fields
        Map<String, Schema.SobjectField> schFields = getSchResult(obj).fields.getMap();

        return schFields;

    }

    // returns schema result
    public Schema.DescribeSObjectResult getSchResult(String obj) {
         Map<String, Schema.SObjectType> schMap = Schema.getGlobalDescribe();

         return schMap.get(obj).getDescribe(); 
    }

    // hard sort the sections by ordering field
    public List<PFDSection> HardSort(List<ProjectFieldDisplay__c> pfds) {

    	// holder map to help sort by sectionXXorder__c
    	map<Decimal, PFDSection> preOrderedSections = new map<Decimal, PFDSection>();

    	// loop through project field display and it's order fields to create map of wrapper obj for each subset of fields
		for (ProjectFieldDisplay__c p : pfds) {
		    for (Integer i = 1; i <= 25; i++) {
		    	if (p.get('section' + i + '__c') != null && p.get('section' + i + 'tab__c') != null && p.get('section' + i + 'label__c') != null && p.get('section' + i + 'order__c') != null) {
		        	preOrderedSections.put((Decimal)p.get('section' + i + 'order__c'), new PFDSection((Decimal)p.get('section' + i + 'order__c'), (String)p.get('section' + i + '__c'), (String)p.get('section' + i + 'tab__c'), (String)p.get('section' + i + 'label__c')));
		    	}
		    }
		}

		// debug ok to delete
		for (Decimal d : preOrderedSections.keySet())
    		system.debug('presort: ' + preOrderedSections.get(d).Order);

    	// debug ok to delete
		system.debug('wrapper size: ' + preOrderedSections.keyset().size());

		// create a list of predetermind size to sort by index = order val
		list<PFDSection> orderedSections = new PFDSection[preOrderedSections.values().size()];

		/*for (Integer i = 1; i <= preOrderedSections.size(); i++) {
		    system.debug('wrapper order ' + preOrderedSections[i-1].order);
		    //orderedSections.add(i-1, preOrderedSections[i-1]);
		    orderedSectinos[i-1] = preOrderedSections.get(i);
		}*/

		// force indexing by hard assignment
		for (Decimal d : preOrderedSections.keySet())
    		orderedSections[(Integer)d-1] = preOrderedSections.get(d);

    	// debug ok to delete
		system.debug('ordered size: ' + orderedSections);
	
		//preOrderedSections.sort();

		// debug ok to delete
		for (PFDSection p : orderedSections)
    		system.debug('after sort: ' + p.Order);

    	return orderedSections;
    }

    public class PFDSection {
    	Decimal order;
    	String section;
    	String tab;
    	String label;
    
    	public PFDSection(Decimal Order, String Section, String Tab, String Label) {
    	    this.order = Order;
    	    this.section = Section;
    	    this.tab = Tab;
    	    this.label = Label;
    	}
	}

    /////////////////
    // Graveyard - temp
    /////////////////

    // get record id from url
	/*public String RecordId { get {
		return ApexPages.currentPage().getParameters().get('id');
		} 
		set; 
	}*/

	/*// get RecordTypeId
	public String RTypeId { get {
		if (RtypeId == null) {
			RtypeId = '';
			RtypeId = [SELECT Id, RecordTypeId FROM Opportunity WHERE Id = :RecordId LIMIT 1].RecordTypeId;
		}
		return RTypeId;

		}
		set;
	}*/

	/*// query the fielddisplay obj for fields to show
	public List<ProjectFieldDisplay__c> Fields { get {
		if (fields == null) {
			fields = [SELECT Id, ProjectInfo__c 
					FROM ProjectFieldDisplay__c 
					WHERE ProjectRecordTypeId__c INCLUDES (:theProject.RecordTypeId) LIMIT 1].ProjectInfo__c.split(';');
			fields = [SELECT Id, ProjectInfo__c 
					FROM ProjectFieldDisplay__c 
					WHERE ProjectRecordTypeId__c INCLUDES (:RTypeId) LIMIT 1].ProjectInfo__c.split(';');
		}
		return fields;
		} 
		set; 
	}*/

    /*// helpers for opp query
    public String getSoqlSoqlQuery(String obj) {
        // access schema for fields

        Map<String, Schema.SobjectField> schFields = getSchFields(obj);

        // build soql String
        String soql = 'SELECT Id, ';
        for(String f : schFields.keySet()) 
        	if (f != 'id')
            	soql += f + ', ';
        
        soql = soql.removeEnd(', ') + ' FROM ' + obj + ' WHERE Id = \'' + RecordId + '\' LIMIT 1';

        return soql;
    }

    // gathers fields
    public Map<String, Schema.SobjectField> getSchFields(String obj) {
         // access schema for fields
        Map<String, Schema.SobjectField> schFields = getSchResult(obj).fields.getMap();

        return schFields;

    }

    // returns schema result
    public Schema.DescribeSObjectResult getSchResult(String obj) {
         Map<String, Schema.SObjectType> schMap = Schema.getGlobalDescribe();

         return schMap.get(obj).getDescribe(); 
    }*/

    /*// query the fielddisplay obj for fields to show
	public List<String> Fields { get {
		if (fields == null) {
			
			fields = [SELECT Id, ProjectInfo__c 
					FROM ProjectFieldDisplay__c 
					WHERE ProjectRecordTypeId__c INCLUDES (:RTypeId) LIMIT 1].ProjectInfo__c.split(';');
		}
		return fields;
		} 
		set; 
	}*/

    /*public Set<String> Sections { get {
		if (Sections == null) {
			Sections = new Set<String>();

			if (TabName == 'Project Info') 
				Sections.add('Project Info');
			else if (TabName == 'Orders') {
				if (FieldsMap.get('Material Take Off') != null)
					Sections.add('Material Take Off');
				//else
					//FieldsMap.put('Material Take Off', new List<String>());
			} else if (TabName == 'Pre-Install') {
				if (FieldsMap.get('SiteSurvey__c') != null)
					Sections.add('Site Survey');

				if (FieldsMap.get('Utility__c') != null)
					Sections.add('Utility');
		
				if (FieldsMap.get('HOA__c') != null)
					Sections.add('HOA');
		
				if (FieldsMap.get('Underwriting__c') != null)
					Sections.add('Underwriting');
		
				if (FieldsMap.get('DesignApproval__c') != null)
					Sections.add('Design Approal');
				
				if (FieldsMap.get('JurisdictionProcessing__c') != null)
					Sections.add('Jurisdiction Processing');
		
				if (FieldsMap.get('ReadytoInstall__c') != null)
					Sections.add('Ready to Install');

			} else if (TabName == 'Post-Install') {
				if (FieldsMap.get('InstallinProgress__c') != null)
					Sections.add('Install in Progress');
				
				if (FieldsMap.get('CompletedInstallReview__c') != null)
					Sections.add('Completed Install Review');
				
				if (FieldsMap.get('MPU__c') != null)
					Sections.add('MPU');
				
				if (FieldsMap.get('QCReview__c') != null)
					Sections.add('QC Review');
		
				if (FieldsMap.get('Repairs__c') != null)
					Sections.add('Repairs');
		
				if (FieldsMap.get('AHJApproval__c') != null)	
					Sections.add('AHJ Approval');
		
				if (FieldsMap.get('Commissioning__c') != null)
					Sections.add('Commissioning');

			} else if (TabName == 'Financial') {
				if (FieldsMap.get('RebateSection__c') != null)
					Sections.add('Rebate Section');
		
				if (FieldsMap.get('BillingCloseoutSection__c') != null)
					Sections.add('Billing Closeout Section');
		
				if (FieldsMap.get('X3rdPartyFinancialAppinReview__c') != null)
					Sections.add('3rd Party Financial App in Review');
			}
		}
		return Sections;
		} 
		set;
	}*/

	/*
	// build map based on tab/sections
			if (!PFDTemp.isEmpty()) {
				for (ProjectFieldDisplay__c pfd : PFDTemp) {
					if (TabName == 'Project Info') {
						FieldsMap.put('Project Info', pfd.ProjectInfo__c.split(';'));
						Sections.add('Project Info');
					} else if (TabName == 'Orders') {
						if (pfd.MaterialTakeOff__c != null) {
							FieldsMap.put('Material Take Off', pfd.MaterialTakeOff__c.split(';'));
							Sections.add('Material Take Off');
						}
						//else
							//FieldsMap.put('Material Take Off', new List<String>());
					} else if (TabName == 'Pre-Install') {
						if (pfd.SiteSurvey__c != null) {
							FieldsMap.put('Site Survey', pfd.SiteSurvey__c.split(';'));
							Sections.add('Site Survey');
						}

						if (pfd.Utility__c != null) {
							FieldsMap.put('Utility', pfd.Utility__c.split(';'));
							Sections.add('Utility');
						}

						if (pfd.HOA__c != null) {
							FieldsMap.put('HOA', pfd.HOA__c.split(';'));
							Sections.add('HOA');
						}

						if (pfd.Underwriting__c != null) {
							FieldsMap.put('Underwriting', pfd.Underwriting__c.split(';'));
							Sections.add('Underwriting');
						}

						if (pfd.DesignApproval__c != null) {
							FieldsMap.put('Design Approal', pfd.DesignApproval__c.split(';'));
							Sections.add('Design Approal');
						}
						
						if (pfd.JurisdictionProcessing__c != null) {
							FieldsMap.put('Jurisdiction Processing', pfd.JurisdictionProcessing__c.split(';'));
							Sections.add('Jurisdiction Processing');
						}

						if (pfd.ReadytoInstall__c != null) {
							FieldsMap.put('Ready to Install', pfd.ReadytoInstall__c.split(';'));
							Sections.add('Ready to Install');
						}
					} else if (TabName == 'Post-Install') {
						if (pfd.InstallinProgress__c != null) {
							FieldsMap.put('Install in Progress', pfd.InstallinProgress__c.split(';'));
							Sections.add('Install in Progress');
						}
						
						if (pfd.CompletedInstallReview__c != null) {
							FieldsMap.put('Completed Install Review', pfd.CompletedInstallReview__c.split(';'));
							Sections.add('Completed Install Review');
						}
						
						if (pfd.MPU__c != null) {
							FieldsMap.put('MPU', pfd.MPU__c.split(';'));
							Sections.add('MPU');
						}
						
						if (pfd.QCReview__c != null) {
							FieldsMap.put('QC Review', pfd.QCReview__c.split(';'));
							Sections.add('QC Review');
						}

						if (pfd.Repairs__c != null) {
							FieldsMap.put('Repairs', pfd.Repairs__c.split(';'));
							Sections.add('Repairs');
						}

						if (pfd.AHJApproval__c != null)	{
							FieldsMap.put('AHJ Approval', pfd.AHJApproval__c.split(';'));
							Sections.add('AHJ Approval');
						}

						if (pfd.Commissioning__c != null) {
							FieldsMap.put('Commissioning', pfd.Commissioning__c.split(';'));
							Sections.add('Commissioning');
						}
					} else if (TabName == 'Financial') {
						if (pfd.RebateSection__c != null) {
							FieldsMap.put('Rebate Section', pfd.RebateSection__c.split(';'));
							Sections.add('Rebate Section');
						}

						if (pfd.BillingCloseoutSection__c != null) {
							FieldsMap.put('Billing Closeout Section', pfd.BillingCloseoutSection__c.split(';'));
							Sections.add('Billing Closeout Section');
						}

						if (pfd.X3rdPartyFinancialAppinReview__c != null) {
							FieldsMap.put('3rd Party Financial App in Review', pfd.X3rdPartyFinancialAppinReview__c.split(';'));
							Sections.add('3rd Party Financial App in Review');
						}
					}
				}
			}
		}
*/

	/*// query the fielddisplay obj for fields to show
	public Map<String, List<String>> FieldsMap { get {
		
		if (FieldsMap == null) {

			Sections = new List<String>();

			FieldsMap = new Map<String, List<String>>();

			// list to hold query result
			List<ProjectFieldDisplay__c> PFDTemp = [SELECT Section1__c, Section1label__c, Section2__c, Section2label__c, Section3__c, Section3label__c, Section4__c, Section4label__c, Section5__c, Section5label__c, Section6__c, Section6label__c, Section7__c, Section7label__c, Section8__c, Section8label__c, Section9__c, Section9label__c, Section10__c, Section10label__c, Section11__c, Section11label__c, Section12__c, Section12label__c, Section13__c, Section13label__c, Section14__c, Section14label__c, Section15__c, Section15label__c, Section16__c, Section16label__c, Section17__c, Section17label__c, Section18__c, Section18label__c, Section19__c, Section19label__c
					FROM ProjectFieldDisplay__c 
					WHERE ProjectRecordTypeId__c INCLUDES (:RTypeId) LIMIT 1];
			
				for (ProjectFieldDisplay__c pfd : PFDTemp) {
					if (TabName == 'Project Info') {
						FieldsMap.put(pfd.Section1Label__c, pfd.Section1__c.split(';'));
						Sections.add(pfd.Section1Label__c);
					}  else if (TabName == 'Pre-Install') {
						if (pfd.Section2__c != null && pfd.Section2Label__c != null) {
							FieldsMap.put(pfd.Section2Label__c, pfd.Section2__c.split(';'));
							Sections.add(pfd.Section2Label__c);
						}

						if (pfd.Section3__c != null && pfd.Section3Label__c != null) {
							FieldsMap.put(pfd.Section3Label__c, pfd.Section3__c.split(';'));
							Sections.add(pfd.Section3Label__c);
						}

						if (pfd.Section4__c != null && pfd.Section4Label__c != null) {
							FieldsMap.put(pfd.Section4Label__c, pfd.Section4__c.split(';'));
							Sections.add(pfd.Section4Label__c);
						}

						if (pfd.Section5__c != null && pfd.Section5Label__c != null) {
							FieldsMap.put(pfd.Section5Label__c, pfd.Section5__c.split(';'));
							Sections.add(pfd.Section5Label__c);
						}

						if (pfd.Section6__c != null && pfd.Section6Label__c != null) {
							FieldsMap.put(pfd.Section6Label__c, pfd.Section6__c.split(';'));
							Sections.add(pfd.Section6Label__c);
						}
						
						if (pfd.Section7__c != null && pfd.Section7Label__c != null) {
							FieldsMap.put(pfd.Section7Label__c, pfd.Section7__c.split(';'));
							Sections.add(pfd.Section7Label__c);
						}

						if (pfd.Section8__c != null && pfd.Section8Label__c != null) {
							FieldsMap.put(pfd.Section8Label__c, pfd.Section8__c.split(';'));
							Sections.add(pfd.Section8Label__c);
						}
					}else if (TabName == 'Orders') {
						if (pfd.Section9__c != null && pfd.Section9Label__c != null) {
							FieldsMap.put(pfd.Section9Label__c, pfd.Section9__c.split(';'));
							Sections.add(pfd.Section9Label__c);
						}
						//else
							//FieldsMap.put('Material Take Off', new List<String>());
					} else if (TabName == 'Post-Install') {
						if (pfd.Section10__c != null && pfd.Section10Label__c != null) {
							FieldsMap.put(pfd.Section10Label__c, pfd.Section10__c.split(';'));
							Sections.add(pfd.Section10Label__c);
						}
						
						if (pfd.Section11__c != null && pfd.Section11Label__c != null) {
							FieldsMap.put(pfd.Section11Label__c, pfd.Section11__c.split(';'));
							Sections.add(pfd.Section11Label__c);
						}
						
						if (pfd.Section12__c != null && pfd.Section12Label__c != null) {
							FieldsMap.put(pfd.Section12Label__c, pfd.Section12__c.split(';'));
							Sections.add(pfd.Section12Label__c);
						}
						
						if (pfd.Section13__c != null && pfd.Section13Label__c != null) {
							FieldsMap.put(pfd.Section13Label__c, pfd.Section13__c.split(';'));
							Sections.add(pfd.Section13Label__c);
						}

						if (pfd.Section14__c != null && pfd.Section14Label__c != null) {
							FieldsMap.put(pfd.Section14Label__c, pfd.Section14__c.split(';'));
							Sections.add(pfd.Section14Label__c);
						}

						if (pfd.Section15__c != null && pfd.Section15Label__c != null) {
							FieldsMap.put(pfd.Section15Label__c, pfd.Section15__c.split(';'));
							Sections.add(pfd.Section15Label__c);
						}

						if (pfd.Section16__c != null && pfd.Section16Label__c != null) {
							FieldsMap.put(pfd.Section16Label__c, pfd.Section16__c.split(';'));
							Sections.add(pfd.Section16Label__c);
						}
					} else if (TabName == 'Financial') {
						if (pfd.Section17__c != null && pfd.Section17Label__c != null) {
							FieldsMap.put(pfd.Section17Label__c, pfd.Section17__c.split(';'));
							Sections.add(pfd.Section17Label__c);
						}

						if (pfd.Section18__c != null && pfd.Section18Label__c != null) {
							FieldsMap.put(pfd.Section18Label__c, pfd.Section18__c.split(';'));
							Sections.add(pfd.Section18Label__c);
						}

						if (pfd.Section19__c != null && pfd.Section19Label__c != null) {
							FieldsMap.put(pfd.Section19Label__c, pfd.Section19__c.split(';'));
							Sections.add(pfd.Section19Label__c);
						}
					}
				}
			}
		}

		return FieldsMap;
		}
		set;
	}*/

}