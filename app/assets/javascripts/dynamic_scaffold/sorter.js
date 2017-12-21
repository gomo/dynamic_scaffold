document.addEventListener('dynamic_scaffold:load', function(){
  // Register the animation end event in all the rows.
  document.querySelectorAll('.dynamicScaffoldJs-item-row').forEach(function(row){
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

  function enableSortToButtons(buttons, needsTargetAnimation, getTarget, swapElement){
    buttons.forEach(function(button){
      button.addEventListener('click', function(e){
        e.preventDefault()
        
        // Ignore while animating
        if(promises.length) return
        if(resolvers.length) return

        const source = button.closest('.dynamicScaffoldJs-item-row')

        // Top or bottom.
        const target = getTarget(source)
        if(!target) return

        // Start animation source to target
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(source, target)
        }))

        if(needsTargetAnimation){
          // Start animation target to source
          promises.push(new Promise(function(resolve){
            resolvers.push(resolve)
            swapAnimation(target, source)
          }))
        }

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

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-top'), false, function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:first-child')
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-up'), true, function(source){
    return source.previousElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-down'), true, function(source){
    return source.nextElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(target, source)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-bottom'), false, function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:last-child')
  }, function(source, target){
    source.parentNode.insertBefore(source, null)
  })
})
