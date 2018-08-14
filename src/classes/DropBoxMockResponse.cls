/*
Class Name    : DropBoxMockResponse 
Created by    : Clayton Thomas
Created On    : 10/30/2017
Description : This class provide the mock response for dropbox folder creation & deletion. 

History    
1. 00/00/0000 –Dev Name, changes made, User Story number.
2. 00/00/0000 – Dev Name, changes made, User Story number

*/
@isTest
global class DropBoxMockResponse implements HttpCalloutMock {
    global static string serviceStatus;

    global HTTPResponse respond(HTTPRequest req) {
        system.debug('req***'+req);
        String dropboxCreateFolderEndpoint = 'https://api.dropboxapi.com/2/files/create_folder_v2';
        String dropboxDeleteFolderEndpoint = 'https://api.dropboxapi.com/2/files/delete_v2';
        String dropContentUploadEndpoint = 'https://content.dropboxapi.com/2/files/upload';
        
        HttpResponse res = new HttpResponse();    
        string jsonpayload;
        if(req.getMethod() == 'POST' && serviceStatus == 'Success'){
            if(req.getEndpoint().contains(dropboxCreateFolderEndpoint))
                jsonpayload = '{"metadata":{"name":"math","id":"id:a4ayc_80_OEAAAAAAAAAXz","path_lower":"/homework/math","path_display":"/Homework/math","sharing_info":{"read_only":false,"parent_shared_folder_id":"84528192421","traverse_only":false,"no_access":false},"property_groups":[{"template_id":"ptid:1a5n2i6d3OYEAAAAAAAAAYa","fields":[{"name":"Security Policy","value":"Confidential"}]}]}}';
            else if(req.getEndpoint().contains(dropboxDeleteFolderEndpoint))
                jsonpayload = '{"metadata":{".tag":"file","name":"Prime_Numbers.txt","id":"id:a4ayc_80_OEAAAAAAAAAXw","client_modified":"2015-05-12T15:50:38Z","server_modified":"2015-05-12T15:50:38Z","rev":"a1c10ce0dd78","size":7212,"path_lower":"/homework/math/prime_numbers.txt","path_display":"/Homework/math/Prime_Numbers.txt","sharing_info":{"read_only":true,"parent_shared_folder_id":"84528192421","modified_by":"dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"},"property_groups":[{"template_id":"ptid:1a5n2i6d3OYEAAAAAAAAAYa","fields":[{"name":"Security Policy","value":"Confidential"}]}],"has_explicit_shared_members":false,"content_hash":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"}}';
            else if(req.getEndpoint().contains(dropContentUploadEndpoint))
                jsonpayload = '{"name":"Prime_Numbers.txt","id":"id:a4ayc_80_OEAAAAAAAAAXw","client_modified":"2015-05-12T15:50:38Z","server_modified":"2015-05-12T15:50:38Z","rev":"a1c10ce0dd78","size":7212,"path_lower":"/homework/math/prime_numbers.txt","path_display":"/Homework/math/Prime_Numbers.txt","sharing_info":{"read_only":true,"parent_shared_folder_id":"84528192421","modified_by":"dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"},"property_groups":[{"template_id":"ptid:1a5n2i6d3OYEAAAAAAAAAYa","fields":[{"name":"Security Policy","value":"Confidential"}]}],"has_explicit_shared_members":false,"content_hash":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"}';
            res.setStatus('OK');
            res.setStatusCode(200);
        }
        if(req.getMethod() == 'POST' && (serviceStatus == 'Failure' || serviceStatus == 'ServiceFailure')){
            jsonpayload = '{}'; 
            res.setStatus('Bad Request');
            res.setStatusCode(400);        
        }              
        
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonpayload);
        return res;
        
    }
}