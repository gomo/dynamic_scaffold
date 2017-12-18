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

// promise polyfill
// IE 11 has no Promise? Are you kidding?
// https://github.com/taylorhakes/promise-polyfill
!function(e,n){"object"==typeof exports&&"undefined"!=typeof module?n():"function"==typeof define&&define.amd?define(n):n()}(0,function(){"use strict";function e(){}function n(e,n){for(;3===e._state;)e=e._value;0!==e._state?(e._handled=!0,f._immediateFn(function(){var i=1===e._state?n.onFulfilled:n.onRejected;if(null!==i){var r;try{r=i(e._value)}catch(e){return void o(n.promise,e)}t(n.promise,r)}else(1===e._state?t:o)(n.promise,e._value)})):e._deferreds.push(n)}function t(e,n){try{if(n===e)throw new TypeError("A promise cannot be resolved with itself.");if(n&&("object"==typeof n||"function"==typeof n)){var t=n.then;if(n instanceof f)return e._state=3,e._value=n,void i(e);if("function"==typeof t)return void r(function(e,n){return function(){e.apply(n,arguments)}}(t,n),e)}e._state=1,e._value=n,i(e)}catch(n){o(e,n)}}function o(e,n){e._state=2,e._value=n,i(e)}function i(e){2===e._state&&0===e._deferreds.length&&f._immediateFn(function(){e._handled||f._unhandledRejectionFn(e._value)});for(var t=0,o=e._deferreds.length;o>t;t++)n(e,e._deferreds[t]);e._deferreds=null}function r(e,n){var i=!1;try{e(function(e){i||(i=!0,t(n,e))},function(e){i||(i=!0,o(n,e))})}catch(e){if(i)return;i=!0,o(n,e)}}function f(e){if(!(this instanceof f))throw new TypeError("Promises must be constructed via new");if("function"!=typeof e)throw new TypeError("not a function");this._state=0,this._handled=!1,this._value=void 0,this._deferreds=[],r(e,this)}var u=setTimeout,c=f.prototype;c.catch=function(e){return this.then(null,e)},c.then=function(t,o){var i=new this.constructor(e);return n(this,new function(e,n,t){this.onFulfilled="function"==typeof e?e:null,this.onRejected="function"==typeof n?n:null,this.promise=t}(t,o,i)),i},f.all=function(e){return new f(function(n,t){function o(e,f){try{if(f&&("object"==typeof f||"function"==typeof f)){var u=f.then;if("function"==typeof u)return void u.call(f,function(n){o(e,n)},t)}i[e]=f,0==--r&&n(i)}catch(e){t(e)}}if(!e||void 0===e.length)throw new TypeError("Promise.all accepts an array");var i=Array.prototype.slice.call(e);if(0===i.length)return n([]);for(var r=i.length,f=0;i.length>f;f++)o(f,i[f])})},f.resolve=function(e){return e&&"object"==typeof e&&e.constructor===f?e:new f(function(n){n(e)})},f.reject=function(e){return new f(function(n,t){t(e)})},f.race=function(e){return new f(function(n,t){for(var o=0,i=e.length;i>o;o++)e[o].then(n,t)})},f._immediateFn="function"==typeof setImmediate&&function(e){setImmediate(e)}||function(e){u(e,0)},f._unhandledRejectionFn=function(e){void 0!==console&&console&&console.warn("Possible Unhandled Promise Rejection:",e)};var a=function(){if("undefined"!=typeof self)return self;if("undefined"!=typeof window)return window;if(void 0!==a)return a;throw Error("unable to locate global object")}();a.Promise||(a.Promise=f)});
