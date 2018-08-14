function prepareUploadButtonIE() {
    if(!detectIE()){
        return;
    }
    button_overlay = document.querySelector('#upload_button.forIE');
    if (button_overlay.querySelector('#publisherAttachContentPost') == null) {
        return;
    }
    eventFireIE(button_overlay.querySelector('#publisherAttachContentPost'), 'click');
    eventFireIE(button_overlay.querySelector('#chatterUploadFileAction'), 'click');
    var obj_to_hide = button_overlay.querySelectorAll('.uploadFileSizeLimit, .clearContentPanelButtonContainer, .publisherFeedItemTypeChoices, .cxfeedinnerwrapper, .publisherBottomBarPlaceholder, .publisherTextAreaPlaceholder.alignCenter');
    for (var i = 0; i != obj_to_hide.length; ++i) {
        obj_to_hide[i].style.display = "none"; // hidden has to be a string
    }
    slideStyle = button_overlay.querySelector('.contentPublisherSlideDown.customPanel.alignTop').style;
    slideStyle.border = 0;
    slideStyle.background = 'none';
    button_overlay.querySelector('#chatterFile').onchange = function() {

        if (getFilesizeIE(this) == 0) {
            reloadWithMessageIE(uploadButtonSettings.messages.unSuccess, uploadButtonSettings.notifyTypes.message);
        }

        if(typeof ga !== "undefined"){
            ga('send', {
                hitType: 'event',
                eventCategory: uploadButtonSettings.messages.gaEventCategoryChatterUploadIe,
                eventAction: 'upload',
                eventLabel: uploadButtonSettings.messages.gaEventLabelChatterUploadIe,
            });
        }

        filename = this.value.split(/(\\|\/)/g).pop();

        chatter.getPublisher().submit();
        button_overlay.querySelectorAll('.publishercontainer.zen.cxchattertextareacontainer.chattertextareacontainer')[0].style.display = 'none';
        this.style.display = 'none';
        chatter.getEventBus().addEventListener("chatter:feed", "onAfterNewPostFeedUpdate", function() {
            if (checkExtIE(filename)) {
                reloadWithMessageIE(uploadButtonSettings.messages.success);
            } else {
                reloadWithMessageIE(uploadButtonSettings.messages.successWithUnsupportedExt, uploadButtonSettings.notifyTypes.message);
            }
        })

        j$(document).trigger('ChangeInput:uploadFileInIE', [SF.getFileExtension(this.value)]);

    };
    button_overlay.style.display = "block";
    document.querySelector('.dadadocs_header__button_upload').style.display = "block";

}

function reloadWithMessageIE(message, type) {
    if (type == undefined) {
        type = uploadButtonSettings.notifyTypes.success
    }
    setStorageCurrentTab(headerTabs[0]);
    redirect(uploadButtonSettings.currentPageUrl + '?' + uploadButtonSettings.parentIdArgName + '=' + uploadButtonSettings.parentId + '&' + type + '=' + message);

}

function checkExtIE(filename) {
    var re = /(?:\.([^.]+))?$/;
    var ext = re.exec(filename)[1]
    if(ext){
        ext=ext.toLowerCase();
    }else{
        return false;
    }
    return uploadButtonSettings.enabledExtensions.indexOf(ext) != -1

}

function eventFireIE(el, etype) {
    if (el.fireEvent) {
        el.fireEvent('on' + etype);
    } else {
        var evObj = document.createEvent('Events');
        evObj.initEvent(etype, true, false);
        el.dispatchEvent(evObj);
    }
}

function getFilesizeIE(inputObject) {
    if (window.ActiveXObject) {
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var filepath = inputObject.value;
        var thefile = fso.getFile(filepath);
        var sizeinbytes = thefile.size;
    } else {
        var sizeinbytes = inputObject.files[0].size;
    }
    return sizeinbytes;
}

document.addEventListener('DOMContentLoaded', function(){
    prepareUploadButtonIE();
}, false);

