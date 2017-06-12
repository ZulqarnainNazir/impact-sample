var ReviewWidget = new function () {
  this.load = function (uuid, site) {
    var head = document.getElementsByTagName('head')[0],
        script = document.createElement('script'),
        widgetDiv = document.getElementById("review-widget-"+uuid),
        iframe = document.createElement('iframe');

    script.src = site+'javascripts/iframeResizer.min.js';    
    if(typeof iFrameResize === "undefined") {
      head.appendChild(script);
    }

    iframe.width = '100%';
    iframe.height = '400px';
    iframe.frameBorder = '0';
    iframe.id = 'impact-reviews-'+uuid;
    iframe.src = site+'widgets/review_widgets/'+uuid
    widgetDiv.appendChild(iframe);
    setTimeout(function() {iFrameResize({log: false}, '#impact-reviews-'+uuid); }, 1000);
  }
}
var ContactFormWidget = new function () {
  this.load = function (uuid, site) {
    var head = document.getElementsByTagName('head')[0],
        script = document.createElement('script'),
        widgetDiv = document.getElementById("contact-form-widget-"+uuid),
        iframe = document.createElement('iframe');

    script.src = site+'javascripts/iframeResizer.min.js';    
    if(typeof iFrameResize === "undefined") {
      head.appendChild(script);
    }

    iframe.width = '100%';
    iframe.height = '400px';
    iframe.frameBorder = '0';
    iframe.id = 'impact-contact-forms-'+uuid;
    iframe.src = site+'widgets/contact_form_widgets/'+uuid
    widgetDiv.appendChild(iframe);
    setTimeout(function() {iFrameResize({log: false}, '#impact-contact-forms-'+uuid); }, 1000);
  }
}
var ContentFeedWidget = new function () {
  this.load = function (uuid, site) {
    window.addEventListener('message', receiveContentFeedMessage, false);
    var head = document.getElementsByTagName('head')[0],
        script = document.createElement('script'),
        widgetDiv = document.getElementById("content-feed-widget-"+uuid),
        iframe = document.createElement('iframe');

    script.src = site+'javascripts/iframeResizer.min.js';    
    if(typeof iFrameResize === "undefined") {
      head.appendChild(script);
    }

    iframe.width = '100%';
    iframe.height = '400px';
    iframe.frameBorder = '0';
    iframe.id = 'impact-content-feed-'+uuid;
    iframe.src = site+'widgets/content_feed_widgets/'+uuid
    widgetDiv.appendChild(iframe);
    setTimeout(function() {iFrameResize({log: false, checkOrigin: false}, '#impact-content-feed-'+uuid); }, 1000);
  }
}
var DirectoryWidget = new function () {
  this.load = function (uuid, site) {
    window.addEventListener('message', receiveDirectoryMessage, false);
    var head = document.getElementsByTagName('head')[0],
        body = document.getElementsByTagName('body')[0],
        script = document.createElement('script'),
        widgetDiv = document.getElementById("directory-widget-"+uuid),
        overlay = document.createElement('div'),
        iframe = document.createElement('iframe');

    script.src = site+'javascripts/iframeResizer.min.js';    
    if(typeof iFrameResize === "undefined") {
      head.appendChild(script);
    }

    iframe.width = '100%';
    iframe.height = '400px';
    iframe.frameBorder = '0';
    iframe.id = 'impact-directory-'+uuid;
    iframe.style.zIndex = 1028;
    iframe.style.position = 'relative';
    iframe.src = site+'widgets/directory_widgets/'+uuid
    widgetDiv.appendChild(iframe);
    overlay.id = 'impact-directory-overlay';
    overlay.style.cssText = 'top: 0; bottom: 0; left: 0; right: 0; background-color: #000000; opacity: .5; position: fixed; display: none; z-index: 1025;';
    body.appendChild(overlay);
    setTimeout(function() {iFrameResize({log: false, minHeight: 400}, '#impact-directory-'+uuid); }, 1000);
  }
}



function receiveDirectoryMessage(evt)
{
  if (evt.data === 'open')
  {
    document.getElementById('impact-directory-overlay').style.display = 'block';
  }
  if (evt.data === 'close')
  {
    document.getElementById('impact-directory-overlay').style.display = 'none';
  }
}

function receiveContentFeedMessage(evt)
{
  if (evt.data.indexOf('scrollup') !== -1)
  {
    window.scrollTo(0, findPos(document.getElementById(evt.data.replace('scrollup', 'impact-content-feed'))));
  }
}


function findPos(obj) {
    var curtop = 0;
    if (obj.offsetParent) {
        do {
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
    return [curtop];
    }
}
