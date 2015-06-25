$ ->

  jcrop_api = null

  options = null

  update_crop = (coords) ->

    crop = JSON.stringify {
      x: Math.ceil coords.x
      y: Math.ceil coords.y
      w: Math.ceil coords.w
      h: Math.ceil coords.h
    }

    $('#user_crop').val(crop)

    console.log "КООРДИНАТЫ:" + crop



  readURL = (input) ->

    if (input.files && input.files[0])

      reader = new FileReader()

      reader.onload = (e) ->

        image = new Image()
        image.src = e.target.result

        image.onload = () ->

          if this.width < 200 or this.height < 200

            return alert('Размер изображения должен быть не менее 200 * 200 пикселей!')

          $('form .avatar .image-crop').removeClass('hidden')
          $('form .avatar .image-load').addClass('hidden')
          $('form .avatar .image-crop img').attr('src',this.src)


          unless this.width == 200 and this.height == 200

            # Определяем минимальный размер рамки для обрезания
            # с учетом реального размера каринки

            if ( this.width < this.height )
              min_side = this.width
            else
              min_side = this.height

            min_size = min_side / Math.floor(min_side / 200)

            select_size = [0,0,min_side - 50,min_side - 50]

            options = {
              boxWidth: 281,
              minSize: [200,200], # Делим меньший размер картинки на 200 пикселей и поулчаем минимальный размер
              aspectRatio: 1,
              setSelect: select_size
              onRelease: (coords) ->
                jcrop_api.setSelect(select_size)
              onSelect: (coords) ->
                update_crop(coords)
                console.log coords
            }


            console.log $('form .image-crop img').Jcrop(options, ->
              jcrop_api = this
            )



      reader.readAsDataURL(input.files[0])



  if $('form .avatar').length > 0

    $('body').delegate 'form .avatar .cancel', 'click', () ->

      $('form .avatar .image-crop').addClass('hidden')
      $('form .avatar .image-load').removeClass('hidden')

      $('form .avatar input[type=file]').val('')

      $('form .avatar .image-crop img').val('')
      $('form .avatar .image-crop img').attr('style','')

      jcrop_api.destroy()

    $('body').delegate 'form .avatar .remove-avatar', 'click', () ->

      if (confirm("Вы уверены что хотитете удалить аватар?"))

        $('#user_remove_avatar').prop('checked', true)

        $('form .avatar .image-crop').addClass('hidden')
        $('form .avatar .image-load').removeClass('hidden')

        $('form .avatar input[type=file]').val('')

        $('form .avatar .image-crop img').val('')
        $('form .avatar .image-crop img').attr('style','')

        console.log $('#info form').submit()



    $('body').delegate 'form .avatar a.image-load', 'click', () ->

      $('form .avatar input[type=file]').click()

    $('body').on 'change' ,'form .avatar input[type=file]', () ->
      readURL(this)


