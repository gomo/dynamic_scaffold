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

//window onload
if (!window.addOnload) {
  window.addOnload = function(func){
    var last = window.onload;
    window.onload = function(){
      if(last) last();
      func();
    }
  }
}