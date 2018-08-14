function redirect(url){
      window.location.href = url;
}

function reloadPage(){
   location.reload();
}

function detectIE() {
  var ua = window.navigator.userAgent;

  // Test values; Uncomment to check result …

  // IE 10
  // ua = 'Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0)';

  // IE 11
  // ua = 'Mozilla/5.0 (Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko';

  // Edge 12 (Spartan)
  // ua = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36 Edge/12.0';

  // Edge 13
  // ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586';

  var msie = ua.indexOf('MSIE ');
  if (msie > 0) {
    // IE 10 or older => return version number
    return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
  }

  var trident = ua.indexOf('Trident/');
  if (trident > 0) {
    // IE 11 => return version number
    var rv = ua.indexOf('rv:');
    return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
  }

  // other browser
  return false;
}

function Alert() {
    this.selectors = {
        ALERT_ICON_CLASS: '.dadadocs-alert__icon',
        ICON_MOD: 'dadadocs-alert__icon_',
        ALERT_TITLE_CLASS: '.dadadocs-alert__title',
        TITLE_MOD: 'dadadocs-alert__title_',
        ALERT_DESCRIPTION_CLASS: '.dadadocs-alert__description',
        ALERT_WRAPPER: '.dadadocs-alert-wrapper',
        ALERT_WRAPPER_ACTIVE: 'dadadocs-alert-wrapper_active'
    };
    this.alertContainer;
    this.timeoutId;
}

Alert.prototype.add = function (type, title, message, timeout) {
    this.alertContainer = document.querySelector(this.selectors.ALERT_WRAPPER);

    if(this.alertContainer) {
        var alertIcon = this.alertContainer.querySelector(this.selectors.ALERT_ICON_CLASS);
        var alertTitle = this.alertContainer.querySelector(this.selectors.ALERT_TITLE_CLASS);
        var alertDescription = this.alertContainer.querySelector(this.selectors.ALERT_DESCRIPTION_CLASS)

        if (type && typeof type === 'string') {
            alertIcon.classList.add(this.selectors.ICON_MOD + type);
            alertTitle.classList.add(this.selectors.TITLE_MOD + type);
        } else {
            alertIcon.classList.add(this.selectors.ICON_MOD + 'error');
            alertTitle.classList.add(this.selectors.TITLE_MOD + 'error');
            console.log('Type is not valid.');
        }

        if (title && typeof title === 'string') {
            alertTitle.innerHTML = title;
        } else {
            alertTitle.innerHTML = 'Error';
            console.log('Title is not valid.');
        }

        if (message && typeof message === 'string') {
            alertDescription.innerHTML = message;
        } else {
            alertDescription.innerHTML = 'Something went wrong';
            console.log('Message is not valid.');
        }

        this.alertContainer.classList.add(this.selectors.ALERT_WRAPPER_ACTIVE);
        if (typeof timeout == "undefined") {
            timeout = 5000;
        }
        if(timeout) {
            this.removeByTimeout(timeout, type);
        }
    }
}

Alert.prototype.remove = function (type) {
    var alertIcon = this.alertContainer.querySelector(this.selectors.ALERT_ICON_CLASS);
    var alertTitle = this.alertContainer.querySelector(this.selectors.ALERT_TITLE_CLASS);

    this.alertContainer.classList.remove(this.ALERT_WRAPPER_ACTIVE);

    if (type && typeof type === 'string') {
        alertIcon.classList.remove(this.selectors.ICON_MOD + type);
        alertTitle.classList.remove(this.selectors.TITLE_MOD + type);
    } else {
        alertIcon.classList.remove(this.selectors.ICON_MOD + 'error');
        alertTitle.classList.remove(this.selectors.TITLE_MOD + 'error');
        console.log('Type is not valid.');
    }
}

Alert.prototype.removeByTimeout = function (timeout, type) {
    this.timeoutId = setTimeout(this.remove(type), timeout);
}

var sfAlert = new Alert();
