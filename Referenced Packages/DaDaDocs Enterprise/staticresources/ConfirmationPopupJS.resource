var Confirmation = function () {
    var popup = j$('#confirmation');
    var approveAction;

    function closePopup () {
        popup.removeClass('dadadocs-modal-wrapper_active');
    }

    var confirmation = function() {
        var answer = j$(this).attr('id');
        if (answer === 'yes') {
            approveAction();
        }
        closePopup();
    };

    // events
    popup.find('.dadadocs_button').click(confirmation);
    popup.find('.dadadocs-modal-header__close-button').click(closePopup);
    popup.find('.dadadocs-modal-wrapper_active').click(closePopup);

    // public methods
    return {
        show: function() {
            popup.addClass('dadadocs-modal-wrapper_active');
            return this;
        },
        onAproove: function(approve) {
            approveAction = approve;
        }
    };
};