document.addEventListener('dynamic_scaffold:load', function(){
  function handlePagenation(pagenation){
    const itemCount = pagenation.children.lenth
    const items = Array.prototype.filter.call(pagenation.children, function(li){
      return li.classList.contains('js-page-item')
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
  document.querySelectorAll('.js-pagenation').forEach(function(pagenation){
    handlePagenation(pagenation)
  })
})