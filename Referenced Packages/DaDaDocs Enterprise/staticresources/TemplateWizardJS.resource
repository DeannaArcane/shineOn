if (!Array.from) {
    Array.from = (function() {
        var toStr = Object.prototype.toString;
        var isCallable = function(fn) {
            return typeof fn === 'function' || toStr.call(fn) === '[object Function]';
        };
        var toInteger = function (value) {
            var number = Number(value);
            if (isNaN(number)) { return 0; }
            if (number === 0 || !isFinite(number)) { return number; }
            return (number > 0 ? 1 : -1) * Math.floor(Math.abs(number));
        };
        var maxSafeInteger = Math.pow(2, 53) - 1;
        var toLength = function (value) {
            var len = toInteger(value);
            return Math.min(Math.max(len, 0), maxSafeInteger);
        };

        return function from(arrayLike/*, mapFn, thisArg */) {
            var C = this;

            var items = Object(arrayLike);

            if (arrayLike == null) {
                throw new TypeError('Array.from requires an array-like object - not null or undefined');
            }

            var mapFn = arguments.length > 1 ? arguments[1] : void undefined;
            var T;
            if (typeof mapFn !== 'undefined') {
                if (!isCallable(mapFn)) {
                    throw new TypeError('Array.from: when provided, the second argument must be a function');
                }

                if (arguments.length > 2) {
                    T = arguments[2];
                }
            }


            var len = toLength(items.length);

            var A = isCallable(C) ? Object(new C(len)) : new Array(len);

            var k = 0;
            var kValue;
            while (k < len) {
                kValue = items[k];
                if (mapFn) {
                    A[k] = typeof T === 'undefined' ? mapFn(kValue, k) : mapFn.call(T, kValue, k);
                } else {
                    A[k] = kValue;
                }
                k += 1;
            }
            A.length = len;
            return A;
        };
    }());
}

var Clipboard = function () {
    this.tagTableContainer = document.getElementById('fieldTags');

    this.tagTableContainer.addEventListener('click', this.copyToClipboardListener.bind(this));
};

Clipboard.prototype.copyToClipboardListener = function (e) {
    var target = e.target;

    if (!target.classList.contains('dadadocs-table__copy-button')) {
        return;
    }

    var selectedLeaf = document.getElementById('objectTagsSelector');
    var leafPath = selectedLeaf.options[selectedLeaf.selectedIndex].text;
    var copyText;
    var tag = target.parentElement.parentElement.getElementsByClassName('dadadocs-table__cell_tag')[0].textContent.trim();
    if (leafPath.indexOf('[]') == -1) {
        copyText = '{{' + leafPath.substring(0,leafPath.indexOf('|')-1) + '.';
        copyText = copyText + tag.substring(2,tag.length);
    } else {
        if (leafPath.indexOf('[]') == -1) {
            copyText = '{{' + leafPath.substring(0,leafPath.indexOf('|')-1) + '.';
            copyText = copyText + tag.substring(2,tag.length);
        } else {
            var splitArr = leafPath.split("[]");
            copyText = '{{for(' + splitArr[0] + ')}}'
                + '\n %% \n{{endfor}}';
            var len = splitArr.length-1;
            for (var index = 1; index < len; ++index) {
                var innerText = '{{for(' + splitArr[index].substring(1) + ')}}'
                    + '\n %% \n{{endfor}}';
                copyText = copyText.replace('%%',innerText);
            }
            copyText = copyText.replace('%%',tag);
        }
    }
    this.copyToClipboard(copyText)
};

Clipboard.prototype.copyToClipboard = function (text) {
    var text = text.trim();
    var textArea = document.createElement("textarea");
    textArea.style.position = 'fixed';
    textArea.style.height = '0';
    textArea.style.opacity = '0';
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.select();
    try {
        var successful = document.execCommand('copy');
    } catch (err) {
        console.log('Oops, unable to copy');
    } finally {
        document.body.removeChild(textArea);
    }
};

var TagsTable = function () {
    var tmp = document.createElement("div");
    tmp.innerHTML = document.querySelector('[data-template="dadadocs-tag-item-block"]').innerHTML;
    if (IS_FLAT_TEMPLATE) {
        var innerContainer = tmp.getElementsByClassName("dadadocs-table__row")[0];
        var noflat = Array.from(innerContainer.getElementsByClassName("no_flat"));
        noflat.forEach(function (noFlatEl) {
            innerContainer.removeChild(noFlatEl);
        });
    }
    this.tagBlock = tmp;
    this.selectedObject = '';
}

TagsTable.prototype.populateTagsData = function () {
    function capitalizeFirstLetter(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }

    var __self = this;

    var tagContainer = document.getElementById('fieldTags');
    tagContainer.innerHTML = '';

    var objectSelector = document.getElementById('objectTagsSelector');
    this.selectedObject = objectSelector.options[objectSelector.selectedIndex].value;

    var tagsArray = this.getCurrentSelectedObjectTagsArr();

    var content = '';
    tagsArray.forEach(function (tag) {
        var newBlock = __self.tagBlock.cloneNode(true);
        newBlock.innerHTML = newBlock.innerHTML.replace(/{{label}}/g, tag.label)
            .replace(/{{type}}/g, IS_FLAT_TEMPLATE ? capitalizeFirstLetter(tag.type) : tag.docXType)
            .replace(/{{name}}/g, tag.name)
            .replace(/{{value}}/g, tag.value);

        if (dataCollectionType && dataCollectionType === 'DCcreate') { //for DC-create
            if (tag.required == true) {
                newBlock.innerHTML = newBlock.innerHTML
                    .replace(/{{disabled}}/g, tag.required == true ? 'disabled' : '')
                    .replace(/{{selected}}/g, 'checked')
            } else {
                newBlock.innerHTML = newBlock.innerHTML.replace(/{{selected}}/g, tag.selected == true ? 'checked' : '')
            }
        } else {
            newBlock.innerHTML = newBlock.innerHTML.replace(/{{selected}}/g, tag.selected == true ? 'checked' : '')
        }
        content += newBlock.innerHTML;
    });

    tagContainer.innerHTML = content;

    this.reRenderOrderFields();
}

TagsTable.prototype.reRenderOrderFields = function () {
    var orderFieldsContainer = document.getElementsByClassName("dadadocs-step__row--order-by-fields")[0];
    if (this.selectedObject.indexOf("[]", this.selectedObject.length - 2) !== -1) {
        //show
        orderFieldsContainer.style.display = "block";

        var orderOpts = this.getCurrentSelectedOrderOptionsArr();
        var orderFieldNameSelector = document.getElementById("orderFieldNameSelector");
        var orderResult = this.getCurrentSelectedOrderResult();

        orderOpts.forEach(function (optionData) {
            var opt = document.createElement('option');
            opt.value = optionData.value;
            opt.innerHTML = optionData.label;
            orderFieldNameSelector.appendChild(opt);
        });


        if (orderResult) {
            orderFieldNameSelector.value = orderResult.value;
            document.getElementById("orderByOptions").value = orderResult.order;
        } else {
            document.getElementById("orderByOptions").value = "ASC";
        }
    } else {
        //hide
        orderFieldsContainer.style.display = "none";
    }

}

TagsTable.prototype.getCurrentSelectedObjectTagsArr = function () {
    var tagsArray;
    for (var key in templateData.fields) {
        if (key === this.selectedObject) {
            tagsArray = templateData.fields[key];
        }
    }
    return tagsArray;
}

TagsTable.prototype.getCurrentSelectedOrderOptionsArr = function () {
    var orderOptionsArray;
    for (var key in templateData.orderOptions) {
        if (key === this.selectedObject) {
            orderOptionsArray = templateData.orderOptions[key];
        }
    }
    return orderOptionsArray;
}

TagsTable.prototype.getCurrentSelectedOrderResult = function () {
    var orderResult;
    for (var key in templateData.orderResult) {
        if (key === this.selectedObject) {
            orderResult = templateData.orderResult[key];
        }
    }
    return orderResult;
}

TagsTable.prototype.collectTagsData = function () {
    var tagsData = this.getCurrentSelectedObjectTagsArr();

    var tagContainer = document.getElementById('fieldTags');
    var tagsArr = Array.from(tagContainer.querySelectorAll('.dadadocs-table__row_tag'));

    tagsArr.forEach(function (tag) {
        var tagName = tag.getAttribute("data-name");
        var tagSelect = tag.querySelector('.dadadocs-table__cell_tag_check').checked;
        var tagValueContainer = tag.querySelector('.dadadocs-table__cell_tag_value');
        if (tagValueContainer) {
            var tagValue = tagValueContainer.value; //possible tag editing
        }
        tagsData.forEach(function (tagDataEl) {
            if (tagDataEl.name === tagName) {
                tagDataEl.selected = tagSelect;
            }
        });
    });

    //add order result
    if (document.getElementsByClassName("dadadocs-step__row--order-by-fields")[0].style.display == "block") {
        var orderResult = this.getCurrentSelectedOrderResult();
        if (!orderResult) {
            orderResult = {};
            templateData.orderResult[this.selectedObject] = orderResult;
        }
        orderResult.value = document.getElementById('orderFieldNameSelector').value;
        orderResult.order = document.getElementById('orderByOptions').value;
    }
}

var tagTable = new TagsTable();

var Relationships = function (containerClass, initRelationships, type) {
    this.relationshipsContainer = document.getElementsByClassName(containerClass)[0];
    this.selectTemplate = document.querySelector('[data-template="dadadocs-relation-select"]').innerHTML;
    this.itemContentTemplate = document.querySelector('[data-template="dadadocs-relation-item-content"]').innerHTML;
    this.itemTemplate = document.querySelector('[data-template="dadadocs-relation-item"]');
    this.type = type;
    this.relationships = initRelationships;
    this.resultRelationships = this.getRelationshipObject(initRelationships, type);
    this.initialTreeRender();

    this.relationshipsContainer.addEventListener('click', this.containerListener.bind(this));
    this.relationshipsContainer.addEventListener('change', this.replaceSelectWithItem.bind(this));
};

Relationships.prototype.initialTreeRender = function () {
    this.relationshipsContainer
        .querySelector('.dadadocs-relationships-item-content__title-name')
        .innerHTML = this.relationships.label;
    this.relationshipsContainer.setAttribute('data-name-tree', this.relationships.relationshipName);
    this.relationshipsContainer.setAttribute('data-name', this.relationships.name);

    if (this.relationships.leaves === null) {
        this.relationshipsContainer.querySelector('.dadadocs-relationships-item-content_main').classList.add('dadadocs-relationships-item-content_main-not-new');
        return
    }

    if (this.relationships.leaves.length > 0) {
        this.renderTree(this.relationshipsContainer, this.relationships, this.resultRelationships);

        if (this.relationships.leaves.length === this.resultRelationships.leaves.length) {
            this.relationshipsContainer.querySelector('.dadadocs-relationships-item-content_main').classList.add('dadadocs-relationships-item-content_main-not-new');
        }
    }
};

Relationships.prototype.renderTree = function (rootElem, renderObject, resultObject) {
    var __self = this;
    var rootNameTree = rootElem.getAttribute('data-name-tree');
    var newRootEl = __self.addNewTreeElem(rootElem);

    renderObject.leaves.forEach(function (item) {
        if (item.selected) {
            var toResultObject = __self.getRelationshipObject(item);
            resultObject.leaves.push(toResultObject);

            rootElem.querySelector('.dadadocs-relationships-item-content').classList.add('dadadocs-relationships-item-content_with-child');
            var template = __self.itemTemplate.cloneNode(true);
            var itemContent = template.querySelector('.dadadocs-relationships-item-content');
            template.classList.remove('dadadocs-relationships__item_template');
            template.querySelector('.dadadocs-relationships-item-content__title').innerHTML = item.label;
            template.setAttribute('data-name-tree', rootNameTree + '.' + item.relationshipName);
            template.setAttribute('data-name', item.name);
            template.removeAttribute('data-template');

            if (item.leaves === null) {
                itemContent.classList.add('dadadocs-relationships-item-content_not-active');
            } else if (item.leaves.length > 0 && renderObject.leaves.length === resultObject.leaves.length) {
                itemContent.classList.add('dadadocs-relationships-item-content_not-new');
            }

            newRootEl.appendChild(template);
            if (item.leaves !== null && item.leaves.length !== 0) {
                __self.renderTree(template, item, toResultObject)
            }
        }
    });
};

Relationships.prototype.containerListener = function (e) {
    var target = e.target;
    if (target.classList.contains('dadadocs-relationships-item-content__add-button')) {
        this.addNewRelationshipSelect(target);
        return
    }

    if (target.classList.contains('dadadocs-relationships-item-content__delete-button')) {
        this.deleteRelationship(target);
        return
    }
};

Relationships.prototype.addNewRelationshipSelect = function (target, options) {
    var relationshipItemContent = target.parentElement;
    var relationshipRow = relationshipItemContent.parentElement;
    if (relationshipRow.querySelector('.dadadocs-relationships-item-content_select')) {
        return;
    }
    var nameTree = relationshipRow.getAttribute('data-name-tree');
    var name = relationshipRow.getAttribute('data-name');

    if (!options) {
        options = this.getAvailableOptionsList(nameTree);
    }

    if (options === null) {
        return
    }

    if (options.length === 0) {
        this.loadRelationshipsByTree(target, nameTree, name);
        return
    }
    if (relationshipRow.children.length !== 2) {
        this.addNewTreeElem(relationshipRow);
    }

    var relationshipsContainer = relationshipRow.getElementsByClassName('dadadocs-relationships')[0];

    var selectTemplateWithOptions = this.getSelectTemplateWithOptions(options, nameTree);
    relationshipsContainer.innerHTML += selectTemplateWithOptions;
    relationshipItemContent.classList.add('dadadocs-relationships-item-content_with-child');
};


Relationships.prototype.replaceSelectWithItem = function (e) {
    var target = e.target;
    var relationContentContainer = target.parentElement;

    if (!relationContentContainer) return;

    var relationContainer = relationContentContainer.parentElement;
    var nameTree = relationContainer.getAttribute('data-name-tree');
    var parentElementContentContainer = relationContainer.parentElement.previousElementSibling;
    var relationshipRoot = this.getRelationshipByNameTree(this.relationships, nameTree);
    var relationship = relationshipRoot.leaves.filter(function (item) {
        return item.relationshipName === target.value;
    })[0];

    relationship.selected = true;
    var toResultObject = this.getRelationshipObject(relationship);

    var addedRelationships = this.addRelationshipByNameTree(this.resultRelationships, [toResultObject], nameTree);
    if (addedRelationships === relationshipRoot.leaves.length) {
        if (parentElementContentContainer.classList.contains('dadadocs-relationships-item-content_main')) {
            parentElementContentContainer.classList.add('dadadocs-relationships-item-content_main-not-new');
        } else {
            parentElementContentContainer.classList.add('dadadocs-relationships-item-content_not-new');
        }
    }

    relationContentContainer.classList.remove('dadadocs-relationships-item-content_select');
    relationContainer.setAttribute('data-name-tree', nameTree + '.' + relationship.relationshipName);
    relationContainer.setAttribute('data-name', relationship.name);
    if (relationship.leaves === null) {
        relationContentContainer.classList.add('dadadocs-relationships-item-content_not-active');
    } 
    var template = this.itemContentTemplate.replace('{{title}}', relationship.label);
    relationContentContainer.innerHTML = template;
};

Relationships.prototype.deleteRelationship = function (target) {
    var relationshipRow = target.parentElement.parentElement;
    var relationshipContainer = relationshipRow.parentElement;

    if (!relationshipContainer) return;

    var relationshipContentContainer = relationshipContainer.previousElementSibling;
    var nameTree = relationshipRow.getAttribute('data-name-tree');
    var name = relationshipRow.getAttribute('data-name');
    relationshipContainer.removeChild(relationshipRow);
    relationshipContentContainer.classList.remove('dadadocs-relationships-item-content_not-new');
    relationshipContentContainer.classList.remove('dadadocs-relationships-item-content_main-not-new');
    if (relationshipContainer.children.length === 0) {
        relationshipContentContainer.classList.remove('dadadocs-relationships-item-content_with-child');
    }
    if(name) {
        this.deleteFromRelationshipObjects(nameTree);
    }
};

Relationships.prototype.getAvailableOptionsList = function (nameTree) {
    var relationship = this.getRelationshipByNameTree(this.relationships, nameTree);
    var relationshipOptions = null;

    if (!relationship.leaves) {
        return null;
    }

    if (relationship.leaves.length === 0) {
        return [];
    }

    relationshipOptions = relationship.leaves.filter(function (item) {
        return item.selected !== true;
    });

    if (relationshipOptions.length === 0) {
        return null;
    }

    return relationshipOptions;
};

Relationships.prototype.getRelationshipByNameTree = function (relationshipsObj, nameTree) {
    if (nameTree === relationshipsObj.relationshipName) {
        return relationshipsObj;
    }

    var relationship = {};

    function findRelationship(relationshipsArray, nameTree) {
        var namesArray = nameTree.split('.');
        var relationshipName = namesArray[0];

        relationshipsArray.forEach( function(item) {
            if (relationshipName === item.relationshipName) {
                if (namesArray.length === 1) {
                    relationship = item;
                    return;
                }

                if (item.leaves !== null && item.leaves.length > 0) {
                    var newRelationshipName = namesArray.slice(1).join('.');
                    findRelationship(item.leaves, newRelationshipName);
                }
            }
        });
    };

    findRelationship(relationshipsObj.leaves, nameTree.split('.').slice(1).join('.'));
    return relationship;
};

Relationships.prototype.addRelationshipByNameTree = function (relationshipsObj, childs, nameTree) {
    var relationship = this.getRelationshipByNameTree(relationshipsObj, nameTree);
    childs.forEach(function (item) {
        relationship.leaves.push(item)
    });
    return relationship.leaves.length;
};

Relationships.prototype.loadRelationshipsByTree = function (targetNode, nameTree, name) {
    var request = {
        name: name,
        parents: this.type === 'up',
        reference: nameTree
    };

    var __self = this;
    var isLoadedData = true;

    window.processLoadedRelations = function (node) {
        setTimeout( function() {
            if (isLoadedData) {
                isLoadedData = false;
                __self.addRelationshipByNameTree(__self.relationships, node.leaves, nameTree);
                __self.addNewRelationshipSelect(targetNode, node.leaves);
            }
        }, 100)
    };

    getChildNode(JSON.stringify(request), processLoadedRelations);
};

Relationships.prototype.deleteFromRelationshipObjects = function (nameTree) {
    var relationship = this.getRelationshipByNameTree(this.relationships, nameTree);
    relationship.selected = false;
    if (relationship.leaves !== null && relationship.leaves.length > 0) {
        unselectRelationships(relationship.leaves);
    }

    function unselectRelationships(relationships) {
        relationships.forEach(function (item) {
            if (item.selected) {
                item.selected = false;
                if (item.leaves !== null && item.leaves.length > 0) {
                    unselectRelationships(item.leaves);
                }
            }
        });
    }

    this.deleteFromResultRelationships(nameTree);
};

Relationships.prototype.deleteFromResultRelationships = function (nameTree) {
    function deleteRelationship(nameTree, relationshipsArray) {
        var namesArray = nameTree.split('.');
        var relationshipName = namesArray[0];

        for (var i = 0; i < relationshipsArray.length; i++) {
            if (relationshipName === relationshipsArray[i].relationshipName) {
                if (namesArray.length === 1) {
                    relationshipsArray.splice(i, 1);
                    return;
                }

                if (relationshipsArray[i].leaves !== null && relationshipsArray[i].leaves.length > 0) {
                    var newRelationshipName = namesArray.slice(1).join('.');
                    deleteRelationship(newRelationshipName, relationshipsArray[i].leaves)
                }
            }
        }
    };

    deleteRelationship(nameTree.split('.').slice(1).join('.'), this.resultRelationships.leaves);
};

Relationships.prototype.getRelationshipObject = function (relationship) {
    var newRelationshipObject = {
        name: relationship.name,
        relationshipName: relationship.relationshipName,
        label: relationship.label,
        selected: relationship.selected,
        leaves: null
    };

    if (!!relationship.leaves) {
        newRelationshipObject.leaves = [];
    }

    return newRelationshipObject;
};

Relationships.prototype.getResultRelationships = function () {
    return this.resultRelationships;
};

Relationships.prototype.getSelectTemplateWithOptions = function (options, nameTree) {
    var selectTemplate = this.selectTemplate;
    var optionsTemplate = '<option value="{{relationshipName}}">{{label}}</option>';
    var filledOptionsTemplate = options.reduce(function (prevValue, item) {
        return prevValue + optionsTemplate
            .replace('{{relationshipName}}', item.relationshipName)
            .replace('{{label}}', item.label)
    }, '');
    return selectTemplate
        .replace('{{name-tree}}', nameTree)
        .replace('{{options}}', filledOptionsTemplate);
};

Relationships.prototype.addNewTreeElem = function (root) {
    var ul = document.createElement('ul');
    ul.classList.add('dadadocs-relationships');
    root.appendChild(ul);
    return ul;
};

var parentsTree;
var childsTree;

function initParentRelationships() {
    parentsTree = new Relationships( 'dadadocs-relationships-up',
        templateData.parents,
        'up');
}

function initChildRelationships() {
    childsTree = new Relationships('dadadocs-relationships-down',
        templateData.children,
        'down');
}

var Steps = function () {
    this.currentStep = 1;
    this.isStepFirstTime = Array.apply(null, Array(10)).map(Number.prototype.valueOf,1);
    this.nextStepButton = document.getElementsByClassName('dadadocs-actions_next')[0];
    this.backStepButton = document.getElementsByClassName('dadadocs-actions_back')[0];
    this.saveStepButton = document.getElementsByClassName('dadadocs-actions_save')[0];
    this.skipWizardButton = document.getElementsByClassName('dadadocs-actions_skip')[0];
    this.stepContainers = document.getElementsByClassName('dadadocs-step');
    this.stepListItems = document.getElementsByClassName('dadadocs-step-list__item');

    this.backStepButton.addEventListener('gaIsSent', this.changeStep.bind(this, -1));
    this.nextStepButton.addEventListener('gaIsSent', this.changeStep.bind(this, 1));
};

Steps.prototype.initStep = function () {
    this.stepListItems[this.currentStep - 1].classList.add('dadadocs-step-list__item_active');
    this.stepContainers[this.currentStep - 1].classList.add('dadadocs-step_active');
    this.updateButtons();
    j$(document).trigger('TemplateWizardJS:initGA');
    document.getElementById('cancelBtn').addEventListener('gaIsSent', function (event) {
        window.history.go(-1);
    });
};

Steps.prototype.updateButtons = function () {
    if (!IS_FLAT_TEMPLATE) {
        if (this.currentStep === 1) {
            this.backStepButton.classList.add('dadadocs-button_not-active');
            this.saveStepButton.classList.add('dadadocs-button_not-active');
        }

        if (this.currentStep > 1) {
            this.backStepButton.classList.remove('dadadocs-button_not-active');
        }

        if (this.currentStep < 6) {
            this.saveStepButton.classList.add('dadadocs-button_not-active');
            this.nextStepButton.classList.remove('dadadocs-button_not-active');
        }

        if (this.currentStep === 6) {
            this.saveStepButton.classList.remove('dadadocs-button_not-active');
            this.nextStepButton.classList.add('dadadocs-button_not-active');
        }
    } else {
        if (this.currentStep === 1) {
            this.backStepButton.classList.add('dadadocs-button_not-active');
            this.saveStepButton.classList.add('dadadocs-button_not-active');
            this.skipWizardButton.classList.add('dadadocs-button_not-active');
            this.nextStepButton.classList.remove('dadadocs-button_not-active');
        }

        if (this.currentStep === 2) {
            this.skipWizardButton.classList.remove('dadadocs-button_not-active');
            this.backStepButton.classList.remove('dadadocs-button_not-active');
            this.saveStepButton.classList.add('dadadocs-button_not-active');
            this.nextStepButton.classList.remove('dadadocs-button_not-active');
            if (dataCollectionType === 'DCcreate') {
                this.saveStepButton.classList.remove('dadadocs-button_not-active');
                this.nextStepButton.classList.add('dadadocs-button_not-active');
            }
        }

        if(this.currentStep === 3){
            this.saveStepButton.classList.remove('dadadocs-button_not-active');
            this.nextStepButton.classList.add('dadadocs-button_not-active');
        }
    }
};

Steps.prototype.changeStepContainer = function (prevStep) {
    this.stepContainers[prevStep - 1].classList.remove('dadadocs-step_active');
    this.stepContainers[this.currentStep - 1].classList.add('dadadocs-step_active');
};

Steps.prototype.changeStepTab = function (prevStep) {
    this.stepListItems[prevStep - 1].classList.remove('dadadocs-step-list__item_active');
    this.stepListItems[this.currentStep - 1].classList.add('dadadocs-step-list__item_active');
};

Steps.prototype.initTrees = function () {
    if (dataCollectionType === 'DCcreate') return;
    initParentRelationships();
    if (!IS_FLAT_TEMPLATE) {
        initChildRelationships();
    }
};

Steps.prototype.addTagObjectsOptions = function (objects) {
    var select = document.getElementById('objectTagsSelector');
    for (i = select.options.length - 1; i >= 0; i--) { //clear
        select.remove(i);
    }
    if (objects) { //populate
        var options = [];

        Object.keys(objects).forEach( function(item) {
            options.push(item);
        });

        options.sort( function(a,b) {
            // localeCompare - right way for comparison stings for different languages
            return a.localeCompare(b)
        });

        options.forEach( function(key) {
            var opt = document.createElement('option');
            opt.value = key;
            opt.innerHTML = objects[key];
            if (key === templateData.initialObjectType + ":" + templateData.initialObjectType) {
                opt.selected = 'selected';
            }
            select.appendChild(opt);
        });
    }
}

Steps.prototype.changeStep = function (step) {

    var __self = this;
    var prevStep = this.currentStep;
    var nextStep = __self.currentStep + step;

    if (!IS_FLAT_TEMPLATE) {
        var packageNameInput = document.getElementById('templateName');


        if (nextStep == 3 && step == 1) {
            if (!packageNameInput.value.trim()) {
                packageNameInput.style.background = "rgba(248, 137, 98, 0.23)";
                return;
            } else {
                packageNameInput.style.background = "#fff";
            }

            templateData.templateName = packageNameInput.value;

            if (!fileTemplateId.length) { //new template
                templateData.initialObjectType = document.getElementById('TemplateWizard:templateWizardForm:initialObjectSelector').value;
                document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'block';
                getTemplateStructureForObject(
                    templateData.initialObjectType,
                    function () {
                        __self.initTrees();
                        document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'none';
                    });
            } else { //edit template
                this.initTrees();
            }

        }
        if (nextStep == 5 && step == 1) {
            document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'block';
            templateData.parents = parentsTree.getResultRelationships();
            templateData.children = childsTree.getResultRelationships();

            refreshTemplateStructure(JSON.stringify(templateData), function (responce, sub) {
                // Todo: deal with logic and remove this code
                // changeStep(__self, prevStep);

                __self.addTagObjectsOptions(templateData.selectedObjects);

                tagTable.populateTagsData();
                document.getElementById('objectTagsSelector').onchange = function (ev) {
                    tagTable.collectTagsData();
                    tagTable.populateTagsData()
                };

                new Clipboard();
                document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'none';
                sub.subscriptions = {};
            });
            // Todo: deal with logic and remove this code
            // return;
        }

        // on went back to the first step - if user change "Select Starting Object"
        // it will refresh the wizard, do nothing if change only the "Name Document Package"
        if (nextStep == 4 && step == -1) {
            var select = document.querySelector('.dadadocs-input_select');

            if (select) {
                select.onchange = function () {
                    refreshForm();
                }
            }
        }

        if (nextStep == 2 && step == 1) {
            loadAccessParams();
        }

        if (nextStep == 6 && step == 1) {
            tagTable.collectTagsData();
            j$(document).trigger('CurrentStep:fetchDocx');
        }

    } else {

        if (nextStep == 2 && step == 1) {
            if (__self.isStepFirstTime[nextStep]) {
                let loader = new SF.Loader();
                loader.show('.g-wrap-loading_global');
                prepareForSkippingWizard();
            }
        }

        if (nextStep == 3 && step == 1) {

            document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'block';
            templateData.parents = parentsTree.getResultRelationships();

            refreshTemplateStructure(JSON.stringify(templateData), function (responce) {

                __self.addTagObjectsOptions(templateData.selectedObjects);

                tagTable.populateTagsData();
                document.getElementById('objectTagsSelector').onchange = function (ev) {
                    tagTable.collectTagsData();
                    tagTable.populateTagsData()
                };

                document.getElementById('TemplateWizard:templateWizardForm:status.start').style.display = 'none';
            });

            // Todo: deal with logic and remove this code
            // return;
        }
    }
    __self.currentStep = nextStep;
    __self.changeStepTab(prevStep);
    __self.changeStepContainer(prevStep);
    __self.updateButtons();
    __self.isStepFirstTime[__self.currentStep] = 0;
};

var SFMLSocketConnector = function (connUrl, connParams) {
    this.stompClient = null;
    this.connUrl = connUrl;
    this.connParams = connParams;
};

SFMLSocketConnector.prototype.socketConnect = function (onConnectCallback) {
    var socket = new SockJS(this.connUrl);
    this.stompClient = Stomp.over(socket);
    this.stompClient.maxWebSocketFrameSize = 1024; //bytes
    //this.stompClient.partialData = true;
    //this.stompClient.debug = {}; TODO for prod

    var __self = this;

    this.stompClient.connect(this.connParams, function (frame) {


        __self.stompClient.subscribe("/user/topic/errors", function (error) {
            console.log("Error: " + error.body);
        });

        if (onConnectCallback) {
            onConnectCallback();
        }

    }, function (error) {
        __self.socketDisconnect();
        console.log("STOMP error " + error);
    });
};

SFMLSocketConnector.prototype.socketDisconnect = function () {
    if (this.stompClient != null) {
        this.stompClient.disconnect();
    }
};

SFMLSocketConnector.prototype.socketQueueCall = function (name, message, callback) {
    var _self = this;
    if (this.stompClient != null) {
        this.stompClient.subscribe('/user/queue/' + name, function (resp) {
            if (callback) {
                callback(resp.body, _self.stompClient);
            }
        });
        this.stompClient.send('/app/' + name, {}, message);
    }
};

SFMLSocketConnector.prototype.socketDisconnect = function () {
    if (this.stompClient != null) {
        this.stompClient.disconnect();
    }
};

function clearInputErrorMessage (el) {
    el.onfocus = function() {
        this.style.background = "#fff";
    }
}

if (!IS_FLAT_TEMPLATE) {
    clearInputErrorMessage(document.getElementById('templateName'));
} else {
    loadAccessParams();
}

var templateWizard = new SF.TemplateWizard();
templateWizard.init();

var step = new Steps();
step.initStep();