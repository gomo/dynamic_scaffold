document.addEventListener('dynamic_scaffold:load', function (){
  const inputs = document.querySelectorAll('.dynamicScaffoldJs-image')
  Array.prototype.forEach.call(inputs, function(input){
    // initialize
    const wrapper = input.closest('.dynamicScaffoldJs-image-wrapper')
    const preview = wrapper.querySelector('.dynamicScaffoldJs-image-preview')
    const img = preview.querySelector('img')

    // init preview display
    preview.style.display = 'inline-block'

    // hide on non image
    if(!img.getAttribute('src')){
      preview.style.display = 'none'
    }

    // delete event
    const button = preview.querySelector('.dynamicScaffoldJs-image-remove')
    const flag = wrapper.querySelector('.dynamicScaffoldJs-image-remove-flag')
    button.addEventListener('click', function(e){
      preview.style.display = 'none'
      flag.disabled = false
      input.value = ''
    })

    // change event
    input.addEventListener('change', function(e){
      const reader = new FileReader();
      reader.onload = function (e) {
        img.src = e.target.result
        preview.style.display = 'inline-block'
        flag.disabled = true
      }

      if(input.files.length){
        reader.readAsDataURL(input.files[0])
      }
    })
  })
})