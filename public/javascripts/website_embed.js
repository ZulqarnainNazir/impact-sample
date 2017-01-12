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
