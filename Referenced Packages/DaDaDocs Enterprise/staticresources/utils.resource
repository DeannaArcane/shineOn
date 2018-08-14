(function (global) {
  var module = function () {
    var DEFAULT_CONTENT_ID = 'content';
    var DEFAULT_LOADER_ID = 'loader';

    /**
     * Show(hide) loader and hide(show) content.
     * @public
     * @param {boolean} state If true - display loader and hide content, other - vice versa.
     * @param {object=} options Some options.
     * @param {string=} options.contentId Id of content block element.
     * @param {string=} options.loaderId Id of loader block element.
     */
    function loadingState (state, options) {
      var params = options instanceof Object ? options : {};

      var content = document.getElementById(params.contentId || DEFAULT_CONTENT_ID);
      var loader = document.getElementById(params.loaderId || DEFAULT_LOADER_ID);

      content && (content.style.display = state ? 'none' : 'block');
      loader && (loader.style.display = state ? 'block' : 'none');
    }

    return {
      loadingState: loadingState
    }
  }();

  global.PDFfiller = global.PDFfiller || {};
  global.PDFfiller.utils = module;
})(window);
