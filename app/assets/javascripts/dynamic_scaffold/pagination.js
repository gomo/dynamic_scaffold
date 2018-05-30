document.addEventListener('dynamic_scaffold:load', function(){
  function handlePagination(pagination){
    const itemCount = pagination.children.lenth
    const items = Array.prototype.filter.call(pagination.children, function(li){
      return li.classList.contains('js-ds-page-item')
    })
    
    const currentIndex = items.findIndex(function(li){
      return li.classList.contains('current')
    })

    let distance = currentIndex - items.length + 1
    items.forEach(function(li, index){
      if(
        distance != 0
      ){
        li.classList.add('away-' + Math.abs(distance))
      }
      ++distance
    })
  }

  Array.prototype.forEach.call(document.querySelectorAll('.js-ds-pagination'), function(pagination){
    handlePagination(pagination)
  })
})