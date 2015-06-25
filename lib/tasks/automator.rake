namespace :automator do



  desc "Убираем все <b> и проставляем точки в конце списков <li>"

  task :trainings_format => :environment do


    Day.all.each do |day|
    #Day.where(training_id: 4, number: 13).each do |day|


      html_text = Nokogiri::HTML::DocumentFragment.parse(day.description)

      #h2_b_remove html_text
      #li_end_point_add html_text
      #li_double_point_remove html_text

      point_remove html_text

      day.description = html_text.to_s
      day.save

    end



  end





  desc "Убираем все 1-ые картинки у дней"

  task :remove_all_first_day_images => :environment do

    Day.all.each do |day|

      html_text = Nokogiri::HTML::DocumentFragment.parse(day.description)

      html_text.at_css('img:first-child').remove

      #day.description = html_text
      #puts day.save

    end

  end




  desc "У тега h2 удаляем все атрибуты class"

  task :trainings_h2_clean => :environment do

    i = 0

    Day.all.each do |day|

      html_text = Nokogiri::HTML::DocumentFragment.parse(day.description)

      html_text.xpath('@class|.//@class').each do |attr_class|

        if attr_class.parent.name == 'h2'

          attr_class.remove
          attr_class.parent.to_s

          i += 1

        end

      end

      day.description = html_text.to_s
      day.save

    end

    puts "Итого заменено #{i} заголовков"

  end



  desc "Парсим дни всех тренингов которые есть в БД и сохраняем их там же"

  task :trainings_load  => :environment do

    Training.all.each do |training|

      headers = []

      15.times.each do |number|

        number = number

        html_text   = `pandoc "public/trainings/#{training[:alt_name]}/text/День #{number}.docx"`.gsub("em","i").gsub("strong","b")

        html_parsed = parse_day html_text, training[:alt_name], number, headers

        headers = html_parsed[:headers]
        content = html_parsed[:html]

        Day.where(training_id: training[:id], number: number).destroy_all
        Day.create({training_id: training[:id], number: number, description: content })

      end


    end

    puts 'Дни тренингов успешно загружены в БД!'

  end




  desc "Парсим один день"

  task :day_load, [:day_number] => :environment do |day_number,args|


    html_text   = `pandoc "public/trainings/garmoniya-v-otnosheniyah/text/День #{args[:day_number]}.docx"`
    html_parsed = parse_day html_text, 'garmoniya-v-otnosheniyah', args[:day_number]

    puts html_parsed[:html].to_s

  end



  # Парсер тренинг дня
  def parse_day html_text, alt_name, day_number, headers = false


    if html_text.present?

      html_text = html_text.gsub("em","i").gsub("strong","b")
      html_text = Nokogiri::HTML::DocumentFragment.parse(html_text) do |config|

      end


      remove_all_unused(html_text)

      filter_all_p_tags(html_text, headers)

      filter_all_b_tags(html_text)

      filter_all_blockquotes(html_text)

      filter_all_lists(html_text)

      insert_head_images(html_text, alt_name, day_number)


      new_headers = []

      html_text.css("ul:last-child li").each do |li|
        new_headers << li.content
      end

    else

      false

    end



    { html: html_text.to_s, headers: new_headers }

  end


  # Вставляет картинку в начало
  def insert_head_images(html_text, alt_name, day_number)

    html_text.at_css('*:first-child').add_previous_sibling "<img src='/trainings/#{alt_name}/day/#{day_number}-1.jpg'>"

  end

  #Удаляем все ненужные теги и аттрибуты
  def remove_all_unused html_text

    # Удаляем ссылки
    html_text.css('a').each do |a|
      a.remove if a['href'].match('.ru|.com|.net|.org|.biz|.ua|.info')
    end

    # Удаляем всте атрибуты style=""
    html_text.xpath('@style|.//@style').remove


    # Удаляем все теги <img>
    html_text.xpath('.//img').remove


    # Удаляем все лишние <blockquote>
    html_text.css('blockquote').each do |bq|

      if ['li'].include? bq.parent.name

        bq.children.each do |child|
          child.parent = child.parent.parent
        end
        bq.remove

      elsif ['#document-fragment'].include? bq.parent.name

        #bq.add_previous_sibling bq.children
        #bq.remove

      end

    end


    # Избавляемся от всех <b></b> в теге <h2>
    html_text.css('h2').each do |h2|
      if h2.children
        if h2.child.name == 'b'
          h2.content = h2.child.content
        end
      end
    end

  end



  # Фильтруем все теги <p>
  def filter_all_p_tags html_text, headers = false

    html_text.css('p').each do |p|


      # Добавляем класс .centered подзаголовкам типа <p><b></b></p>

      unless ['blockquote','li'].include? p.parent.name

        if p.css('b').length == 1

          p['class'] = 'centered' unless p.to_s.match(/([А-я,\s]+<b>)|(<\/b>[А-я,\s]+)/i)

        end

        # Меняем тег p на h2 если он совпадает с один из заголовков

        if headers

          headers.each do |h|
            if p.content.gsub('?','') == h.gsub('?','')
              p.name = 'h2'

              unless p.content.match(/[?]$/i)
                if h.match(/[?]$/i)
                  p.content = h
                end
              end

            end
          end


        end



      end




      # Центрируем заголовки написанные верхнем регистром
      p['class'] = 'centered' unless p.content.match(/([а-я])+/)



      # Удаляем пустой текст
      p.remove if p.content == ''



      # Удаляем заголовок с номером дня
      p.remove if p.content.match(/^ДЕНЬ [0-9]{1,2}$/i)



      # Заголовок - Задания на сегодня
      if p.content.match(/^Практик((а)|(а:)|(а :)|(а: ))$/i)

        p.name = 'h2'
        p.content = 'Задания на сегодня'
        p['class'] = 'centered'

        # Создаём div контейнер для заданий
        p.add_previous_sibling "<div class='tasks'></div>"

      end



      # Заголовок - Что будет завтра
      if p.content.match(/^Что будет завтр((а:)|(а)|(а\?)|(а \?)|(а :)|(а: ))$/i)

        p.name = 'h2'
        p.content = 'Что будет завтра?'
        p['class'] = 'centered'

      end


    end


    # Перемещаем необходимый контент в <div class='tasks'></div>
    tasks_div         = html_text.at_css('.tasks')
    tasks_start       = false

    content_for_tasks = html_text.xpath('./*').select do |node|

      tasks_start = true if node.content == 'Задания на сегодня'
      tasks_start = false if node.content == 'Что будет завтра?'

      node.parent = tasks_div if tasks_start


    end



  end



  # Фильтруем все теги <b>
  def filter_all_b_tags html_text

    html_text.css('b').each do |b|

      # Что будет завтра
      if b.content.match(/^Что будет завтр((а:)|(а)|(а :)|(а: ))$/i)

        b.name = 'h2'
        b.content = 'Что будет завтра?'
        b['class'] = 'centered'

      end

    end

  end




  # Фильтруем все списки <ul> и <ol>
  def filter_all_lists html_text



    # Превращаем <p>1. ... </p> в нумерованный список
    html_text.css('p').each do |p|


      if p.previous


        if p.content.match(/^[0-9]{1,3}/) and p.previous.content.match(/^[0-9]{1,3}/)

          p.previous.add_previous_sibling '<ol></ol>'
          p.previous.name = 'li'
          p.previous.parent = p.previous.previous


          unless p.next
            p.add_previous_sibling '<ol></ol>'
            p.name = 'li'
            p.parent = p.previous.previous
          end

        end

      end

    end


    html_text.css('ol > li').each do |li|

      li.content = li.content.gsub(/^[.0-9 ]{1,3}/, '') if li.content.match(/^[0-9]{1,3}/)

    end



    # Склеиваем рядом стоящие списки ul
    html_text.css('ul').each do |ul|


      if ul.previous

        ul.previous.remove if ul.previous.name == 'text'

        if ul.previous.name == 'ul'

          ul.css('li').each do |li|
            li.parent = ul.previous
          end

          ul.remove

        end

      end

    end



    # Перемещаем списки ul внутрь списков ol если они стоят рядом
    html_text.css('ol').each do |ol|

      if ol.next and ol.next.name == 'ul'
        ol.next.parent = ol.at_css('li:last-child')
      end

    end




    # Склеиваем рядом стоящие списки ol
    html_text.css('ol').each do |ol|


      if ol.previous

        ol.previous.remove if ol.previous.name == 'text'


        if ol.previous.name == 'ol'

          ol.css('li').each do |li|
            li.parent = ol.previous
          end

          ol.remove

        end

      end

    end


  end



  # Фильтруем все теги <blockquote>
  def filter_all_blockquotes html_text

    # Превращаем начальные теги <p><i></i></p> в цитаты
    unless html_text.at_css('blockquote')

      html_text.at_css('p:first-child').add_previous_sibling "<blockquote></blockquote>"

      html_text.css('p').each do |p|

        if p.css('i').length == 1

          if p.to_s.match(/([А-я,\s]+<i>)|(<\/i>[А-я,\s]+)/i)
            break
          else
            p.parent = html_text.at_css('blockquote')
          end

        end


      end

    end



    # Выделяем автора цитат

    if html_text.at_css('blockquote:first-child')

      if html_text.css('blockquote:first-child p').length > 1
        html_text.at_css('blockquote:first-child p:last-child').name = 'b'
        html_text.css('blockquote:first-child b:last-child').wrap('<p></p>')
      else
        if html_text.at_css('blockquote:first-child p:last-child')
          html_text.at_css('blockquote:first-child p:last-child').add_next_sibling("<p><b><i>Неизвестный автор</i></b></p>")
        end

      end
    end


  end


  # Удалям теги b из заголвоков h2

  def h2_b_remove html_text

    html_text.css('h2 b').each do |b|
      b.parent.content = b.content
      b.remove
    end

  end


  # Удаляем точку из конца каждого списка li

  def li_end_point_add html_text

    html_text.css('li').each do |li|
      unless li.content.match(/[.]$/)
        li.content = li.content + '.'
      end
    end

  end


  # Удаляем ". ." двойные точки

  def li_double_point_remove html_text

    html_text.css('li').each do |li|

      if li.content.match(/\.[\s]+\.$/)
        li.content = li.content.gsub(/\.[\s]+\.$/, '.')
      end

    end

  end


  # Удаляем точку после "?|!|:" знаков

  def point_remove html_text

    html_text.css('li').each do |li|

      if li.content.match(/\?[\s]*\.$/)
        li.content = li.content.gsub(/\?[\s]*\.$/, '?')
      end

      if li.content.match(/[!][\s]*\.$/)
        li.content = li.content.gsub(/[!][\s]*\.$/, '!')
      end

    end

    html_text.css('p').each do |p|

      if p.content.match(/[:][\s]*\./)
        puts p.content = p.content.gsub(/[:][\s]*\./, ':')
      end

    end

  end




end

