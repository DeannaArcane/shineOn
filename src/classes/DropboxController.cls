/*
    Created By : Mani
    Modified By : Mani
    Description: To create folders in dropbox

    LastModified By : Clayton Thomas
    Author : MST Solutions

    History   
    1. 11/2/2015,  Mani
    2. 10/25/2017 Clayton Thomas, Migrated API v1 to v2.
*/  
public class DropboxController{  
    
    public static string consumerKey = Label.DropBoxConsumerKey;
    public static string accessToken = Label.DropBoxAccessToken;
    
    /*
    * @description This method used to get dropbox accesstoken from custom lables and call createfolder method to create folder in dropbox .
    */
    @Future(callout=true)
    public static void AccessToken(string recId, String Name, string state){ 
      //TODO get endpoint from custom setting
      String endpoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
      String fileUploadEndpoint = 'https://content.dropboxapi.com/2/files/upload';
      //if you want to add any new subfolder for an project then please add it here.
      Set<String> subFolderNames = new Set<String>{'AHJ','Install Pics','QC Pics','PPT Pics','Site Survey','Plans & Permit','Completion Docs','FSD Pics'};
      if(!(state == null || state == '')) state = state.trim(); 
      if(!(name == null || name == '')) name = name.trim();    
      String appPath = Label.DropboxAppName+state+'/'+Name;
      String fileName = '.'+recId+'.sfdb';

      if(subFolderNames.size() > 0){
          for(String subFoldername : subFolderNames){
              createFolder(endpoint,appPath,subFoldername);//Creating folder & subfolder for an project
          }
      }
       System.debug('appPath: '+appPath);
      //Uploading default file for an project folder
      uploadFile(fileUploadEndpoint,appPath,fileName);
    }

    /*
    * @description This method used to create folder in dropbox by passing path and folder name.
    */
    public static void createFolder(String Endpoint,String appPath,String subfolderName){
      //Adding subfolder name
      appPath = subfolderName != null ? appPath + '/' + subfolderName : appPath;
      // Instantiate a new http object
      Http http = new Http();

      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setEndpoint(Endpoint);
      req.setMethod('POST');
      req.setTimeout(60*1000); 
      //Set headers
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Bearer '+accessToken); 

      //Set request body
      String body = CreateFolderRequestJson(appPath,false);
      System.debug('Create folder Request body: '+body);
      req.setBody(body);
		
      // Send the request, and return a response
      HttpResponse res = http.send(req);
      if(res.getStatus() == 'OK')
        System.debug('Create dropbox folder response: '+ res.getBody());
      else
        System.debug('Error occured while uploading file into dropbox,response:' +res.getBody() +' Status : '+ res.getStatus() + ' Status Code :'+ res.getStatusCode());
    }

    /*
    * @description This method used to upload files into the dropbox folder by passing path,file name & file.
    */
    public static void uploadFile(String Endpoint,String appPath,String filename){
      // Instantiate a new http object
      Http http = new Http();

      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setEndpoint(Endpoint);
      req.setMethod('POST');
      req.setTimeout(60*1000); 
      //Set headers
      req.setHeader('Content-Type', 'application/octet-stream');
      req.setHeader('Authorization', 'Bearer '+accessToken);
      req.setHeader('Dropbox-API-Arg', fileUploadRequestJson(appPath+'/'+filename,'add',true,false));

      req.setBodyAsBlob(Blob.valueOf('Do not delete'));
      // Send the request, and return a response
      HttpResponse res = http.send(req);

      if(res.getStatus() == 'OK')
        System.debug('Dropbox file upload response: '+ res.getBody());
      else
        System.debug('Error occured while creating dropbox folder,response:' +res.getBody() +' Status : '+ res.getStatus() + ' Status Code :'+ res.getStatusCode());
    }
    /*
    * @description This method used to delete the folder in dropbox .
    */
    @Future(callout=true)
    public static void deleteDropBoxFolder(String recId, String state, String name) {
      String appPath = Label.DropboxAppName + state + '/' + name;
      System.debug('delete path: '+appPath);
      String endpoint = 'https://api.dropboxapi.com/2/files/delete_v2';
         // Instantiate a new http object
      Http http = new Http();

      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setEndpoint(Endpoint);
      req.setMethod('POST');
      req.setTimeout(60*1000); 
      //Set headers
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Bearer '+accessToken); 

      //Set request body
      String body = deleteFolderRequestJson(appPath);
      System.debug('Delete request body: '+body);
      req.setBody(body);

      // Send the request, and return a response
      HttpResponse res = http.send(req);

      if(res.getStatus() == 'OK')
        System.debug('Delete dropbox folder response: '+ res.getBody());
      else
        System.debug('Error occured while deleting dropbox folder,response:' +res.getBody() +' Status : '+ res.getStatus() + ' Status Code :'+ res.getStatusCode());
    }
    /*
    * @description This method used to update the folder in dropbox .
    */
    @Future(callout=true)
    public static void updateDropboxfolder(string recId, string oldname, string newName){
      String appPath = Label.DropboxAppName;
      System.debug('Old path: '+oldname);
      System.debug('New path: '+newName);
      String endpoint = 'https://api.dropboxapi.com/2/files/move_v2';
      // Instantiate a new http object
      Http http = new Http();

      // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
      HttpRequest req = new HttpRequest();
      req.setEndpoint(Endpoint);
      req.setMethod('POST');
      req.setTimeout(60*1000); 
      //Set headers
      req.setHeader('Content-Type', 'application/json');
      req.setHeader('Authorization', 'Bearer '+accessToken); 

      //Set request body
      String body = folderUpdateRequestJson(appPath + oldname,appPath + newName,false,false,false);
        System.debug('update folder req body: '+body);
      req.setBody(body);

      // Send the request, and return a response
      HttpResponse res = http.send(req);

      if(res.getStatus() == 'OK')
        System.debug('Update dropbox folder response: '+ res.getBody());
      else
        System.debug('Error occured while updating dropbox folder,response:' +res.getBody() +' Status : '+ res.getStatus() + ' Status Code :'+ res.getStatusCode());

    }

    // Create Folder
    public class folderCreateRequest {
        public String path;
        public Boolean autorename;

        public folderCreateRequest(String path,boolean autorename){
          this.path = path;
          this.autorename = autorename;
        }
    }
    public static String createFolderRequestJson(String folderName, Boolean autorename){
        return JSON.serialize(new folderCreateRequest(folderName,autorename));
    }
     // delete Folder
    public class deleteFolderRequest {
        public String path;

        public deleteFolderRequest(String path){
          this.path = path;
        }
    }
    public static String deleteFolderRequestJson(String appPath){
        return JSON.serialize(new deleteFolderRequest(appPath));
    }

    // File Upload
    public class fileUploadRequest {
        public String path;
        public String mode;
        public Boolean autorename;
        public Boolean mute;

        public fileUploadRequest(String path,String mode,Boolean autorename,Boolean mute){
          this.path = path;
          this.mode = mode;
          this.autorename = autorename;
          this.mute = mute;
        }
    }
    public static String fileUploadRequestJson(String path,String mode,Boolean autorename,Boolean mute){
        return JSON.serialize(new fileUploadRequest(path,mode,autorename,mute));
    }

    //Update Folder
    public class folderUpdateRequest {
        public String from_path;
        public String to_path;
        public Boolean allow_shared_folder;
        public Boolean autorename;
        public Boolean allow_ownership_transfer;

        public folderUpdateRequest(String from_path,String to_path,Boolean allow_shared_folder,Boolean autorename,Boolean allow_ownership_transfer){
          this.from_path = from_path;
          this.to_path = to_path;
          this.allow_shared_folder = allow_shared_folder;
          this.autorename = autorename;
          this.allow_ownership_transfer = allow_ownership_transfer;
        }
    }
     public static String folderUpdateRequestJson(String from_path,String to_path,Boolean allow_shared_folder,Boolean autorename,Boolean allow_ownership_transfer){
        return JSON.serialize(new folderUpdateRequest(from_path,to_path,allow_shared_folder,autorename,allow_ownership_transfer));
    }  
} 
/*
    Created By : Mani
    Modified By : Mani
    Description: To create folders in dropbox
 
public class DropboxController  
{  
    public static string consumerKey = Label.DropBoxConsumerKey;
    public static string accessToken = Label.DropBoxAccessToken;
    String code ;   
       
    @Future(callout=true)
    public static void AccessToken(string recId, String Name, string state)  
    { 
        HttpRequest req1 = new HttpRequest(); 
        req1.setMethod('POST');
        req1.setTimeout(60*1000);     
        if(!(state == null || state == '')) state = state.trim().replace(' ','%20'); 
        if(!(name == null || name == '')) name = name.trim().replace(' ','%20');    
        String appPath = Label.DropboxAppName+'/'+state+'/'+Name+'/'; 
        
        //String eURL1 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+Name;
        //req1.setEndpoint(eURL1);
        //if(!Test.isRunningTest())
        //(new Http()).send(req1);        
        
        string attName = '.'+recId+'.sfdb';
        Blob txtBlob = Blob.valueOf('Do not delete');
        String eURLID = 'https://api-content.dropbox.com/1/files_put?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+attName;
        req1.setBodyAsBlob(txtBlob);
        req1.setHeader('Content-Length', String.valueOf(13));
        req1.setHeader('Content-Type', 'application/octet-stream');
        req1.setEndpoint(eURLID);
        if(!Test.isRunningTest())    
            (new Http()).send(req1);
            
        String eURL2 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/AHJ';
        req1.setEndpoint(eURL2);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL3 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/Install%20Pics ';
        req1.setEndpoint(eURL3);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL4 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/QC%20Pics';
        req1.setEndpoint(eURL4);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL5 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/PPT%20Pics ';
        req1.setEndpoint(eURL5);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL6 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/Site%20Survey';
        req1.setEndpoint(eURL6);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL7 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/Plans%20%26%20Permit';
        req1.setEndpoint(eURL7);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL8 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/Completion%20Docs ';
        req1.setEndpoint(eURL8);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
        
        String eURL9 = 'https://api.dropbox.com/1/fileops/create_folder?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+'/FSD%20Pics';
        req1.setEndpoint(eURL9);
        if(!Test.isRunningTest())
        (new Http()).send(req1);            
   }
   @Future(callout=true)
   public static void deleteDropBoxFolder(String recId, string Name)  
   {
        String appPath = Label.DropboxAppName;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setTimeout(60*1000); 
        // for sandbox replace "/opportunity/" with "/opportunity/sandbox/"  in url 
        String eURL1 = 'https://api.dropboxapi.com/1/fileops/delete?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&path='+appPath+Name;
        req1.setEndpoint(eURL1);
        if(!Test.isRunningTest())
        (new Http()).send(req1);
   }
   @Future(callout=true)
   public static void updateDropboxfolder(string recId, string oldname, string newName){
      String appPath = Label.DropboxAppName;
      HttpRequest req1 = new HttpRequest();
      req1.setMethod('POST');
      req1.setTimeout(60*1000); 
      // for sandbox replace "/opportunity/" with "/opportunity/sandbox/"  in url 
      String eURL1 = 'https://api.dropboxapi.com/1/fileops/move?access_token='+accessToken+'&oauth_consumer_key='+consumerKey+'&root=auto&from_path='+appPath+oldname+'&to_path='+appPath+newName;
      system.debug('Hello Kumar'+eURL1);
      req1.setEndpoint(eURL1);
      if(!Test.isRunningTest())
      (new Http()).send(req1);
   }
   
}*/