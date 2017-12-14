//closest
if (window.Element && !Element.prototype.closest) {
  Element.prototype.closest =
  function(s) {
    var matches = (this.document || this.ownerDocument).querySelectorAll(s),
      i,
      el = this;
    do {
      i = matches.length;
      while (--i >= 0 && matches.item(i) !== el) {};
    } while ((i < 0) && (el = el.parentElement));
    return el;
  };
}

(function(){
  var fireEvent = function(){
    var event = document.createEvent("HTMLEvents");
    event.initEvent('dynamic_scaffold:load', false, false)
    document.dispatchEvent(event)
  }

  window.onload = fireEvent
  document.addEventListener('turbolinks:load', fireEvent)
})()