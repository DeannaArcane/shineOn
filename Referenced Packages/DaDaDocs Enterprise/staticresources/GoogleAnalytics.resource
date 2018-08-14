(function (i, s, o, g, r, a, m) {
    i['GoogleAnalyticsObject'] = r;
    i[r] = i[r] || function () {
        (i[r].q = i[r].q || []).push(arguments)
    }, i[r].l = 1 * new Date();
    a = s.createElement(o),
        m = s.getElementsByTagName(o)[0];
    a.async = 1;
    a.src = g;
    m.parentNode.insertBefore(a, m)
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

ga('create', 'UA-1644202-21', 'auto');
ga('send', 'pageview');

ga('create', 'UA-1644202-1', 'auto', 'generalAnalytics', {
    'cookieDomain': 'pdffiller.com',
    'userId': '83115174'
});

var ga_host = document.location.hostname.split('.');
if (typeof ga_host[0] != 'undefined') {
    ga('generalAnalytics.set', 'dimension3', ga_host[0]);
}

ga('generalAnalytics.send', 'pageview');