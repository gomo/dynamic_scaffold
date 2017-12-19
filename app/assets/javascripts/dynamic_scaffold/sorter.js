document.addEventListener('dynamic_scaffold:load', function(){
  // Register the animation end event in all the rows.
  document.querySelectorAll('.js-item-row').forEach(function(row){
    row.addEventListener('transitionend', function(e){
      if(e.target == row) resolvers.shift()()
    })
  })

  function swapAnimation(source, target){
    sourceRect = source.getBoundingClientRect()
    targetRect = target.getBoundingClientRect()
    
    source.style.transition = 'all 200ms ease'
    source.style.transform = 'translateY(' + (targetRect.y - sourceRect.y) + 'px)'
  }

  const promises = []
  const resolvers = []

  function enableSortToButtons(buttons, getTarget, swapElement){
    buttons.forEach(function(button){
      const source = button.closest('.js-item-row')
      button.addEventListener('click', function(e){
        e.preventDefault()
        
        // Ignore while animating
        if(promises.length) return
        if(resolvers.length) return

        // Top or bottom.
        const target = getTarget(source)
        if(!target) return

        // Start animation source to target
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(source, target)
        }))

        // Start animation target to source
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(target, source)
        }))

        // When both animations are finished
        Promise.all(promises).then(function(){
          source.style.transition = 'none'
          source.style.transform = 'translateY(0px)'
          target.style.transition = 'none'
          target.style.transform = 'translateY(0px)'
          swapElement(source, target)
          promises.length = 0
        })
      })
    })
  }

  enableSortToButtons(document.querySelectorAll('.js-sorter-top'), function(source){
    return document.querySelector('.js-item-row:first-child')
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.js-sorter-up'), function(source){
    return source.previousElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.js-sorter-down'), function(source){
    return source.nextElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(target, source)
  })

  enableSortToButtons(document.querySelectorAll('.js-sorter-bottom'), function(source){
    return document.querySelector('.js-item-row:last-child')
  }, function(source, target){
    source.parentNode.insertBefore(target, source)
  })
})
