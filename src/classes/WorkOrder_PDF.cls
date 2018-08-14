Public class WorkOrder_PDF{
public String Subject{get;set;}
public String Assignedby{get;set;}
public Date dat {get;set;}
Public String Comments {get;set;}
public Opportunity opp{get;set;}
Public string recordId {get;set;}
public String conrec{get;set;}
public String conemail{get;set;}
public Date condate{get;set;}

    Public WorkOrder_PDF(ApexPages.StandardController controller) {
         recordID = ApexPages.CurrentPage().getparameters().get('id');
         opp = [select id,name,Job_Num__c,account.Billingcountry,account.Billingstreet,account.billingcity,account.Billingstate,account.Billingpostalcode,account.phone,Work_Order_Status__c,Project_Manager__c  from opportunity where id=:recordId];
    }
    
    public void getManager(){
       conrec = [select id,name,email from contact where id =: opp.Project_Manager__c].name;        
    }
    public PageReference sendmail()
    {
        getManager();        
        conemail = [select id,name,email from contact where id =: opp.Project_Manager__c].email;
        if(conemail !=null)
        {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        PageReference pdf =  Page.WorkOrder_PDF;
        pdf.getParameters().put('prjManager',conrec);
        pdf.setRedirect(true);
        Blob b;
        if(!Test.isRunningTest())
          b= pdf.getContent();
          else
          b = Blob.valueOf('Some Text');
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Work Order.pdf');
        efa.setBody(b);
        email.setSubject( subject );
        string[] test1 = new String[] {conemail};
        email.setToAddresses(test1);
        email.setPlainTextBody( 'Work Order Details' );
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        // Sends the email
        Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
       Attachment myAttach = new Attachment();
       myAttach.ParentId = ApexPages.CurrentPage().getparameters().get('id');  
       myAttach.name = 'Work Order.pdf';
       if(!Test.isRunningTest())    
           myAttach.body = Pdf.getContentAsPdf();
       else
         myAttach.body = Blob.valueOF('test body');   
       insert myattach;
       PageReference pageRef = new PageReference('/' +recordID );
            return pageRef;
      }
      else
      {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'please enter email in selected conatct'));
          return null;
      }
    }
}