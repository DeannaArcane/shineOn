// TODO rewrite with jQuery
var saveAsAction = false;
var DOCUMENTS = 'documents';
var TEMPLATES = 'templates';
var DCFORMS = 'dataСollectionForms';
var PDFFILLERFILES = 'PDFfillerFiles';
var S2S_FILES = 'sendToSignFiles';
var S2S_STATUS_RESIPIENTS = 'sendToSignStatusRecipients';
var L2F_FILES = 'LinkToFillFiles';
var L2F_FORMS = 'LinkToFillForms';
var SAVE_AS_CREATE_TEMPLATE = 'createTemplate';
var SAVE_AS_EDIT_DOCUMENT = 'editDocument';
var SAVE_AS_EDIT_PDFFILLER_FILE = 'editPDFfillerFile';
var SAVE_AS_CLONE_PDFFILLER_FILE = 'clonePDFfillerFile';
var SAVE_AS_RENAME_DOCUMENT = 'renameDocument';
var SAVE_AS_RENAME_PDFFILLER_FILE = 'renamePDFfillerFile';
var SAVE_AS_MERGE_TEMPLATES = 'mergedTemplates';
var SAVE_AS_CREATE_REVERSE_TEMPLATE = 'createReverseTemplate';
var SAVE_AS_SEND_REVERSE_TEMPLATE = 'sendReverseTemplate';
var LOCAL_STORAGE_PDFFILLER_FILES = 'pdffillerFiles';
var createTemplateSaveAsName = '';
var dataCollectionRecipients = '';
var selectAttachmentPage = document.getElementsByClassName('select-attachment')[0];
var dataCollectionActionType = '';
var btnUseTemplate = document.querySelector('.dadadocs_button--use-template');

// scrollbar
var tabsContentElements = document.getElementsByClassName('dadadocs_documents__content');
for(var i=0;i<tabsContentElements.length;i++){
        Ps.initialize(tabsContentElements[i]);
    }
// highlight document
var currentDocumentId = null;
var currentDcFormTemplateId = null;
var currentDocumentType = null;
var currentDocumentTypePrefix = null;
var currentDocumentName = null;
var currentDocumentNode = {'use':null,'edit':null};

var tabsContentContainer = document.getElementsByClassName('dadadocs_template-content')[0];

// requests
var documentsRequest = false;
var useTemplatesRequest = false;
var dataCollectionFormsRequest = false;
var PDFfillerFilesRequest = false;
var S2SFilesRequest = false;
var L2FFilesRequest = false;

// tabs
var headerTabsContainer = document.getElementsByClassName('dadadocs_header-tabs')[0];
var headerTabs = document.getElementsByClassName('dadadocs_header-tabs__item');
var tabsContent = document.getElementsByClassName('dadadocs_tab');

var currentHeaderTabNode = null;
var currentContentTabNode = null;
var currentTab = null;

// radio options
var radioOptionsContainer = document.getElementsByClassName('dadadocs_delivery-radio')[0];
var radioAfterActionContainer = document.getElementsByClassName('dadadocs_after-action-radio')[0];

// radio options docx
var radioOptionsContainerDocx = document.getElementsByClassName('dadadocs_delivery-radio_docx')[0];
var radioAfterActionContainerDocx = document.getElementsByClassName('dadadocs_after-action-radio_docx')[0];

// buttons
var createTemplateButton =  document.getElementsByClassName('dadadocs_header__button_create')[0];

// current human time
function currentDate(date) {
    return date.getFullYear() + "-"
        + (date.getMonth()+1)  + "-"
        + date.getDate() + " | "
        + (date.getHours().toString().length == 1 ? "0" + date.getHours() : date.getHours()) + ":"
        + (date.getMinutes().toString().length == 1 ? "0"+ date.getMinutes() : date.getMinutes()) + ":"
        + (date.getSeconds().toString().length == 1 ? "0" + date.getSeconds() : date.getSeconds());
}

if(radioOptionsContainer){
	var checkedOptions = radioOptionsContainer.querySelector('input[checked]').getAttribute('data-radio-type');
	radioOptionsContainer.addEventListener('change', changeRadioOption);
}
if(radioAfterActionContainer){
	var checkedAfterAction = radioAfterActionContainer.querySelector('input[checked]').getAttribute('data-radio-type');
	radioAfterActionContainer.addEventListener('change', changeAfterActionOption);
}

if(radioOptionsContainerDocx){
    var checkedOptions = radioOptionsContainerDocx.querySelector('input[checked]').getAttribute('data-radio-type');
    radioOptionsContainerDocx.addEventListener('change', changeRadioOption);
}
if(radioAfterActionContainerDocx){
    var checkedAfterAction = radioAfterActionContainerDocx.querySelector('input[checked]').getAttribute('data-radio-type');
    radioAfterActionContainerDocx.addEventListener('change', changeAfterActionOption);
}
// docs
var templates = null;
var documents = null;
var dcforms = null;
var PDFfillerFiles = null;
var s2sFiles = null;
var l2fFiles = null;
var l2fFilesStatus = null;

// edit document button
var editDocument_button = document.getElementsByClassName('dadadocs_aside__button_edit')[0];

var DCSend_button = document.getElementById('send_form_button');

// audit trail button
var auditTrailButtons = document.getElementsByClassName('dadadocs_button--audit-trail');

// create reverse template button
var createReverseTemplate_button = document.getElementById('createDataCollectionTemplate');

// rename document button
var renameDocument_button = document.getElementById('renameDocumentButton');

// delete docx template button
var deleteDocxTemplateBtn = document.getElementById('deleteDocxTemplateBtn');

// delete form button
var deleteDcFormButton = document.getElementById('deleteDcFormButton');

// edit PDFfillerFiles button
var editPDFfillerFile_button = document.getElementsByClassName('dadadocs_aside__button_edit')[1];

// clone PDFfillerFiles button
var clonePDFfillerFile_button = document.getElementsByClassName('dadadocs_aside__button_clone')[0];

// rename PDFfillerFile button
var renamePDFfillerFile_button = document.getElementById('renamePDFfillerFileButton');

// delete PDFfillerFile button
var deletePDFfillerFile_button = document.getElementById('deletePDFfillerFileButton');

// tooltip
var tooltip = document.getElementsByClassName('dadadocs_tooltip')[0];
var mainContainer = document.getElementsByClassName('dadadocs_template')[0];

// mainContainer don`t catch event first time when show tooltip
var dontCatchEvent = false;

// modal
var modalContainer = document.getElementsByClassName('dadadocs-modal-wrapper')[0];
var modalForm = document.forms['dadadocs-modal-form'];
var modalFormElement = document.getElementById('dadadocs-modal-form-name');
var documentNameFromForm = null;
if(modalContainer){
	var modalContainerCloseX = modalContainer.getElementsByClassName('dadadocs-modal-header__close-button')[0];
}

var modalFormDataCollectionCreateButton = document.getElementsByClassName('dadadocs_button--create')[0];
var modalFormDataCollectionUpdateButton = document.getElementsByClassName('dadadocs_button--update')[0];
var modalFormOkButton = document.getElementsByClassName('dadadocs-modal-actions__button--ok')[0];

// tab init
initCurrentTab();
// event listeners
headerTabsContainer.addEventListener('click', changeCurrentTab);

tabsContentContainer.addEventListener('click', changeCurrentDocument);

//S2SDC
var dataCollectionDeliveryType = dataCollectionDeliveryTypes.linkToFill;
var dataCollectionDeliveryCheckbox = document.getElementById('dataCollectionDeliveryCheckbox');

if (dataCollectionDeliveryCheckbox) {
    dataCollectionDeliveryCheckbox.addEventListener('change', function() {
        if (dataCollectionDeliveryCheckbox.checked) {
            dataCollectionDeliveryType = dataCollectionDeliveryTypes.sendToSign;
        } else {
            dataCollectionDeliveryType = dataCollectionDeliveryTypes.linkToFill;
        }
    });
}

// Tab events
var tabDocuments = document.querySelector('.dadadocs_tab--documents'),
    tabTemplates = document.querySelector('.dadadocs_tab--templates'),
    tabDocxTemplate = document.querySelector('.dadadocs_tab--docx-templates'),
    tabPDFfillerFiles = document.querySelector('.dadadocs_tab--pdf-filler-files');


// Documents tab / ClassicSelectAttachment
if (tabDocuments && tabDocuments.querySelector('.dadadocs_documents-items')) {
    tabDocuments.querySelector('.dadadocs_documents-items').addEventListener('dblclick', function(e) {
        var target = e.target;
        var mergeStatus = tabDocuments.classList.contains('dadadocs_tab--merge');
        if (!mergeStatus && !target.classList.contains('dadadocs_documents__content')) {
            editDocumentButton(e);
        }
    });
}

if (btnUseTemplate) {
    btnUseTemplate.onclick = function () {
        DaDaDocsAction('useTemplate');
    }
};

// PDFFiller files tab
if (tabPDFfillerFiles && tabPDFfillerFiles.querySelector('.dadadocs_documents-items')) {
    tabPDFfillerFiles.querySelector('.dadadocs_documents-items').addEventListener('dblclick', function(e) {
        var target = e.target;
        if (!target.classList.contains('dadadocs_documents__content')) {
            editPDFfillerFileButton(e);
        }
    });
}

// Docx Templates tab / ClassicSelectAttachment
if (tabDocxTemplate && tabDocxTemplate.querySelector('.dadadocs_documents-items')) {
    tabDocxTemplate.querySelector('.dadadocs_documents-items').addEventListener('dblclick', function() {
        toggleLoader();
        useFileTemplate(currentDocumentId,checkedOptions,checkedAfterAction);
    });
}

// PDF Templates tab / ClassicSelectTemplates
j$(document).on ('dblclick', '.dadadocs_tab--pdf-templates .dadadocs_document__row', function() {
    DaDaDocsAction('editTemplate')
});

// Docx Templates tab / ClassicSelectTemplates
j$(document).on ('dblclick', '.dadadocs_tab--docx-templates-admin .dadadocs_document__row', function() {
    editFileTemplate(currentDocumentId);
});


if (DCSend_button) {
   DCSend_button.addEventListener('click', sendReverseTemplate);
}

if(editDocument_button){
	editDocument_button.addEventListener('gaIsSent', editDocumentButton);
}

if(auditTrailButtons){
  Array.prototype.forEach.call(auditTrailButtons, function(button) {
    button.addEventListener('gaIsSent', auditTrailButtonAction);
  });
}

if(createReverseTemplate_button){
	createReverseTemplate_button.addEventListener('click', createReverseTemplate);
}

if(renameDocument_button){
	renameDocument_button.addEventListener('gaIsSent', renameDocumentButton);
}

if(deleteDcFormButton){
	deleteDcFormButton.addEventListener('gaIsSent', deleteDcFormAction);
}

if(editPDFfillerFile_button){
    editPDFfillerFile_button.addEventListener('gaIsSent', editPDFfillerFileButton);
}

if(clonePDFfillerFile_button){
    clonePDFfillerFile_button.addEventListener('gaIsSent', clonePDFfillerFileButton);//need continue
}

if(deletePDFfillerFile_button){
    deletePDFfillerFile_button.addEventListener('gaIsSent', deletePDFfillerFileButton);
}

if(renamePDFfillerFile_button){
    renamePDFfillerFile_button.addEventListener('gaIsSent', renamePDFfillerFileButton);
}

if(deleteDocxTemplateBtn){
    deleteDocxTemplateBtn.addEventListener('click', deleteDocxTemplateAction);
}

if(deletePdfTemplateBtn){
    deletePdfTemplateBtn.addEventListener('gaIsSent', deleteTemplateAction);
}

if(modalFormElement){
    modalFormElement.onkeypress = function (e) {
        if (e.keyCode == 13) {
            modalFormSubmit(e);
        }
    }
}

// function removeTooltip not in listeners section(in tooltip section) because use in two places
mainContainer.addEventListener('click', removeTooltip);

// modal
if(modalContainer){
	modalContainer.addEventListener('click', hideModal);
	modalFormOkButton.addEventListener('click',  modalFormSubmit);
	modalContainerCloseX.addEventListener('click', hideModal);

    if (modalFormDataCollectionCreateButton) {
        modalFormDataCollectionCreateButton.addEventListener('click', dataCollectionCreateForm);
    }

    if (modalFormDataCollectionUpdateButton) {
        modalFormDataCollectionUpdateButton.addEventListener('click', dataCollectionUpdateForm);
    }
}

function resetCurrentDocumentInfo() {
    currentDocumentId = null;
    currentDocumentType = null;
    currentDocumentTypePrefix = null;
    currentDocumentName = null;
    currentDocumentNode[currentTab] = null;
    currentDcFormTemplateId = null;
    dataCollectionActionType = '';
}

// functions to listeners
function changeCurrentTab(e) {
    var target = e.target;

    if (target.classList.contains('dadadocs_header-tabs__link')) {
        target = target.parentElement;
        removeTabLoader(currentTab);
        removeNoTemplatesElement();
        setCurrentTab(target);

        j$(document).trigger('Tab:changeTab', []);
    }
}

function changeRadioOption(e) {
    checkedOptions = e.target.getAttribute('data-radio-type');
}

function changeAfterActionOption(e) {
    checkedAfterAction = e.target.getAttribute('data-radio-type');
}

function changeCurrentDocument(e) {
    var target = e.target;
    if (target.classList.contains('dadadocs_template-content')) {
        return;
    }
    while (target && !target.classList.contains('dadadocs_document__row')) {
        target = target.parentElement;

        if (target && target.classList.contains('dadadocs_template-content')) {
            return
        }
    }

    if (target === currentDocumentNode[currentTab]) {
        return
    }
    chooseCurrentDocument(target);
}

function clonePDFfillerFileButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    openSaveAsDialog(SAVE_AS_CLONE_PDFFILLER_FILE);
}

function editPDFfillerFileButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    openSaveAsDialog(SAVE_AS_EDIT_PDFFILLER_FILE);
}

function auditTrailButtonAction(e) {
    DaDaDocsAction('openAuditTrail');
}

function sendReverseTemplate(e) {
        e.preventDefault();

        if (currentDocumentId == null) {
            return;
        }

        openSaveAsDialog(SAVE_AS_SEND_REVERSE_TEMPLATE);
}

function editDocumentButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    openSaveAsDialog(SAVE_AS_EDIT_DOCUMENT);
}

function deleteTemplateAction(e) {
    e.preventDefault();

    if (currentDocumentId === null) {
        return;
    }
    new SF.Confirm(popupLabels.confirmMessages.deleteTemplate, deleteTemplate);
}

function deletePDFfillerFileButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    new SF.Confirm(popupLabels.confirmMessages.deletePdfFillerFile, deletePDFfillerFile);
}

function deleteDcFormAction(e) {
    e.preventDefault();

    if (currentDocumentId === null) {
        return;
    }

    new SF.Confirm(popupLabels.confirmMessages.deleteDataCollectionForm, deleteDataCollectionForm);
}

function renameDocumentButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    openSaveAsDialog(SAVE_AS_RENAME_DOCUMENT);

}

function renamePDFfillerFileButton(e) {
    e.preventDefault();

    if(currentDocumentId == null) {
        return;
    }

    openSaveAsDialog(SAVE_AS_RENAME_PDFFILLER_FILE);
}


// disable submit popup on enter
function disableSubmitPopupOnEnter() {
    window.onkeydown = function(e){
        if(e.keyCode == 13) {
            var popupDataCollection = document.querySelector('.dadadocs-modal--data-collection');

            if (popupDataCollection) {
                e.preventDefault();
                return false;
            }
        }
    }
}

function createReverseTemplate(e) {
    e.preventDefault();
    if (currentTab === 'edit') {
        if (currentDocumentId === null) {
            return;
        }

        checkDataCollectionAvailability(
            function () {
                openSaveAsDialog(SAVE_AS_CREATE_REVERSE_TEMPLATE);
                disableSubmitPopupOnEnter();
            },
            parentId
        );
    }
}

function deleteDocxTemplateAction(e) {
    e.preventDefault();

    if (currentDocumentId === null) {
        return;
    }

    var docxTemplatesTab = j$('.dadadocs_tab--docx-templates-admin'),
        template = docxTemplatesTab.find('.dadadocs_document__row');

    var callBackDeleteDocxTemplate = function () {
        deleteFileTemplate(currentDocumentId);
        // remove last template from DOM
        if (template.length === 1) {
            template.remove();
        }
    }

    if (template[0]) {
        new SF.Confirm(popupLabels.confirmMessages.deleteDocxTemplate, callBackDeleteDocxTemplate);
    }
}

function openSaveAsDialog(actionName) {
    saveAsAction = actionName;

    j$('.dadadocs-modal-labels').hide();
    j$('#dataCollectionDeliveryChecker').hide();
    if (document.getElementById('dadadocs-modal-form-name')) {
        document.getElementById('dadadocs-modal-form-name').value = currentDocumentName;
    }

    showModalWindow();
    document.getElementById('dadadocs-modal-form-name').focus();
    new SF.DeselectText();

    if (actionName == SAVE_AS_CREATE_TEMPLATE) {
        j$('.dadadocs-modal-labels-templates').show();
    }

    if (actionName == SAVE_AS_CLONE_PDFFILLER_FILE) {
        j$('.dadadocs-modal-labels-clone-pdffiller-file').show();
    }

    if ((actionName == SAVE_AS_EDIT_DOCUMENT)  || (actionName == SAVE_AS_EDIT_PDFFILLER_FILE)) {
        j$('.dadadocs-modal-labels-documents').show();
    }

    if ((actionName == SAVE_AS_RENAME_DOCUMENT) || (actionName == SAVE_AS_RENAME_PDFFILLER_FILE)) {
        j$('.dadadocs-modal-labels-rename').show();
        document.getElementById('dadadocs-modal-form-name').select();
    }

    if (actionName == SAVE_AS_MERGE_TEMPLATES) {
        j$('.dadadocs-modal-labels-merge-templates').show();
    }

    if (actionName == SAVE_AS_CREATE_REVERSE_TEMPLATE) {
        j$('.dadadocs-modal-labels-dcforms').show();
        j$('#dataCollectionDeliveryChecker').show();
        j$('.dadadocs-modal--action').addClass('dadadocs-modal--data-collection');
    }

    document.getElementById('dadadocs-modal-form-name').value = currentDocumentName;

    if (actionName == SAVE_AS_SEND_REVERSE_TEMPLATE) {
        j$('.dadadocs-modal-labels-dcforms-s2s').show();
        document.getElementById('dadadocs-modal-form-name').value = '';
    }

    if (actionName == SAVE_AS_MERGE_TEMPLATES) {
        var date = new Date();

        document.getElementById('dadadocs-modal-form-name').value = 'Merged documents ' + currentDate(date);
        document.getElementsByClassName('dadadocs-modal-wrapper')[0].classList.add("dadadocs-modal-wrapper--merge")
    }
}

function afterNameForm()
{
    toggleLoader();

    var validationResult = nameValidateAndFilter();

    if(!validationResult) {
        return;
    }

    var isNewName = currentDocumentName != documentNameFromForm;

    if (saveAsAction == SAVE_AS_CREATE_REVERSE_TEMPLATE) {
        createTemplateSaveAsName = currentDocumentName;
        if (isNewName) {
            createTemplateSaveAsName = documentNameFromForm;
        }
        toggleLoader();
        return;
    }

    if (saveAsAction == SAVE_AS_EDIT_PDFFILLER_FILE) {
        if (isNewName) {
            renamePDFfillerFile(documentNameFromForm);
        }
        DaDaDocsAction('edit');
        return;
    }

    if (saveAsAction == SAVE_AS_CLONE_PDFFILLER_FILE) {
        var onSuccessHandler = function (response) {
            getDocuments();
            toggleLoader();
            setCurrentTab(headerTabs[0]);
        }

        callService(
            "PUT",
            "/documents/fromPDFfiller",
            {
                urlParams: {
                    parentId: parentId,
                    documentId: currentDocumentId,
                    newDocumentName: documentNameFromForm
                }
            },
            function (response) {
                currentDocumentType = 'chatter';
                onSuccessHandler(response);
            },
            function () {
                handleError('documents');
            }
        );
        return;
    }

    if (saveAsAction == SAVE_AS_SEND_REVERSE_TEMPLATE) {
            dataCollectionRecipients = documentNameFromForm;
            toggleLoader();
            DaDaDocsAction('sendReverseTemplate');
            return;
        }

    if (saveAsAction == SAVE_AS_EDIT_DOCUMENT) {
        var onSuccessHandler = function () {
            toggleLoader();
            DaDaDocsAction('editDocument');
        }

        if (isNewName) {
            getSaveAsId(onSuccessHandler);
            return;
        }
        onSuccessHandler();
    }

    if (saveAsAction == SAVE_AS_RENAME_DOCUMENT) {
    toggleLoader();
        if (isNewName) {
            renameDocument(documentNameFromForm);
            return;
        }
        return;

    }

    if (saveAsAction == SAVE_AS_RENAME_PDFFILLER_FILE) {
        toggleLoader();
        if (isNewName) {
            renamePDFfillerFile(documentNameFromForm);
            return;
        }
        return;
    }

    return;
}

function nameValidateAndFilter() {
    if(documentNameFromForm.trim() == '') {
            document.getElementById('dadadocs-modal-form-name').value = documentNameFromForm;
            showFormError();
            removeLoader();
            showModalWindow();
            return false;
    }
    return true;
}


function hideModal(e) {
    if (e.target === modalContainer || e.target == modalContainerCloseX) {
        hideModalWindow();
        hideFormError();
    }
}

function modalFormSubmit(e) {
    e.preventDefault();
    documentNameFromForm = document.getElementById('dadadocs-modal-form-name').value;
    hideModalWindow();
    if (documentNameFromForm) {
        hideFormError();
    }
    setTimeout(function(){afterNameForm();}, 10);
}

function dataCollectionCreateForm(e) {
    e.preventDefault();
    dataCollectionActionType = dataCollectionTypes.create;
    dataCollectionForm(e);
}

function dataCollectionUpdateForm(e) {
    dataCollectionActionType = dataCollectionTypes.update;
    dataCollectionForm(e);
}

function dataCollectionForm(e) {
    e.preventDefault();
    documentNameFromForm = document.getElementById('dadadocs-modal-form-name').value;
    hideModalWindow();
    setTimeout(function(){afterNameForm();}, 10);
}

// Show Create Template button on certain tabs
function toggleCreateTemplateButton (currentTabName, expectedTabName) {
    if (createTemplateButton !== undefined) {
        if (currentTabName === expectedTabName) {
            createTemplateButton.style.display = "block";
        } else {
            createTemplateButton.style.display = "none";
        }
    }
}

// tabs functions
function initCurrentTab() {
    if(getStorageCurrentTab()) {
        setHashCurrentTab(getStorageCurrentTab());
    } else {
        setHashCurrentTab('edit');
    }

    currentTab = getHashCurrentTab();

    if (currentTab === 'edit') {
        toggleCreateTemplateButton(currentTab, 'edit');
    } else if (currentTab === 'use') {
        toggleCreateTemplateButton(currentTab, 'use');
    }

    if (currentTab && headerTabs.length > 1) {
        setCurrentTab();
        return
    }
    setCurrentTab(headerTabs[0]);
}

// sidebar - [send by email] / [share via link] button call
var callButton;
document.querySelector('.dadadocs_tab__aside').addEventListener('gaIsSent', function(e) {
    var classList = e.detail.target.classList;
    if (classList.contains('dadadocs_aside__share-via-link')) {
        callButton = 'dadadocs_aside__share-via-link';
    } else if (classList.contains('dadadocs_button--send-document')) {
        callButton = 'dadadocs_button--send-document';
    }
});

function setCurrentTab(tabNode) {
    var mergeMode = document.querySelector('.dadadocs_tab--merge');
    var tabIndex = null;

    // destroy document merge mode
    if (currentTab === 'edit' && tabNode && tabNode.getAttribute('data-tab-type') !== currentTab && mergeMode) {
        documentsList.toggleDocumentMergeModeAction();
    }

    // destroy template merge mode
    if (currentTab === 'use' && tabNode && tabNode.getAttribute('data-tab-type') !== currentTab && mergeMode) {
        documentsList.toggleTemplateMergeModeAction();
    }

    if (currentHeaderTabNode && currentContentTabNode) {
        currentHeaderTabNode.classList.remove('dadadocs_header-tabs__item_active');
        currentContentTabNode.classList.remove('dadadocs_tab_active');
    }

    if (tabNode) {
        currentHeaderTabNode = tabNode;
    } else {
        currentHeaderTabNode = Array.prototype.filter.call(headerTabs, function (item) {
            return currentTab === item.getAttribute('data-tab-type');
        })[0];
    }

    tabIndex = Array.prototype.indexOf.call(headerTabs, currentHeaderTabNode);

    if (tabIndex < 0) {
        tabIndex = 0;
        currentHeaderTabNode = headerTabs[0];
    }

    currentHeaderTabNodeStyle = window.getComputedStyle(currentHeaderTabNode);  // need to refactor
    if(currentHeaderTabNodeStyle.display == 'none' ){                           // temp solution
        currentHeaderTabNode = headerTabs[0];                                   // we must not render disabled features and need to block then in backend
        tabIndex = 0;
    }

    currentContentTabNode = tabsContent[tabIndex];

    currentHeaderTabNode.classList.add('dadadocs_header-tabs__item_active');
    currentContentTabNode.classList.add('dadadocs_tab_active');

    setStorageCurrentTab(currentHeaderTabNode);
    currentTab = getHashCurrentTab(tabNode);
    currentTab = getStorageCurrentTab();

    j$(document).on('SearchSalesforceContacts:showPreviousPopup', function(event) {
        if (currentTab === 'edit' && callButton === 'dadadocs_button--send-document') {
            new SF.ShareDocumentWithEmailAndMessage(SF.sendDocumentByEmail);
        }

        if (currentTab === 'edit' && callButton === 'dadadocs_aside__share-via-link') {
            new SF.ShareDocumentViaLink();
        }

        if (currentTab === 'fileStatus') {
            new SF.ShareDocumentWithEmail(sendL2FEmail);
        }

        if (currentTab === 'fileTemplates') {
            new SF.SendToSignTemplController().init();
        }
    });

    if (currentTab === 'use' && !templates) {
        if (!useTemplatesRequest) {
            getTemplates();
            return
        }
        addTabLoader();
        return
    }

    if (currentTab === 'edit' && !documents) {
        if (!documentsRequest) {
          getDocuments();
          return;
        }
        addTabLoader();
        return
    }

    if (currentTab === 'pdffiller' && !PDFfillerFiles) {
        if (!PDFfillerFilesRequest) {
            getPDFfillerFiles();
            return;
        }
        addTabLoader();
        return
    }

    if (currentTab === 'fileStatus' && !s2sFiles && j$('.tabs__content-item--s2s-files.tabs__content-item--active')[0]) {
        if (!S2SFilesRequest) {
            getS2sJSON();
            return;
        }
        addTabLoader();
        return
    }

    if (currentTab === 'fileStatus' && !l2fFiles && j$('.tabs__content-item--l2f-files.tabs__content-item--active')[0]) {
        if (!L2FFilesRequest) {
            getL2fJSON();
            return;
        }
        addTabLoader();
        return
    }

    chooseCurrentDocument();
    Ps.update(tabsContentElements[tabIndex]);
}

// storage tab
function setStorageCurrentTab(tab) {
    tab = tab.getAttribute('data-tab-type');
    localStorage.setItem('dadadocs-tab', tab);
}

function getStorageCurrentTab() {
    return localStorage.getItem('dadadocs-tab');
}

function setHashCurrentTab(tab) {
    if (!getHashCurrentTab()) {
        window.location.href = window.location.href + '#tab=' + tab;
    }
}

function getHashCurrentTab(tabNode) {
    var hashTab = null;
    if (tabNode) {
        hashTab = tabNode.getAttribute('data-tab-type');
    } else {
        var splitedUrl = window.location.href.split('#');
        splitedUrl.forEach(function(item) {
            if( item.search(/tab=[A-z]+/) != -1 ) {
                hashTab = item.split('=')[1];
            }
        });
    }
    return hashTab;
}

// set clicked document active, unset active another document
j$(document).on('click', '.dadadocs_tab_active .dadadocs_document__row', function () {
    // if tabs inside tab
    if (j$('.dadadocs_tab_active .tabs__content-item')[0]) {
        j$('.tabs__content-item--active .dadadocs_document__row').removeClass('dadadocs_document__row_active');
        j$(this).addClass('dadadocs_document__row_active');
    } else { // for first tabs row
        j$('.dadadocs_tab_active .dadadocs_document__row').removeClass('dadadocs_document__row_active');
        j$(this).addClass('dadadocs_document__row_active');
    }
});

// current document
function chooseCurrentDocument(currentDocument) {

    var currentTabDocuments = currentContentTabNode.getElementsByClassName('dadadocs_document__row');
    var indexActiveRow = 0;

    if (currentTabDocuments.length === 0) {
        addNoTemplatesElement();
        return;
    } else {
        for (var i = 0; i < currentTabDocuments.length; i++) {
            if (currentTabDocuments[i].style.display != 'none') {
                indexActiveRow = i;
                break;
            }
        }
    }

    currentDocumentNode[currentTab] = currentTabDocuments[indexActiveRow];

    if (currentDocument) {
		currentDocumentNode[currentTab] = currentDocument;
	}

    var documentRows =  document.querySelectorAll('.dadadocs_tab_active .dadadocs_document__row');
    if (currentTab !== 'fileStatus' && documentRows) {
        var indexListVisibleRows = [];
        Array.prototype.forEach.call( documentRows, function (documentRow, index) {
            if(documentRow.style.display != 'none') {
                indexListVisibleRows.push(index);
            }
            documentRow.classList.remove('dadadocs_document__row_active');
        });
        if (documentRows[indexListVisibleRows[0]]) {
            documentRows[indexListVisibleRows[0]].classList.add('dadadocs_document__row_active');
        }
    }

    currentDocumentId = currentDocumentNode[currentTab].getAttribute('data-id');
    currentDcFormTemplateId = currentDocumentNode[currentTab].getAttribute('data-templateId');
    dataCollectionActionType = currentDocumentNode[currentTab].getAttribute('data-actiontype');
    currentDocumentName = currentDocumentNode[currentTab].getAttribute('data-name');
    currentDocumentType = currentDocumentNode[currentTab].getAttribute('data-type');
    var docObject = currentDocumentNode[currentTab].getElementsByClassName('dadadocs_document__object')[0];
    if (docObject) {
        currentDocumentTypePrefix = docObject.getAttribute('data-prefix');
    }

    if (currentTab == 'dataCollection') {
        var currentDocumentActionType = currentDocumentNode[currentTab].getAttribute('data-actionType');

        if (currentDocumentActionType && currentDocumentActionType == 'DCcreate') {
            createSingleUserForm.innerHTML = 'Create Fillable Form';
        } else if (currentDocumentActionType && currentDocumentActionType == 'DCupdate'){
            createSingleUserForm.innerHTML = 'Create Single User Form';
        }
    }
    j$(document).trigger('CurrentDocument:set', [currentDocument, currentTab]);
}

// loader
 j$('.g-wrap-loading_global').removeClass('g-wrap-loading_active');
function addLoader() {
    var loader = document.getElementsByClassName('g-wrap-loading_global')[0];
    loader.classList.add('g-wrap-loading_active');
}

function toggleLoader() {
    var loader = document.getElementsByClassName('g-wrap-loading_global')[0];
    loader.classList.toggle('g-wrap-loading_active');
}

function removeLoader() {
    var loader = document.getElementsByClassName('g-wrap-loading_global')[0];
    loader.classList.remove('g-wrap-loading_active');
}

function addTabLoader() {
    var loader = document.getElementsByClassName('g-wrap-loading_tab')[0];
    loader.classList.add('g-wrap-loading_active');
}

function removeTabLoader(tab) {
    if (currentTab === tab) {
        var loader = document.getElementsByClassName('g-wrap-loading_tab')[0];
        loader.classList.remove('g-wrap-loading_active');
    }
}

function removeAllLoaders() {
    var loader = document.getElementsByClassName('g-wrap-loading_tab')[0];
    loader.classList.remove('g-wrap-loading_active');
}

// no templates
function removeNoTemplatesElement() {
    var noTemplates = currentContentTabNode.getElementsByClassName('dadadocs_documents__no-templates')[0];
    noTemplates.classList.remove('dadadocs_documents__no-templates_active');
}

function addNoTemplatesElement() {
    var noTemplates = currentContentTabNode.getElementsByClassName('dadadocs_documents__no-templates')[0];

    resetCurrentDocumentInfo();
    noTemplates.classList.add('dadadocs_documents__no-templates_active');
}

function refreshList(result, type) {
    var documentRowTemplate,
        renderContainer,
        scrollingContainer,
        parsedResult = JSON.parse(result);
        resetCurrentDocumentInfo();
    var allTypesDocuments = parsedResult.map(function(item) {
        return item.icon;
    });

    if (type === TEMPLATES) {
        templates = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="universalTemplates"]').innerHTML;
        renderContainer = document.querySelector('.dadadocs_tab--templates .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.dadadocs_tab--templates .dadadocs_documents__content');
        useTemplatesRequest = false;
        j$(document).trigger('Templates:isReady', [parsedResult]);
    }

    if (type === DOCUMENTS) {
        documents = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="document"]').innerHTML;
        renderContainer = document.querySelector('.dadadocs_tab--documents .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.dadadocs_tab--documents .dadadocs_documents__content');
        documentsRequest = false;
    }

    if (type === PDFFILLERFILES) {
        PDFfillerFiles = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="PDFfillerFile"]').innerHTML;
        renderContainer = document.querySelector('.dadadocs_tab--pdf-filler-files .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.dadadocs_tab--pdf-filler-files .dadadocs_documents__content');
        PDFfillerFilesRequest = false;
        j$(document).trigger('PdffillerFiles:isReady', [parsedResult]);
    }

    if (type === DCFORMS) {
        dcforms = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="dcform"]').innerHTML;
        renderContainer = document.querySelector('.dadadocs_tab--data-collection .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.dadadocs_tab--data-collection .dadadocs_documents__content');
        dataCollectionFormsRequest = false;
        j$(document).trigger('DataCollectionForms:isReady', [parsedResult]);
    }

    if (type === S2S_FILES) {
        s2sFiles = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="sendToSignFiles"]').innerHTML;
        renderContainer = document.querySelector('.tabs__content-item--s2s-files .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.tabs__content-item--s2s-files .dadadocs_documents__content');
        S2SFilesRequest = false;
    }

    if (type === S2S_STATUS_RESIPIENTS) {
        s2sFiles = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="'+S2S_STATUS_RESIPIENTS+'"]').innerHTML;
        renderContainer = document.querySelector('.tabs__content-item--s2s-files .dadadocs_documents__status-recipients');
        scrollingContainer = document.querySelector('.tabs__content-item--s2s-files .dadadocs_documents__content');
        // S2SFilesRequest = false;
    }

    if (type === L2F_FILES) {
        l2fFiles = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="linkToFillFiles"]').innerHTML;
        renderContainer = document.querySelector('.tabs__content-item--l2f-files .dadadocs_documents-items');
        scrollingContainer = document.querySelector('.tabs__content-item--l2f-files .dadadocs_documents__content');
        L2FFilesStatusRequest = false;
    }

    if (type === L2F_FORMS) {
        l2fFilesStatus = parsedResult;
        documentRowTemplate = document.querySelector('[data-template="' + L2F_FORMS + '"]').innerHTML;
        renderContainer = document.querySelector('.tabs__content-item--l2f-files .dadadocs_documents__status-recipients');
        scrollingContainer = document.querySelector('.tabs__content-item--l2f-files .dadadocs_documents__content');
    }

    renderContainer.innerHTML = getDocumentsList(parsedResult, documentRowTemplate);
    if (type === DOCUMENTS) {
        j$(document).trigger('Documents:isReady', [allTypesDocuments]);
    }

    removeNoTemplatesElement();
    chooseCurrentDocument();
    Ps.update(scrollingContainer);
    removeTabLoader(currentTab);
}

function getDocumentsList(docs, template) {
    var documentsList = '';
    var rowTemplate;

    docs.forEach(function (doc) {
        rowTemplate = template;
        Object.keys(doc).forEach(function(key) {
            if (doc[key]) {
                doc[key] = String(doc[key]).replace(/\"/g,'\'');
                rowTemplate = rowTemplate.replace(new RegExp('{doc-' + key + '}', 'g'), doc[key]);
            }
        });

        documentsList += rowTemplate;
    });

    return documentsList;
}

function handleError(type, error) {
    if (type === DOCUMENTS) {
        documentsRequest = false;
        removeTabLoader('edit');
    }

    if (type === TEMPLATES) {
        useTemplatesRequest = false;
        removeTabLoader('use');
    }

    if (type === DCFORMS) {
        dataCollectionFormsRequest = false;
        removeTabLoader('dataCollection');
    }

    if (type === PDFFILLERFILES) {
        PDFfillerFilesRequest = false;
        removeTabLoader('pdffiller');
    }

    if (type ===  S2S_FILES) {
        S2SFilesRequest = false;
        removeTabLoader('fileStatus');
    }

    if (type ===  L2F_FILES) {
        S2SFilesRequest = false;
        removeTabLoader('fileStatus');
    }
}

// tooltip functions
function addTooltip() {
    tooltip.classList.add('dadadocs_tooltip_active');
    var timer = setTimeout(function () {
    removeTooltip();
    }, 5000);

    tooltip.setAttribute('data-timer', timer);
}

function removeTooltip(e) {
    if (!dontCatchEvent) {
        if (e) {
            clearTimeout(tooltip.getAttribute('data-timer'));
        }

        tooltip.classList.remove('dadadocs_tooltip_active');
    }
    dontCatchEvent = false;
}

// modal
function showModalWindow() {
    modalContainer.classList.add('dadadocs-modal-wrapper_active');
    if (saveAsAction == SAVE_AS_CREATE_REVERSE_TEMPLATE) {
        j$('.dadadocs-modal--action').addClass('dadadocs-modal--data-collection');
    }
}

function hideModalWindow() {
    modalContainer.classList.remove('dadadocs-modal-wrapper_active');
    j$('.dadadocs-modal--action').removeClass('dadadocs-modal--data-collection');
}

function showFormError() {
    modalForm.classList.add('dadadocs-modal-content_invalid');
}

function hideFormError() {
    modalForm.classList.remove('dadadocs-modal-content_invalid');
}

// pdffiller files
function changePdffillerFilesStatus(e) {
    var target = e.target;
    setPdffillerFilesStatus(target.checked);
    pdffillerFiles = getPdffillerFilesStatus();
    getDocuments(pdffillerFiles);
}

function getPdffillerFilesStatus() {
    var status = localStorage.getItem(LOCAL_STORAGE_PDFFILLER_FILES);
    if (status == 'true') {
        return true
    }

    return false;
}

function setPdffillerFilesStatus(status) {
    localStorage.setItem(LOCAL_STORAGE_PDFFILLER_FILES, status);
}

function getUploadToSalesforceStatus() {
    var status = localStorage.getItem(LOCAL_STORAGE_PDFFILLER_FILES_UPLOAD);
    if (status == 'true') {
          return true
    }

    return false;
}

function setUploadToSalesforceStatus(status) {
    localStorage.setItem(LOCAL_STORAGE_PDFFILLER_FILES_UPLOAD, status);
}

function checkUploadToSalesforceSwitcher() {
    var checkboxSwitcher = document.getElementsByClassName('dadadocs_documents-switcher-checkbox-wrapper_modal')[0];

    if (currentDocumentType === 'pdffiller') {
          checkboxSwitcher.classList.add('dadadocs_documents-switcher-checkbox-wrapper_modal-active');
    } else {
        checkboxSwitcher.classList.remove('dadadocs_documents-switcher-checkbox-wrapper_modal-active');
    }
}

function renameDocument(newName) {
    newName = newName.trim();
    if(currentDocumentId == null || newName == null || newName == '') {
        return;
    }

    addTabLoader();

    var onSuccessAction = function(result) { getDocuments(); }
    var onErrorAction = function(error) {
        showSFMessage('Could not rename due to Salesforce error: ' + error, uploadButtonSettings.notifyTypes.warning);
        getDocuments(false);
    }

    callService(
        "POST",
        "/documents/rename",
        {
            urlParams: {
                newName: newName,
                objectId: currentDocumentId
            }
        },
        onSuccessAction,
        onErrorAction
    );
}

function renamePDFfillerFile(newName) {
    newName = newName.trim();
    if(currentDocumentId == null || newName == null || newName == '') {
        return;
    }

    addTabLoader();

    var onSuccessAction = function(result) {
        getPDFfillerFiles();
    }

    var onErrorAction = function(error) {
        showSFMessage('Could not rename due to Salesforce error: ' + error, uploadButtonSettings.notifyTypes.warning);
        getPDFfillerFiles();
    }

    callService(
        "POST",
        "/documents/PDFfillerRename",
        {
            urlParams: {
                newName: newName,
                objectId: currentDocumentId
            }
        },
        onSuccessAction,
        onErrorAction
    );
}

function deleteTemplate() {
    addTabLoader();

    var onSuccessAction = function(result) { getTemplates(); }
    var onErrorAction = function(error) { getTemplates(); }

    callService(
        "DELETE",
        "/documents/template",
        {
            urlParams: {
                templateId: currentDocumentId,
                initialObjectName: currentDocumentNode[currentTab].getAttribute('data-objecttype')
            }
        },
        onSuccessAction,
        onErrorAction
    );
}

// Document/Template Packages //

// Action panel with interactive elements
var ActionPanelView = function  () {

    // toggle merge button name
    function checkMergeState () {
        var isMerge = false;
        if (j$(currentContentTabNode).hasClass('dadadocs_tab--merge')) {
            isMerge = true;
        } else {
            isMerge = false;
        }
        j$(document).trigger('MergeDocuments:changeIsMerged', [isMerge]);
    };

    // allow only pdf documents for merge
    function showOnlyPdfDocumentsForMerge () {
        if (j$(currentContentTabNode).hasClass('dadadocs_tab--merge')) {
            j$(currentContentTabNode).find('.dadadocs_document__row').hide();
            j$(currentContentTabNode).find('.dadadocs_document__row_pdf').show();
        } else {
            j$(currentContentTabNode).find('.dadadocs_document__row').show();
        }
    };

    function showAllAcceptDCForMerge () {
        if (j$(currentContentTabNode).hasClass('dadadocs_tab--merge')) {
            j$(currentContentTabNode).find('.dadadocs_document__row--DCForm').hide();
        } else {
            j$(currentContentTabNode).find('.dadadocs_document__row').show();
        }
    }

    // change tab content title for merge
    function toggleContentTitle () {
        var tabTitle = j$(currentContentTabNode).find('.dadadocs_documents-header__title');
        var mergeMode = j$('.dadadocs_tab--merge').length;

        if (mergeMode > 0) {
            tabTitle.text('Select PDF Documents For Merging');
        } else {
            tabTitle.text('Choose Document');
        }
    };

    return {
        toggleDocumentMergeMode: function () {
            j$(currentContentTabNode).toggleClass('dadadocs_tab--merge');
            j$(currentContentTabNode).toggleClass('dadadocs_tab_active');
            showOnlyPdfDocumentsForMerge();
            checkMergeState();
            toggleContentTitle();
        },

        toggleTemplateMergeMode: function () {
            j$(currentContentTabNode).toggleClass('dadadocs_tab--merge');
            j$(currentContentTabNode).toggleClass('dadadocs_tab_active');
            showAllAcceptDCForMerge();
            checkMergeState();
        },
    }
};

var actionPanel = new ActionPanelView();


// Single templates list item
var DocumentsListView = function () {
    var mergeOrder = [],
        MIN_NUMBER_DOCUMENTS_FOR_MERGE = 2,
        MAX_NUMBER_DOCUMENTS_FOR_MERGE = 5;

    // if template checked show its merge order number
    function toggleOrderBadge (elem) {
        var currentItem = elem.closest('.dadadocs_document__row'),
            currentCounter = currentItem.find('.dadadocs_document__selected-counter');

        if (elem.is(':checked')) {
            currentCounter.show();
        } else {
            currentCounter.hide();
        }
    };

    // if more than two checked documents show merge button
    function toggleMultipleButtons () {
        var isMergeMode = j$('.is-multiple-mode'),
            checkedCheckbox = j$(".dadadocs_document__checkbox:checked"),
            btnUploadDocument = j$('.dadadocs_header__button_upload'),
            btnUploadChatterFile = j$('#chatterFile'),
            btnCreateTemplate = j$('.dadadocs_header__button_create-multiple-documents'),
            btnMultiple = j$('.dadadocs_button-multiple'),
            btnBackToDocuments = j$('.dadadocs_button--back-to-documents'),
            btnBackToTemplates = j$('.dadadocs_button--back-to-templates'),
            storagesDropdownTrigger = j$('.storages-dropdown-trigger'),
            uncheckAllButton = j$('.dadadocs_documents__reset-merge-button');

        if(currentTab === 'edit' && isMergeMode.length) {
            btnUploadDocument.attr('disabled', true);
            btnUploadChatterFile.attr('disabled', true);
            storagesDropdownTrigger.attr('disabled', true);
        } else {
            btnUploadDocument.attr('disabled', false);
            btnUploadChatterFile.attr('disabled', false);
            storagesDropdownTrigger.attr('disabled', false);
        }

        if (checkedCheckbox.length >= MIN_NUMBER_DOCUMENTS_FOR_MERGE) {
            if(currentTab === 'edit') {
                btnCreateTemplate.attr('disabled', false);
            }

            btnMultiple.attr('disabled', false);
            uncheckAllButton.show();
        } else {
            btnCreateTemplate.attr('disabled', true);
            btnMultiple.attr('disabled', true);
            btnBackToDocuments.attr('disabled', false);
            btnBackToTemplates.attr('disabled', false);
            uncheckAllButton.hide();
        }
    };

    // add to array selected templates for merge
    function setSelectedTemplates (currentCheckbox) {
        var currentTemplate = currentCheckbox.closest('.dadadocs_document__row'),
            currentTemplateId = currentTemplate.data('id'),
            currentIndex = mergeOrder.indexOf(currentTemplateId);

        if (currentCheckbox.is(':checked') && currentIndex === -1) {
            mergeOrder.push(currentTemplateId);
        } else if (currentIndex > -1) {
            mergeOrder.splice(currentIndex, 1);
        }
    };

    // allow only strict amount files for merge
    function disableSelectDocumentsIfMoreThanLimit (checkedItems, notCheckedItems) {
        if (checkedItems.length >= MAX_NUMBER_DOCUMENTS_FOR_MERGE) {
            new SF.AddAlert('warning', 'Notification', '5 File Max');
            notCheckedItems.attr("disabled", true);
        } else {
            notCheckedItems.attr("disabled", false);
        }
    };

    // actions on checkbox change
    function onCheckboxChange () {
        j$('.dadadocs_document__row').each(function (index, elem) {
            var orderIndex = j$(this).find('.dadadocs_document__selected-counter'),
                templateId = j$(this).data('id'),
                checkedItems = j$('.dadadocs_tab--merge .dadadocs_document__checkbox:checked'),
                notCheckedItems = j$('.dadadocs_tab--merge .dadadocs_document__checkbox:not(:checked)');

            mergeOrder.forEach( function (idForMerge, i) {
                if (templateId === idForMerge) {
                    orderIndex.text(i + 1);
                }
            });

            disableSelectDocumentsIfMoreThanLimit(checkedItems, notCheckedItems);
        });
    };

    // reset merged list of files
    function resetCheckedList () {
        j$('.dadadocs_document__checkbox').prop('checked', false);
        j$('.dadadocs_document__selected-counter').hide();
        mergeOrder = [];
        toggleMultipleButtons();
    };

    function toggleMultiple() {
        document.querySelector('.dadadocs_template').classList.toggle('is-multiple-mode');
    }

    // destroy merge mode
    function toggleDocumentMerge () {
        toggleMultiple();
        resetCheckedList();
        actionPanel.toggleDocumentMergeMode();
    };
    function toggleTemplateMerge () {
        toggleMultiple();
        resetCheckedList();
        actionPanel.toggleTemplateMergeMode();
    };

    return {
        mergeActions: function (elem) {
            toggleOrderBadge (elem);
            setSelectedTemplates (elem);
            toggleMultipleButtons ();
            onCheckboxChange ();
        },
        getMergeOrder: function () {
            return mergeOrder;
        },
        resetCheckedDocuments: function () {
            return resetCheckedList();
        },
        toggleDocumentMergeModeAction: function () {
            return toggleDocumentMerge ();
        },
        toggleTemplateMergeModeAction: function () {
            return toggleTemplateMerge ();
        }
    }
};

var documentsList = new DocumentsListView();

// Actions
j$(document).on('click', '.dadadocs_document__row', function () {
    if (j$('.dadadocs_tab--merge')[0]) {

        var checkbox = j$(this)
            .closest('.dadadocs_document__row')
            .find('.dadadocs_document__checkbox');

            if (checkbox.is(':checked') && checkbox.is(':not(:disabled)')) {
                checkbox.prop('checked', false)
            } else if (checkbox.is(':not(:disabled)')) {
                checkbox.prop('checked', true)
            }

        documentsList.mergeActions(checkbox);
    }
});

j$(document).on('click', '.dadadocs_document__checkbox', function(e) {
    e.stopPropagation();
    var checkbox = j$(this)
        .closest('.dadadocs_document__row')
        .find('.dadadocs_document__checkbox');

    documentsList.mergeActions(checkbox);
});

j$('.dadadocs_documents__reset-merge-button').click( function() {
    documentsList.resetCheckedDocuments();
});

function disableButtonsForDocumentType () {
    var parent = j$('.dadadocs_tab_active'),
        documentItem = parent.find('.dadadocs_document__row_active'),
        documentType = documentItem.find('.dadadocs_document__subject').text().toLowerCase(),
        createTemplateButton = j$('.dadadocs_header__button_create'),
        dataCollectionFromButton = j$('.dadadocs_aside__use-option--collection-template');

    if (documentItem[0] && documentType === 'document') {
        createTemplateButton.prop('disabled', true);
        dataCollectionFromButton.prop('disabled', true);
    } else {
        createTemplateButton.prop('disabled', false);
        dataCollectionFromButton.prop('disabled', false);
    }
}

var linkToFillTab = document.querySelector('.tabs__content-item--l2f-files');
if(linkToFillTab) {
    linkToFillTab.addEventListener('gaIsSent', function(e) {
        var currentElement = e.detail.target;
        if(currentElement.classList.contains('dadadocs_button--l2f-copy-link')) {
            var link = currentElement.getAttribute('data-link'),
                hint = currentElement.parentElement.querySelector('.hint');
            SF.copyToCBFromCreatedInput(link, hint);
        }
    })
}

// action when switch between tabs
j$('.dadadocs_header-tabs__item').click(function () {
    var currentTabNode = j$(this),
        activeDocument = j$('.dadadocs_document__row_active'),
        activeDocumentType = activeDocument.find('.dadadocs_document__subject'),
        createTemplateButton = j$('.dadadocs_header__button_create');

    // disable create template button if document type is 'document'
    if (currentTabNode.data('tab-type') === 'edit') {
        if (activeDocumentType.text().toLowerCase() === 'document') {
            createTemplateButton.prop('disabled', true)
        }
    } else {
        createTemplateButton.prop('disabled', false)
    }


    // show Create Template button on specific tabs
    var isTemplatesTabVisible = document.querySelector('.dadadocs_header-tabs__item--templates').style.display !== 'none';
    if (isTemplatesTabVisible) {
        if (currentTabNode.data('tab-type') === 'edit' || currentTabNode.data('tab-type') === 'use') {
            createTemplateButton.show();
        } else {
            createTemplateButton.hide();
        }
    }
});

// show search after load, before it is hidden
j$('.dadadocs__search_field').show();


// disable сreate template button for documents type
j$(document).on('click', '.dadadocs_document__row', function () {
    if (!j$('.dadadocs_tab--merge')[0] && j$('.dadadocs_header__button_create')[0]) {
        disableButtonsForDocumentType()
    }
});

// show/hide Create Template button if Templates tab is present or not
function toggleCreateTemplateButtonInNoTemplatesTab () {
    var isTemplatesTabVisible = document.querySelector('.dadadocs_header-tabs__item--templates').style.display !== 'none';

    if (isTemplatesTabVisible && createTemplateButton) {
        createTemplateButton.style.display = 'block';
    } else if (createTemplateButton) {
        createTemplateButton.style.display = 'none';
    }
}

toggleCreateTemplateButtonInNoTemplatesTab();