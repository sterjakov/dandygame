class DaysController < FrontController

  def show

    # День
    @day      = Day.where(training_id: params[:training_id], number: params[:id]).first

    authorize! :read, @day

    # Тренинг
    @training = Training.find(params[:training_id])


    # SEO
    @meta_title       = @training.name
    @meta_description = @training.meta_description
    @meta_keywords    = @training.meta_keywords

    # Мои тренинги
    @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: params[:training_id]).first if @current_user
    @mytraining = Mytraining.new() unless @mytraining


    # Переменные JS
    gon.training_id = params[:training_id]
    gon.day_id      = params[:id]


    # Если номер запрашиваемого дня входит в диапазон допустимых значений дней
    if params[:id].to_i > 0 and (1..@training.day_count).include? params[:id].to_i


      # SEO
      @meta_title += ": день #{params[:id]}"


      # Если этот тренинг добавлен и день уже был активирован
      if @mytraining.added? and params[:id].to_i <= @mytraining.day_number

        if !@mytraining.activation_date_expired? and @mytraining.day_number == params[:id].to_i

          @day.name = @mytraining.nominative_human_current_day_number + ' день активирован'
          @teaser = 'activated-day.jpg'
          render :activated

        else

          # Комментарии
          @comment  = Comment.new()
          @comments = @day.comments.arrange(order: 'created_at DESC')

          # Отзыв к поледнему дню
          @feedback = Feedback.new if @training.day_count == @day.number

          render :show

        end


      # Если тренинг еще не был добавлен
      else

        @day.name = "#{params[:id]}#{@mytraining.nominative_human_number_ending(params[:id])} день закрыт"
        @teaser = 'locked-day.jpg'


        render :locked

      end



    else

      raise ActionController::RoutingError.new('Not Found')

    end



  end



end
