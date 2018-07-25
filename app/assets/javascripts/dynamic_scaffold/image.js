document.addEventListener('dynamic_scaffold:load', function (){
  const inputs = document.querySelectorAll('.js-ds-image')
  Array.prototype.forEach.call(inputs, function(input){
    // initialize
    const wrapper = input.closest('.js-ds-image-wrapper')
    const preview = wrapper.querySelector('.js-ds-image-preview')
    const img = preview.querySelector('img')
    const cropper_input = wrapper.querySelector('.js-ds-image-cropper')

    // init preview display
    preview.style.display = 'inline-block'

    // hide on non image
    if(!img.getAttribute('src')){
      preview.style.display = 'none'
    }

    // delete event
    const button = preview.querySelector('.js-ds-image-remove')
    let flag
    if(button)
    {
      flag = wrapper.querySelector('.js-ds-image-remove-flag')
      button.addEventListener('click', function(e){
        preview.style.display = 'none'
        flag.disabled = false
        input.value = ''
      })
    }

    // change event
    var cropper = undefined
    input.addEventListener('change', function(e){
      const reader = new FileReader();
      reader.onload = function (e) {
        if(cropper) cropper.destroy()
        img.src = e.target.result
        if(cropper_input){
          const options = JSON.parse(cropper_input.getAttribute('data-options'))
          options.crop = function(event){
            cropper_input.value = JSON.stringify(event.detail)
          }
          cropper = new Cropper(img, options)
        }

        preview.style.display = 'inline-block'
        if(flag) flag.disabled = true
      }

      if(input.files.length){
        reader.readAsDataURL(input.files[0])
      }
    })
  })
})