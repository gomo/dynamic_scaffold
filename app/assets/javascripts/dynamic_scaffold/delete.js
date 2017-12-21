document.addEventListener('dynamic_scaffold:load', function (){
  const buttons = document.querySelectorAll('.dynamicScaffoldJs-destory')
  buttons.forEach(function(button){
    const wrapper = button.closest('.dynamicScaffoldJs-item-row')
    let needsSubmit = false
    button.addEventListener('click', function(e){
      if(!needsSubmit) {
        e.preventDefault()
        const message = button.getAttribute('data-confirm-message')
        wrapper.classList.add('dynamicScaffold-destorying')
        setTimeout(function(){
          if(!confirm(message)){
            wrapper.classList.remove("dynamicScaffold-destorying");
          } else {
            needsSubmit = true
            button.click()
          }
        }, 30)
      }
    })
  })
})