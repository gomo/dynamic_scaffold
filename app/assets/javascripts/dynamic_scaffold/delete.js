document.addEventListener('dynamic_scaffold:load', function (){
  function createElement(tagName, attributes){
    const elem = document.createElement(tagName)
    for(var key in attributes){
      elem.setAttribute(key, attributes[key])
    }
  
    return elem
  }

  const csrfParamName = document.querySelector('.authenticity_param_name').value
  function submit(button){
    const form = createElement('form', {
      method: 'post',
      action: button.getAttribute('data-action'),
      style: 'display: none;'
    })

    form.appendChild(createElement('input', {
      type: 'hidden',
      name: csrfParamName,
      value: document.querySelector('input[name=' + csrfParamName + ']').value
    }))

    form.appendChild(createElement('input', {
      type: 'hidden',
      name: '_method',
      value: 'delete'
    }))

    document.body.append(form)

    form.submit()
  }



  const buttons = document.querySelectorAll('.dynamicScaffoldJs-destory')
  buttons.forEach(function(button){
    const wrapper = button.closest('.dynamicScaffoldJs-item-row')
    let needsSubmit = false
    button.addEventListener('click', function(e){
      e.preventDefault()
      
      if(!needsSubmit) {
        e.preventDefault()
        const message = button.getAttribute('data-confirm-message')
        wrapper.classList.add('dynamicScaffold-destorying')
        setTimeout(function(){
          if(!confirm(message)){
            wrapper.classList.remove("dynamicScaffold-destorying");
          } else {
            needsSubmit = true
            submit(button)
          }
        }, 30)
      }
    })
  })
})