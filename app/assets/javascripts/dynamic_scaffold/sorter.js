document.addEventListener('dynamic_scaffold:load', function(){
  const promises = []

  function swapAnimation(promises, source, target){
    promises.push(new Promise(function(resolve){
      source.sorting_animation_resolver = resolve
      sourceRect = source.getBoundingClientRect()
      targetRect = target.getBoundingClientRect()
      
      source.style.transition = 'all 200ms ease'
      source.style.transform = 'translateY(' + (targetRect.top - sourceRect.top) + 'px)'      
    }))
  }

  /**
   *
   * @param NodeList button elements.
   * @param Function Function that returns the element to move to.
   * @param Function Function to register animation other than the source element.
   * @param Function Function for swapping elements.
   */
  function addClickEvent(buttons, getTarget, otherSideAnimation, swapElement){
    Array.prototype.forEach.call(buttons, function(button){
      button.addEventListener('click', function(e){
        e.preventDefault()
        
        // Ignore while animating
        if(promises.length) return

        const source = button.closest('.dynamicScaffoldJs-item-row')
        source.style.position = 'relative'
        source.style.zIndex = 1000

        // Top or bottom.
        const target = getTarget(source)
        if(!target) return

        // Start animation source to target
        if(source != target){
          swapAnimation(promises, source, target)
        }
        
        otherSideAnimation(promises, source, target)

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

  function otherSideAnimationForUp(promises, source, target){
    while(true){
      if(target == source) break
      swapAnimation(promises, target, target.nextElementSibling)
      target = target.nextElementSibling
    }
  }

  function otherSideAnimationForDown(promises, source, target){
    while(true){
      if(target == source) break
      swapAnimation(promises, target, target.previousElementSibling)
      target = target.previousElementSibling
    }
  }

  // Register `transitionend` event in all the rows.
  Array.prototype.forEach.call(document.querySelectorAll('.dynamicScaffoldJs-item-row'), function(row){
    row.addEventListener('transitionend', function(e){
      if(e.target == row) row.sorting_animation_resolver(row)
    })
  })

  // Register events on each button.
  addClickEvent(document.querySelectorAll('.dynamicScaffoldJs-sorter-top'), function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:first-child')
  }, otherSideAnimationForUp, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  addClickEvent(document.querySelectorAll('.dynamicScaffoldJs-sorter-up'), function(source){
    return source.previousElementSibling
  }, otherSideAnimationForUp, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  addClickEvent(document.querySelectorAll('.dynamicScaffoldJs-sorter-down'), function(source){
    return source.nextElementSibling
  }, otherSideAnimationForDown, function(source, target){
    source.parentNode.insertBefore(target, source)
  })

  addClickEvent(document.querySelectorAll('.dynamicScaffoldJs-sorter-bottom'), function(source){
    return document.querySelector('.dynamicScaffoldJs-item-row:last-child')
  }, otherSideAnimationForDown, function(source, target){
    source.parentNode.insertBefore(source, null)
  })
})
