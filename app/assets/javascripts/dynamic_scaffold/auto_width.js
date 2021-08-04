var calcWidth = function(){
  var firstRow = document.querySelector('.js-ds-list-row:first-child')
  if(!firstRow){
    return
  }

  var wrapperWidth = firstRow.clientWidth

  var autoWidthItemIndexes = Array.prototype.filter.call(firstRow.querySelectorAll('.js-ds-list-item'), function(item){
    return item.classList.contains('ds-auto-width')
  }).map(function(item){
    return parseInt(item.getAttribute('data-index'), 10)
  })

  autoWidthItemIndexes.forEach(function(index){
    var items = document.querySelectorAll('.js-ds-list-item[data-index="' + index + '"]')

    Array.prototype.forEach.call(items, function(item){
      item.style.width = 'auto' 
    })
    
    var maxWidth = Array.prototype.reduce.call(items, function(currentMax, item){
      return Math.max(currentMax, item.offsetWidth)
    }, 0)

    maxWidth = Math.min(maxWidth, wrapperWidth)

    Array.prototype.forEach.call(items, function(item){
      item.style.width = maxWidth + 'px' 
    })
  })
}

document.addEventListener('dynamic_scaffold:load', calcWidth)
document.addEventListener('dynamic_scaffold:window_resized', calcWidth)