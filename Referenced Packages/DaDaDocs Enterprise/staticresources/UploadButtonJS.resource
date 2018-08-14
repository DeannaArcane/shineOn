function prepareUploadButton() {
    if (detectIE()){
        return;
    }
    var button_overlay = j$('#upload_button:not(.forIE)');

    button_overlay.find('#chatterFile').change(function() {
        if (this.files.length < 1) {
            return;
        }
        if (this.files[0].size == 0) {
            showSFMessage(uploadButtonSettings.messages.unSuccess0Bytes, uploadButtonSettings.notifyTypes.info);
            return;
        }
        var file = this.files[0];

        if(typeof ga !== "undefined") {
            ga('send', {
                hitType: 'event',
                eventCategory: uploadButtonSettings.messages.gaEventCategoryChatterUploadStd,
                eventAction: 'upload',
                eventLabel: uploadButtonSettings.messages.gaEventLabelChatterUploadStd
            });
        }

        var formData = new FormData();
        formData.append('title',  file.name.substring(0, file.name.lastIndexOf('.')) );
        formData.append('fileData', file);
        formData.append('publishStatus', 'P');
        addTabLoader();
        j$.ajax({
            url: '/services/data/v39.0/connect/files/users/me',
            data: formData,
            type: 'POST',
            processData: false,
            contentType: false,
            cache: false,
            headers: {
                'Authorization': 'Bearer ' + sforce.connection.sessionId,
                'X-PrettyPrint': '1'
            },
            success: function(response) {
                var contentDocumentLinks = [];
                var contentDocumentLink = new sforce.SObject("ContentDocumentLink");
                contentDocumentLink.ContentDocumentId = response.id;
                contentDocumentLink.LinkedEntityId = uploadButtonSettings.parentId;
                contentDocumentLink.ShareType = "V";
                contentDocumentLinks.push(contentDocumentLink);

                var contentDocumentLinkOrg = new sforce.SObject("ContentDocumentLink");
                contentDocumentLinkOrg.ContentDocumentId = response.id;
                contentDocumentLinkOrg.LinkedEntityId = uploadButtonSettings.orgId;
                contentDocumentLinkOrg.ShareType = "C";
                contentDocumentLinks.push(contentDocumentLinkOrg);

                var results = sforce.connection.create(contentDocumentLinks);
                if (results[0].success!='true') {
                    showSFMessage(uploadButtonSettings.messages.unSuccess +' ' + (results[0].errors.message ?  results[0].errors.message +'.' : '') +' '+ uploadButtonSettings.messages.fileUploadUnsuccessTryAttachment, uploadButtonSettings.notifyTypes.warning)
                    removeTabLoaderAfterUpload();
                    return;
                }

                if (checkExt(file.name)) {
                    if(SF.isStoreFileToExternalStorage === 'true') {
                        callService(
                            "GET",
                            "/documents/upload_to",
                            {
                                urlParams: {
                                    parentId: parentId,
                                    documentId: response.id,
                                    newDocumentName: file.name
                                }
                            },
                            function() {
                                sforce.connection.deleteIds([response.id]);
                                getDocuments();
                            },
                            function() {}
                        );
                    } else {
                        getDocuments();
                    }
                    setCurrentTab(headerTabs[0]);
                    showSFMessage(uploadButtonSettings.messages.success, uploadButtonSettings.notifyTypes.success);
                    removeTabLoaderAfterUpload();
                    j$(document).trigger('ChangeInput:uploadFile', [SF.getFileExtension(file.name)]);
                    return;
                } else {
                    showSFMessage(uploadButtonSettings.messages.successWithUnsupportedExt, uploadButtonSettings.notifyTypes.info);
                    removeTabLoaderAfterUpload();
                    return;
                }

            },
            error: function(response) {
                showSFMessage(uploadButtonSettings.messages.unSuccess + ((response && response.responseText && JSON.parse(response.responseText)[0] && JSON.parse(response.responseText)[0].message ) ?
                    ' '+JSON.parse(response.responseText)[0].message : ''), uploadButtonSettings.notifyTypes.warning);
                removeTabLoaderAfterUpload();
                return;
            }
        });


    });


    button_overlay.show();
    j$('.dadadocs_header__button_upload').show();

}

function removeTabLoaderAfterUpload(){
    var loader = document.getElementsByClassName('g-wrap-loading_tab')[0];
    loader.classList.remove('g-wrap-loading_active');
}

function checkExt(filename) {
    var re = /(?:\.([^.]+))?$/;
    var ext = re.exec(filename)[1]
    if(ext){
        ext=ext.toLowerCase();
    }else{
        return false;
    }
    return uploadButtonSettings.enabledExtensions.indexOf(ext) != -1

}

document.addEventListener('DOMContentLoaded', function(){
    prepareUploadButton();
}, false);