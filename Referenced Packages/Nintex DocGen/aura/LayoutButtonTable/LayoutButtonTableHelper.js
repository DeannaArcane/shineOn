({
    updateTableData : function(component, parsedResponse) {
        var layouts = parsedResponse.layouts;
        component.set("v.layouts", layouts);
        
        var layoutMetadataMap = this.constructLayoutMetadataMap(layouts);
        component.set("v.layoutMetadata", JSON.stringify(layoutMetadataMap));
        
        var enabledCount = this.getEnabledCount(parsedResponse.layouts);
        component.set("v.enabledCount", enabledCount);
        
        if (Object.keys(parsedResponse.customObjects).length > 0) {
        	var optionsArray = this.constructCustomObjectsArray(parsedResponse.customObjects);
            
            component.set("v.customObjectSelectOptions", optionsArray);
            $A.util.removeClass(component.find('customObjectRow'), 'rowHidden');
        }
    },
    constructLayoutMetadataMap : function(layouts) {
        var layoutMetadataMap = {};
        
        for (var i = 0; i < layouts.length; i ++) {
            var childLayouts = layouts[i].childLayouts;
            
            for (var j = 0; j < childLayouts.length; j ++) {
                layoutMetadataMap[childLayouts[j].id] = childLayouts[j].metadata;
            }
        }
        
        return layoutMetadataMap;
    },
    getEnabledCount : function(layouts) {
        var enabledCount = 0;
        
        for (var i = 0; i < layouts.length; i ++) {
            var parentLayout = layouts[i];
            var childLayouts = parentLayout.childLayouts;
            
            for (var j = 0; j < childLayouts.length; j ++) {
                if (childLayouts[j].isChecked) {
                    enabledCount ++;
                }
            }
        }
        
        return enabledCount;
    },
    constructCustomObjectsArray : function(customObjects) {
        var optionsArray = [];
        optionsArray.push({
            text: '',
            label: 'Select a custom object'
        });
        
        for (var i = Object.keys(customObjects).length - 1; i > -1; i--) {
            var customObjectKey = Object.keys(customObjects)[i];
            optionsArray.push({
                text: customObjectKey,
                label: customObjects[customObjectKey]
            });
        }
        
        return optionsArray;
    },
    filterLayouts : function(component, searchText) {
        var layouts = component.get('v.layouts');
        
        if (searchText) {
            for (var i = 0; i < layouts.length; i++) {
                var parentLayout = layouts[i];
                var isSearchTextFound = false;
                var pushParent = false;
                var expandParent = false;
                
                if (parentLayout.objectName.toLocaleUpperCase().includes(searchText.toLocaleUpperCase()) || parentLayout.layoutPageName.toLocaleUpperCase().includes(searchText.toLocaleUpperCase())) {
                    isSearchTextFound = true;
                }
                
                var childLayouts = parentLayout.childLayouts;
                for (var j = 0; j < childLayouts.length; j++) {
                    var child = childLayouts[j];
                    if (child.layoutPageName.includes(searchText)) {
                        layouts[i].isExpanded = true;
                        
                        isSearchTextFound = true;
                    }
                }
                
                layouts[i].show = isSearchTextFound;
            }
        }
        else {
            for (var i = 0; i < layouts.length; i++) {
                layouts[i].isExpanded = false;
                layouts[i].show = true;
            }
        }
        
        component.set('v.layouts', layouts);
    },
    findAncestorWithName : function(el, name) {
        while((el = el.parentElement) && el.nodeName !== name);
        return el;
    },
    toggleLinkAndSpinner : function(component, showLink) {
        if (!showLink) {
            $A.util.addClass(component.find('addButtonLink'), 'hidden');
            $A.util.removeClass(component.find('addButtonSpinner'), 'hidden');
        } else {
            $A.util.addClass(component.find('addButtonSpinner'), 'hidden');
            $A.util.removeClass(component.find('addButtonLink'), 'hidden');
        }
    },
    expandGroup : function(component, selectedRow) {
        selectedRow.setAttribute('data-expanded', 'true');
        
        // Update icon
        var div = selectedRow.childNodes[0].childNodes[0];
        var divNextSibling = selectedRow.childNodes[0].childNodes[1];
        $A.util.addClass(div, 'divHidden');
        $A.util.removeClass(divNextSibling, 'divHidden');
        
        // Update rows
        var rows = component.find('row');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i].getElement();
            if (row.getAttribute('data-is-group') === 'false' && row.id === selectedRow.id) {
                $A.util.removeClass(row, 'rowHidden');
                $A.util.addClass(row, 'slds-hint-parent');
            }
        }
    },
    retractGroup : function(component, selectedRow) {
        selectedRow.setAttribute('data-expanded', 'false');
        
        // Update icon
        var div = selectedRow.childNodes[0].childNodes[1];
        var divPreviousSibling = selectedRow.childNodes[0].childNodes[0];
        $A.util.addClass(div, 'divHidden');
        $A.util.removeClass(divPreviousSibling, 'divHidden');
        
        // Update rows
        var rows = component.find('row');
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i].getElement();
            if (row.getAttribute('data-is-group') === 'false' && row.id === selectedRow.id) {
                $A.util.addClass(row, 'rowHidden');
                $A.util.removeClass(row, 'slds-hint-parent');
            }
        }
    },
    escapeRegExp : function(str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
	},
    fireErrorEvent : function(component, message) {
        component.getEvent('showError').setParams({
            message: message
        }).fire();
    }
})