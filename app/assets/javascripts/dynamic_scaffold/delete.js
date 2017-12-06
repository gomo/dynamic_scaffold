function pageOnLoad(){
  const buttons = document.querySelectorAll('.js-destory')
  buttons.forEach(function(button){
    const wrapper = button.closest('.js-item-row')
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
}

window.addOnload(pageOnLoad)
document.addEventListener('turbolinks:load', pageOnLoad)