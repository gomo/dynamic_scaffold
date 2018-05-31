document.addEventListener('dynamic_scaffold:load', function (){
  const csrfParam = document.querySelector('.authenticity_param_name')
  if(!csrfParam) return
  const csrfParamName = csrfParam.value
  function submit(button){
    const form = DynamicScaffold.createElement('form', {
      method: 'post',
      action: button.getAttribute('data-action'),
      style: 'display: none;'
    })

    form.appendChild(DynamicScaffold.createElement('input', {
      type: 'hidden',
      name: csrfParamName,
      value: document.querySelector('input[name=' + csrfParamName + ']').value
    }))

    form.appendChild(DynamicScaffold.createElement('input', {
      type: 'hidden',
      name: '_method',
      value: 'delete'
    }))

    document.body.appendChild(form)

    form.submit()
  }

  const buttons = document.querySelectorAll('.js-ds-destory')
  if(buttons.length === 0) return
  
  const wrapper = buttons[0].closest('.js-ds-item-wrapper')
  Array.prototype.forEach.call(buttons, function(button){
    const row = button.closest('.js-ds-list-row')
    button.addEventListener('click', function(e){
      e.preventDefault()
      row.classList.add('ds-destorying')
      DynamicScaffold.confirm({
        message: button.getAttribute('data-confirm-message'),
        ok: {
          text: wrapper.getAttribute('data-confirm-ok'),
          class: wrapper.getAttribute('data-confirm-ok-class'),
          action: function(){
            submit(button)
          }
        },
        cancel: {
          text: wrapper.getAttribute('data-confirm-cancel'),
          class: wrapper.getAttribute('data-confirm-cancel-class'),
          action: function(){
            row.classList.remove("ds-destorying")
          }
        }
      })
    })
  })
})