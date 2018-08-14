function getWindowHeight() {
    return window.innerHeight
        || document.documentElement.clientHeight
        || document.getElementsByTagName('body')[0].clientHeight;
}

function getIframeHeight() {
    var height = getWindowHeight();
    var PADDING_VALUE = 24;
    height -= PADDING_VALUE;
    return height;
}

function openIframe() {
    var iframe = document.createElement('iframe');

    iframe.frameBorder = 0;
    iframe.width = "100%";
    iframe.height = getIframeHeight();
    iframe.id = "pdffillerIframe";
    iframe.setAttribute("src", iframeUri);
    document.getElementById("content").appendChild(iframe);
    document.getElementById("content").height = "100%";
}

function closeIframe() {
    document.getElementById("pdffillerIframe").outerHTML = '';
}

function listener(event) {
    if(event.data.iframeOrCanvas == 'iframe') {
        console.log(event.data);
        closeIframe();
        window.parent.postMessage('doneIsClicked', '*');
        dispatchCanvasEvent(event.data);
    }
    if(event.data == 'editorDone') {
        console.log(event.data);
        closeIframe();
        window.parent.postMessage('doneIsClicked', '*');
        dispatchCanvasEvent({event: "doneButtonClick", iframeOrCanvas: "iframe"});
    }
}

function resizeIframe() {
    var iframe = document.getElementById("pdffillerIframe");
    if (iframe) {
       iframe.height = getIframeHeight();
    }
}
