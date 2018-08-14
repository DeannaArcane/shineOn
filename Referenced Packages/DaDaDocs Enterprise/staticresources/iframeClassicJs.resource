function openIframe() {

    var MIN_HEIGHT = 800;
    var needRefreshWithFullScreen = !IS_FULL_SCREEN
        && !IS_LIGHTNING
        && location.href.indexOf('&isFullScreen=') === -1
        && getWindowHeight() < MIN_HEIGHT
        && getParameterByName('pdfAction') != 'openAuditTrail';
    if (needRefreshWithFullScreen) {
        location.replace(location.href + '&isFullScreen=true' + '&iframeUri=' + encodeURIComponent(iframeUri));
        return;
    }

    if(!IS_FULL_SCREEN) {
        removeClassicFooter();
    }

    var iframe = document.createElement('iframe');

    iframe.frameBorder = 0;
    iframe.width = "100%";
    iframe.height = getIframeHeight();
    iframe.id = "pdffillerIframe";
    iframe.setAttribute("src", iframeUri);
    document.getElementById("iframeContent").appendChild(iframe);
    iframe.onload = function() {
        sendToGa('openedIframe');
        loaderRemove();
    }
}

function closeIframe() {
    document.getElementById("iframeContent").style.height = getIframeHeight() + 'px';
    loaderAdd();
    document.getElementById("pdffillerIframe").outerHTML = '';
}

function resizeIframe() {
    var iframe = document.getElementById("pdffillerIframe");
    if (iframe) {
        iframe.height = getIframeHeight();
    }
}

function editorDone(data) {
    sendToGa('doneIframe');
    closeIframe();
    callprocessEvent(JSON.stringify(data));
}

function listener(event) {
    if(event.data == 'editorDone') {
        editorDone({iframeOrCanvas:"iframe", event:"doneButtonClick"});
    }
    if(event.data.iframeOrCanvas == 'iframe') {
        editorDone(event.data);
    }
}

if (window.addEventListener) {
    window.addEventListener("message", listener);
} else {
    // IE8
    window.attachEvent("onmessage", listener);
}

function getWindowHeight() {
    return window.innerHeight
        || document.documentElement.clientHeight
        || document.getElementsByTagName('body')[0].clientHeight;
}

function getIframeHeight() {
    var height = getWindowHeight();
    var PADDING_VALUE = 24;
    var appBodyHaader = document.getElementById('AppBodyHeader');
    if (!IS_LIGHTNING && !IS_FULL_SCREEN && appBodyHaader !== null) {
        height -= appBodyHaader.offsetHeight;
    }
    if(!IS_FULL_SCREEN) {
        height -= PADDING_VALUE;
    }
    return height;
}

function removeClassicFooter() {
    var footerDiv = document.getElementsByClassName("bPageFooter")[0];
    var outerNoSidebar = document.getElementsByClassName("outerNoSidebar")[0];
    if (footerDiv) {
        footerDiv.parentNode.removeChild(footerDiv);
    }
    if (outerNoSidebar) {
        outerNoSidebar.style.padding = "0";
    }
}

function loaderAdd() {
    var loader = document.getElementById("orangeLoader");
    if (loader) {
        loader.classList.add('g-wrap-loading_active');
    }
}

function loaderRemove() {
    var loader = document.getElementById("orangeLoader");
    if (loader) {
        loader.classList.remove('g-wrap-loading_active');
    }
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return false;
    if (!results[2]) return false;
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function sendToGa(eventLabel) {
    if (canSentAnalytic()) {
        ga('send', {
            hitType: 'event',
            eventCategory: getEventCategory(),
            eventAction: getEventAction(),
            eventLabel: eventLabel,
        });
    }
}

function getEventCategory() {
    if (getParameterByName('objectType') === 'chatter') {
        return 'file';
    }

    return getParameterByName('objectType');
}

function getEventAction() {
    switch (getParameterByName('pdfAction')) {
        case 'send2sign':
            return 'sendToSign';
        case 'link2fill':
            return 'linkToFill';
        default:
            return 'unknownAction'
    }
}

function canSentAnalytic() {
    return !!window['ga']
        && getParameterByName('currentTab') === 'edit'
        && (getParameterByName('pdfAction') === 'send2sign' || getParameterByName('pdfAction') === 'link2fill')
}
