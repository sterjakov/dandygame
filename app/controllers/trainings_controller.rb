class TrainingsController < FrontController




  def pohudet_legko

    @people_count = User.count

    @training = Training.find(8)

    @user = User.new()

    render layout: false

  end




  def index

    # Мои тренинги
    @mytrainings = Mytraining.where(user_id: @current_user[:id]) if @current_user

    @trainings = Training.all.order('weight DESC')
    #@trainings = Training.all.where(status: 1)
  end



  # Следующий тренинг
  def next

    # Тренинг
    @training = Training.find(params[:id])

    @next_training = Training.select(:id).where("weight < #{@training[:weight]}").order('weight DESC').first

    unless @next_training
      @next_training = Training.select(:id).where("weight > #{@training[:weight]}").order('weight DESC').first
    end

    redirect_to training_path(@next_training[:id])

  end



  # Предыдущий тренинг
  def previous

    # Тренинг
    @training = Training.find(params[:id])


    @prev_training = Training.select(:id, :name).where("weight > #{@training[:weight]}").order('weight ASC').first

    unless @prev_training
      @prev_training = Training.select(:id, :name).where("weight < #{@training[:weight]}").order('weight ASC').first
    end

    redirect_to training_path(@prev_training[:id])

  end


  def show


    # Пользователь
    @user = (@current_user) ? @current_user : User.new

    # Тренинг
    @training = Training.find(params[:id])

    # SEO
    @meta_title       = @training.name
    @meta_description = @training.meta_description
    @meta_keywords    = @training.meta_keywords

    # Мои тренинги
    @mytraining = Mytraining.where(user_id: @current_user[:id], training_id: params[:id]).first if @current_user
    @mytraining = Mytraining.new() unless @mytraining

    # Отзывы
    @feedback = Feedback.new
    @feedbacks = @training.feedbacks.order('created_at DESC')

    # Переменные JS
    gon.training_id = params[:id]

  end


end
