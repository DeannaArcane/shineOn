var LayoutsToUpdate = [];
var AllLayouts;

function initLayoutsComponent() {
    dadadocsAddLoader();
    AllLayouts = new getAllLayouts(maxLayouts, layoutsPerRequest);
    initLayoutsList();

    getElementsByClassName('dadadocs-layouts__title_order')[0].addEventListener('click', function(e) {
        AllLayouts.sortOrder = Number(!AllLayouts.sortOrder);
        AllLayouts.sortLayouts();
        renderLayouts();
    });
}

function initLayoutsList(){
    var container = document.getElementsByClassName('dadadocs-layouts__options')[0];
	container.addEventListener('click', function(e) {
        if (e.target.classList.contains('dadadocs-option__item')) {
            e.target.classList.toggle('dadadocs-option__item_checked');
            e.target.classList.add('item_changed');
            for (var i = 0, len = AllLayouts.layouts.length; i < len; i++) {
                if (AllLayouts.layouts[i].layoutFullName == e.target.attributes.name.value) {
                    AllLayouts.layouts[i].hasButton = !AllLayouts.layouts[i].hasButton
                    AllLayouts.layouts[i].changed = 1;
                }
            }
        }
	});
}

function renderLayouts(result) {
    dadadocsAddLoader();
    if (result) {
        result = JSON.parse(result);
        result.forEach(function(obj) {
            obj.changed = 0;
        });
        AllLayouts.layouts = AllLayouts.layouts.concat(result);
        AllLayouts.doneParts++;

    }
    if (AllLayouts.doneParts < AllLayouts.numParts) {
        return;
    }
    AllLayouts.sortLayouts();
    Pagination.renderPagination(AllLayouts.layouts.length);
    layoutsOnPage = AllLayouts.layouts.slice((Pagination.currentPage - 1) * layoutsPerPage, Pagination.currentPage * layoutsPerPage);
    var documentRowTemplate = document.getElementsByClassName('dadadocs-option__item_template')[0].outerHTML;
    var layoutListWrapper = document.getElementsByClassName('dadadocs-layouts__options')[0];

    var documentsList = '';

    layoutsOnPage.forEach(function(layout) {
        documentsList += documentRowTemplate.replace(/\{\{layout-name\}\}/, layout.layoutFullName)
            .replace(/\{\{layout-hasButton\}\}/, layout.hasButton ? 'dadadocs-option__item_checked' : '')
            .replace(/\{\{layout-label\}\}/, layout.userFriendlyName + ' ' + (layout.isStandard ? standardObjectLayout : customObjectLayout))
            .replace(/dadadocs-option__item_template/, '')
    });

    layoutListWrapper.innerHTML = documentsList;
	dadadocsRemoveLoader();
}

var Pagination = {
    currentPage: 1,
    renderPagination: function(layoutsCount) {
        var renderPaginationItems = [1];
        var pagesCount = Math.ceil(layoutsCount / layoutsPerPage);
        if (this.currentPage > pagesCount || this.currentPage < 0) {
            this.currentPage = 1;
        }
        renderPaginationItems.push(pagesCount, this.currentPage, this.currentPage - 1, this.currentPage + 1);
        renderPaginationItems = renderPaginationItems.filter(function(item, pos, self) {
            return self.indexOf(item) == pos && item > 0 && item <= pagesCount;
        });
        renderPaginationItems.sort(function(a, b) {
            return (a - b)
        });

        var paginationRowTemplate = document.getElementsByClassName('dadadocs_pagination__item_template')[0].outerHTML;
        var paginationListWrapper = document.getElementsByClassName('dadadocs_pagination')[0];
        var paginationList = paginationRowTemplate
            .replace(/\{\{pagination-additionalProperties\}\}/, this.currentPage == 1 ? 'dadadocs_pagination__item_prev dadadocs_pagination__item_disabled' : 'dadadocs_pagination__item_prev')
            .replace(new RegExp('{{pagination-pageNum}}', 'g'), 'pre');

        var prevPage = 0;
        renderPaginationItems.forEach(function(paginationItem) {
            if (prevPage != 0 && (paginationItem - prevPage) > 1) {
                paginationList += paginationRowTemplate.replace(new RegExp('{{pagination-pageNum}}', 'g'), '...')
                    .replace(/\{\{pagination-additionalProperties\}\}/, 'dadadocs_pagination__item_separator');
            }
            paginationList += paginationRowTemplate.replace(new RegExp('{{pagination-pageNum}}', 'g'), paginationItem)
                .replace(/\{\{pagination-additionalProperties\}\}/, Pagination.currentPage == paginationItem ? 'dadadocs_pagination__item_active' : '');
            prevPage = paginationItem;
        });
        paginationList += paginationRowTemplate
            .replace(/\{\{pagination-additionalProperties\}\}/, this.currentPage == pagesCount ? 'dadadocs_pagination__item_next dadadocs_pagination__item_disabled' : 'dadadocs_pagination__item_next')
            .replace(new RegExp('{{pagination-pageNum}}', 'g'), 'next');
        paginationListWrapper.innerHTML = paginationList.replace(new RegExp('dadadocs_pagination__item_template', 'g'), '');

        elements = paginationListWrapper.querySelectorAll(':not(.dadadocs_pagination__item_disabled):not(.dadadocs_pagination__item_active):not(.dadadocs_pagination__item_separator)')
        for (var i = 0; i < elements.length; i++) {
            elements[i].addEventListener('click', function(event) {
                event.preventDefault();
                clickedItemVal = event.target.attributes.page.value;
                if (clickedItemVal == 'pre') {
                    Pagination.currentPage--;
                } else if (clickedItemVal == 'next') {
                    Pagination.currentPage++;
                } else {
                    Pagination.currentPage = parseInt(clickedItemVal);
                }
                renderLayouts(null);
            });
        }

    },
}

function getAllLayouts(maxLayouts, layoutsPerRequest) {
    dadadocsAddLoader();
    var self = this;
    this.layouts = [];
    this.numParts = Math.ceil(maxLayouts / layoutsPerRequest);
    this.doneParts = 0;
    this.sortOrder = 0;
    this.numberOfRequestTries  = 2;
    useDocumentsRequest = true;
    this.onSuccessAction = function(result) {
        renderLayouts(result);
    }
    this.sortLayouts = function() {
        self.layouts = self.layouts.sort(function(a, b) {
            if (a.userFriendlyName.toLowerCase() < b.userFriendlyName.toLowerCase())
                return -1 + (self.sortOrder * 2);
            if (a.userFriendlyName.toLowerCase() > b.userFriendlyName.toLowerCase())
                return 1 - (self.sortOrder * 2);
            return 0;
        })
        var title = document.getElementsByClassName('dadadocs-layouts__title_order')[0]
        if (this.sortOrder == 1) {

            title.innerHTML = title.innerHTML.replace('&nbsp;↑', '&nbsp;↓');
        } else {
            title.innerHTML = title.innerHTML.replace('&nbsp;↓', '&nbsp;↑');
        }
    }
    this.failedParts = [];
    this.getPart = function(part){
        var onErrorAction = function(error) {

            if (!(part in self.failedParts)) {
                self.failedParts[part] = 0;
            }
            if (self.failedParts[part] < self.numberOfRequestTries) {
                self.failedParts[part] = self.failedParts[part] + 1;
                self.getPart(part);
            } else {
                showSFMessage(messagesText.loaded_error, 'WARNING');
                AllLayouts.doneParts++;
                renderLayouts();
            }
        }

        callService(
            "GET",
            "/layouts/",
            {
                urlParams: {
                    part: part,
                }
            },
            self.onSuccessAction,
            onErrorAction
        );
    }

    for (part = 1; part <= this.numParts; part++) {
        self.getPart(part);
    }
}

function updateLayouts() {
    dadadocsAddLoader();
    var layoutsToUpdate = [];
    for (var i = 0, len = AllLayouts.layouts.length; i < len; i++) {
        if (AllLayouts.layouts[i].changed == 1) {
            AllLayouts.layouts[i].changed=0;
            layoutsToUpdate.push(AllLayouts.layouts[i]);
        }

    }
    var numParts = Math.ceil(layoutsToUpdate.length / layoutsPerRequest);
    var doneParts = 0;
    var onSuccessUpdate = function() {
        doneParts++;
        if (doneParts >= numParts) {
            showSFMessage(messagesText.updated_success);
            dadadocsRemoveLoader();
        }
    }
    var onErrorUpdate = function() {
        showSFMessage(messagesText.updated_error,'WARNING');
        doneParts++;
        if (doneParts >= numParts) {
            dadadocsRemoveLoader();
        }
    }

    for (var part = 0; part < numParts; part++) {
        callService(
            "POST",
            "/layouts/",
            {
                postParams: {
                    layouts: JSON.stringify(layoutsToUpdate.slice(part * layoutsPerRequest, (part + 1) * layoutsPerRequest))
                }
            },
            onSuccessUpdate,
            onErrorUpdate
        );
    }
    if(numParts==0){
        showSFMessage(messagesText.nothing_to_update);
        dadadocsRemoveLoader();
    }

}

function dadadocsAddLoader() {
    document.getElementsByClassName("g-wrap-loading")[0].classList.add("g-wrap-loading_active")
}

function dadadocsRemoveLoader() {
    document.getElementsByClassName("g-wrap-loading")[0].classList.remove("g-wrap-loading_active")
}

function handleError(){
    dadadocsRemoveLoader();
}


function initLayouts(containerTable) {
    new SF.AdminPage().init();

    var container = document.getElementById(containerTable);
    if (container) {
        initLayoutsComponent();
    }
}