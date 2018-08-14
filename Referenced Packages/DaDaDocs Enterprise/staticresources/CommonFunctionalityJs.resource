// sort
j$('.dadadocs_documents__header > div').click (function () {
    var el = j$(this);
    var tableItem = j$('.dadadocs_tab_active .dadadocs_document__row');

    // toggle arrow if not empty
    if (tableItem.length > 0) {
        el.siblings().removeClass('is-sorted')
        el.toggleClass('is-sorted');
    }

    // sorting by column
    if (el.hasClass('dadadocs_documents__header-name')) {
        SF_sortDom.sort('.dadadocs_document__name');
    } else if (el.hasClass('dadadocs_documents__header-subject')) {
        SF_sortDom.sort('.dadadocs_document__subject');
    } else if (el.hasClass('dadadocs_documents__header-object')) {
        SF_sortDom.sort('.dadadocs_document__object');
    } else if (el.hasClass('dadadocs_documents__header-date')) {
        SF_sortDom.sort('.dadadocs_document__date');
    }
});

// search
j$('.dadadocs__search_field').keyup(function() {
    var searchText = j$(this).val().toUpperCase();
    SF_Search.search(searchText);
});