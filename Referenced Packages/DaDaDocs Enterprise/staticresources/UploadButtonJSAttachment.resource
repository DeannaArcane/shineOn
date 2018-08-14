function prepareUploadButtonAttachment() {
    var button_overlay = j$('#upload_button:not(.forIE)');
    var button_header =  j$('.dadadocs_header__button_upload');
    var attachmentWindow = null;
    button_header.show();
    button_header.click(function () {
        if(typeof ga !== "undefined") {
            ga('send', {
                hitType: 'event',
                eventCategory: uploadButtonSettings.messages.gaEventCategoryAttachmentUpload,
                eventAction: 'upload',
                eventLabel: uploadButtonSettings.messages.gaEventLabelAttachmentUpload
            });
        }
        let concatenator = "?";
        if(uploadButtonSettings.utilPageUrl.indexOf('?') > -1){
            concatenator = '%26';
        }
        attachmentWindow = window.open("/p/attach/NoteAttach?pid="+parentId+"&isdtp=nv&retURL="+uploadButtonSettings.utilPageUrl + concatenator + "action=close",
            "AttachmentWindow",
            "directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=400,height=450");
        var timer = setInterval(checkChild, 500);
        function checkChild() {
            if (attachmentWindow.closed) {
                clearInterval(timer);
                var oldDocumentsList = document.querySelectorAll('.dadadocs_document__row');
                getDocuments();
                j$(document).on('GetDocument:success', function(event, result) {
                    var parsedResult = JSON.parse(result);
                    if(oldDocumentsList.length != parsedResult.length) {
                        j$(document).trigger('ChangeInput:uploadAttachment', [parsedResult[0].icon]);
                    }
                });
            }
        }
    });
}

document.addEventListener('DOMContentLoaded', function(){
    prepareUploadButtonAttachment();
}, false);