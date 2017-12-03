function pageOnLoad(){
  const upButtons = document.querySelectorAll('.js-sorter-up')
  const downButtons = document.querySelectorAll('.js-sorter-down')

  function flash(elem){
    const overlay = document.createElement('div');
    overlay.style.position = 'absolute'
    overlay.style.width = '100%'
    overlay.style.height = elem.offsetHeight + 'px'
    overlay.style.backgroundColor = '#fff677'
    overlay.style.webkitTransition = 'opacity 0.6s ease-out';
    overlay.style.MozTransition = 'opacity 0.6s ease-out';
    overlay.style.msTransition = 'opacity 0.6s ease-out';
    overlay.style.OTransition = 'opacity 0.6s ease-out';
    overlay.style.transition = 'opacity 0.6s ease-out';
    overlay.style.opacity = 0.5
    overlay.addEventListener('transitionend', function(){
      overlay.parentElement.removeChild(overlay)
    })
    elem.insertBefore(overlay, elem.childNodes[0]);
    setTimeout(function(){
      overlay.style.opacity = 0
    }, 0)
  }

  function addSwapEvent(buttons, swapAction){
    buttons.forEach(function(button){
      button.addEventListener('click', function(e){
        const source = button.closest('.js-item-row')
        swapAction(source)
        flash(source)
        return false
      })
    })
  }

  addSwapEvent(upButtons, function(source){
    const target = source.previousElementSibling
    if(target){
      source.parentNode.insertBefore(source, target)
    }
  })

  addSwapEvent(downButtons, function(source){
    const target = source.nextElementSibling
    if(target){
      source.parentNode.insertBefore(target, source)
    }
  })
}

window.onload = pageOnLoad
document.addEventListener('turbolinks:load', pageOnLoad)