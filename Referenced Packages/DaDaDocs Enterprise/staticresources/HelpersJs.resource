// Sort by field
// --------------------------------------
var SF_sortDom = (function($) {
    var sortFlag = true;

    // Ascending sort
    var ascendingSortByField = function(a, b, field) {
        return ($(b).find(field).text().toUpperCase()) < ($(a).find(field).text().toUpperCase()) ? 1 : -1;
    }

    // Descending sort
    var descendingSortByField = function(a, b, field) {
        return ($(b).find(field).text().toUpperCase()) > ($(a).find(field).text().toUpperCase()) ? 1 : -1;
    }

    var sort = function  (field) {
        var ascendingSort = function(a, b) {
            return ascendingSortByField(a, b, field)
        }

        var descendingSort = function(a, b) {
            return descendingSortByField(a, b, field)
        }

        sortFlag = !sortFlag;
        var list = $('.dadadocs_tab_active .dadadocs_documents-items')
        var listItem = list.find('.dadadocs_document__row');

        if (listItem) {
            if (sortFlag) {
                listItem.sort(ascendingSort)
                    .appendTo(list);
            } else {
                listItem.sort(descendingSort)
                    .appendTo(list);
            }
        }
    }

    return {
        sort: sort
    }
})(jQuery)


// Search
// --------------------------------------
var SF_Search = (function($) {
    var search = function(searchText) {
        $('.dadadocs_tab_active .dadadocs_document__row').each(function(){
            var currentLiText = $(this).find('.dadadocs_document__name').text().toUpperCase(),
                showMatchedElement = currentLiText.indexOf(searchText) !== -1;
            $(this).toggle(showMatchedElement);
        });
    }

    return {
        search: search
    }
})(jQuery)


// Accordion
// --------------------------------------
SF_Accordion = (function($) {
    var toggle = function (trigger) {
        var triggeredElement = trigger,
            parent = triggeredElement.closest('.dadadocs__accordion'),
            accordionContent = parent.find('.dadadocs__accordion-content');

        accordionContent.slideToggle(200);
    }

    return {
        toggle: toggle
    }
})(jQuery);