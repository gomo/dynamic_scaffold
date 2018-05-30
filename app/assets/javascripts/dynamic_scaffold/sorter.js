document.addEventListener('dynamic_scaffold:load', function(){
  const promises = []
  const allButtons = []

  function swapAnimation(promises, source, target){
    promises.push(new Promise(function(resolve){
      source.dynamicScaffoldSortingResolver = resolve
      sourceRect = source.getBoundingClientRect()
      targetRect = target.getBoundingClientRect()


      // Find the distance between two points and calculate the animation duration.
      const durationBase = 200
      const distance = Math.sqrt(
        Math.pow(targetRect.left - sourceRect.left, 2 ) + Math.pow( targetRect.top - sourceRect.top, 2 )
      )
      const durationFactor = Math.abs(distance) * 0.03
      const duration = Math.min(durationBase + durationFactor, 600)
      source.style.transition = 'all ' + duration + 'ms cubic-bezier(1.0, 0, 0.25, 1.0)'

      //Calculate the duration according to the moving distance.
      const y = targetRect.top - sourceRect.top
      const x = targetRect.left - sourceRect.left
      source.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
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
      allButtons.push(button)
      button.addEventListener('click', function(e){
        e.preventDefault()
        
        // Ignore while animating
        if(promises.length) return

        const source = button.closest('.js-ds-list-row')
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

        if(promises.length){
          allButtons.forEach(function(btn){ btn.disabled = true })
        }

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
          allButtons.forEach(function(btn){ btn.disabled = false })
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
  Array.prototype.forEach.call(document.querySelectorAll('.js-ds-list-row'), function(row){
    row.addEventListener('transitionend', function(e){
      if(e.target == row) row.dynamicScaffoldSortingResolver(row)
    })
  })

  // Register events on each button.
  addClickEvent(document.querySelectorAll('.js-ds-sorter-top'), function(source){
    return document.querySelector('.js-ds-list-row:first-child')
  }, otherSideAnimationForUp, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  addClickEvent(document.querySelectorAll('.js-ds-sorter-up'), function(source){
    return source.previousElementSibling
  }, otherSideAnimationForUp, function(source, target){
    source.parentNode.insertBefore(source, target)
  })

  addClickEvent(document.querySelectorAll('.js-ds-sorter-down'), function(source){
    return source.nextElementSibling
  }, otherSideAnimationForDown, function(source, target){
    source.parentNode.insertBefore(target, source)
  })

  addClickEvent(document.querySelectorAll('.js-ds-sorter-bottom'), function(source){
    return document.querySelector('.js-ds-list-row:last-child')
  }, otherSideAnimationForDown, function(source, target){
    source.parentNode.insertBefore(source, null)
  })
})
