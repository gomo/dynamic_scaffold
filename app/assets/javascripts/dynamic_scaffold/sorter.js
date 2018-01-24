document.addEventListener('dynamic_scaffold:load', function(){
  const promises = []
  const resolvers = []
  // Register the animation end event in all the rows.
  Array.prototype.forEach.call(document.querySelectorAll('.dynamicScaffoldJs-item-row'), function(row){
    row.addEventListener('transitionend', function(e){
      if(e.target == row) resolvers.shift()(row)
    })
  })

  function swapAnimation(source, target){
    sourceRect = source.getBoundingClientRect()
    targetRect = target.getBoundingClientRect()
    
    source.style.transition = 'all 200ms ease'
    source.style.transform = 'translateY(' + (targetRect.top - sourceRect.top) + 'px)'
  }

  function enableSortToButtons(buttons, otherSideAnimation, getTarget, swapElement){
    Array.prototype.forEach.call(buttons, function(button){
      button.addEventListener('click', function(e){
        e.preventDefault()
        
        // Ignore while animating
        if(promises.length) return
        if(resolvers.length) return

        const source = button.closest('.dynamicScaffoldJs-item-row')
        source.style.position = 'relative'
        source.style.zIndex = 1000

        // Top or bottom.
        const target = getTarget(source)
        if(!target) return

        // Start animation source to target
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(source, target)
        }))

        otherSideAnimation(promises, resolvers, source, target)

        // When both animations are finished
        Promise.all(promises).then(function(values){
          source.style.zIndex = ''
          source.style.position = ''
          values.forEach(function(row){
            row.style.transition = 'none'
            row.style.transform = 'translateY(0px)'
          })
          swapElement(source, target)
          promises.length = 0
        })
      })
    })
  }

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-top'), function(promises, resolvers, source, target){
    do {
      if(target.nextElementSibling){
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(target, target.nextElementSibling)
        }))
      }
      target = target.nextElementSibling
      if(target == source) break
    } while(target.nextElementSibling)
  }, function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:first-child')
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-up'), function(promises, resolvers, source, target){
    promises.push(new Promise(function(resolve){
      resolvers.push(resolve)
      swapAnimation(target, source)
    }))
  }, function(source){
    return source.previousElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-down'), function(promises, resolvers, source, target){
    promises.push(new Promise(function(resolve){
      resolvers.push(resolve)
      swapAnimation(target, source)
    }))
  }, function(source){
    return source.nextElementSibling
  }, function(source, target){
    source.parentNode.insertBefore(target, source)
  })

  enableSortToButtons(document.querySelectorAll('.dynamicScaffoldJs-sorter-bottom'), function(promises, resolvers, source, target){
    do {
      if(target.previousElementSibling){
        promises.push(new Promise(function(resolve){
          resolvers.push(resolve)
          swapAnimation(target, target.previousElementSibling)
        }))
      }

      target = target.previousElementSibling
      if(target == source) break
    } while(target.previousElementSibling)
  }, function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:last-child')
  }, function(source, target){
    source.parentNode.insertBefore(source, null)
  })
})
