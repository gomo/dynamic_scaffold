document.addEventListener('dynamic_scaffold:load', function(){
  const upButtons = document.querySelectorAll('.js-sorter-up')
  const downButtons = document.querySelectorAll('.js-sorter-down')

  function flash(elem){
    const overlay = document.createElement('div');
    overlay.style.position = 'absolute'
    overlay.style.width = '100%'
    overlay.style.height = elem.offsetHeight + 'px'
    overlay.style.backgroundColor = '#fff34f'
    overlay.style.webkitTransition = 'opacity 1s ease-out';
    overlay.style.MozTransition = 'opacity 1s ease-out';
    overlay.style.msTransition = 'opacity 1s ease-out';
    overlay.style.OTransition = 'opacity 1s ease-out';
    overlay.style.transition = 'opacity 1s ease-out';
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
      const source = button.closest('.js-item-row')
      button.addEventListener('click', function(e){
        e.preventDefault()
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
})
