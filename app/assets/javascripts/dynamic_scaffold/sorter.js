function pageOnLoad(){
  const upButtons = document.querySelectorAll('.js-sorter-up')
  const downButtons = document.querySelectorAll('.js-sorter-down')

  function addSwapEvent(buttons, swapAction){
    buttons.forEach(function(button){
      button.addEventListener('click', function(e){
        const source = button.closest('.js-item-row')
        swapAction(source)
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