(function (global) {
  var module = function () {
    var PDFFILLER_APPEVENT = 'pdffiller.appevent';
    var DEFAULT_MIN_HEIGHT = 450;
    var MIN_S2S_L2F_HEIGHT = 230;

    /**
     * @private
     * @type {boolean}
     */
    var needResize = true;

    /**
     * @private
     * @type {Number}
     */
    var minHeight = DEFAULT_MIN_HEIGHT;

    /**
     * @private
     * @type {Number}
     */
    var initialHeight = 0;

    /**
     * Handle canvas app event.
     * @param {function(event)?} callback Call after handling canvas app event.
     */
    function handleAppEvent (callback) {
      Sfdc.canvas.parent.subscribe({
        name: PDFFILLER_APPEVENT,
        onData: function (e) {
          if (e.event === 's2s_sent' && typeof e.s2s_id === 'string') {
            e.s2s_id = JSON.parse(e.s2s_id);
          }

          callback instanceof Function && callback(e);
        }
      });
    }

    /**
     * Handle window resize.
     * @param {function} callback Call after window resize.
     */
    function handleWindowResize (callback) {
      // Need to handle resize-end event.
      var resizeId;
      global.addEventListener('resize', function () {
        var DELTA = 200;
        clearTimeout(resizeId);
        resizeId = setTimeout(callback, DELTA);
      });

      // Need to resize canvas after it load(but we don't know when it will be).
      global.addEventListener('load', function () {
        var LIVE_TIME = 10000;
        var DELTA = 500;

        var liveResizeId = setInterval(callback, DELTA);

        setTimeout(function () {
          clearInterval(liveResizeId);
        }, LIVE_TIME);
      });
    }

    /**
     * Resize canvas height.
     * @param {number=} height Canvas height in pixels.
     */
    function resize (height) {
      var pxHeight = (typeof height === 'number' ? height : getHeight()) + 'px';

      needResize && Sfdc.canvas.parent.resize({
        height: pxHeight
      });
    }

    /**
     * Calculate canvas height for current window.
     * @param {Number=} initialValue Initial height.
     * @returns {Number}
     */
    function getHeight (initialValue) {
      var height = typeof initialValue === 'number' ? initialValue : initialHeight;

      height += getWindowHeight();

      if (height < minHeight) {
        height = minHeight;
      }

      return height;
    }

    /**
     * @returns {Number}
     */
    function getWindowHeight () {
      return window.innerHeight
        || document.documentElement.clientHeight
        || document.getElementsByTagName('body')[0].clientHeight;
    }

    /**
     * @constructor
     * @param {Object=} options
     * @param {String=} options.action
     * @param {Number=} options.initialHeight
     * @param {Function=} options.onAppEvent
     * @returns {Object}
     *
     */
    return function (options) {
      options = options || {};

      if (options.action !== 'fill') {
        minHeight = MIN_S2S_L2F_HEIGHT;
      }

      if (typeof options.initialHeight === 'number') {
        initialHeight = options.initialHeight;
      }

      handleAppEvent(function (event) {
        needResize = false;

        var onAppEvent = options.onAppEvent;
        onAppEvent && onAppEvent(event);
      });

      handleWindowResize(resize);

      return {
        getWindowHeight: getWindowHeight
      }
    }
  }();

  global.PDFfiller = global.PDFfiller || {};
  global.PDFfiller.canvas = module;
})(window);
