class Ability
  include CanCan::Ability

  def initialize(user)


    user ||= User.new

    case user.role_is?

      when 'admin'
        can :manage, :all

      when 'user'

        # Покупать
        can :edit, Order

        # Редактировать свои тренинги
        can :edit, Mytraining

        # Редактировать профиль
        can :edit, User

        # Просматривать дни тренинга
        can :read, Day

        # Смотреть меню пользователя
        can :manage, :main_menu

        # Создавать комментарии
        can :create, Comment

        # Редактировать комментарии
        can [:edit], Comment do |comment|

          if comment.user.id == user.id

            !comment.has_children?

          else

            false

          end

        end

        # Удалять комментарии
        can [:delete], Comment do |comment|

          if comment.user.id == user.id

            !comment.has_children? and comment.depth > 0

          else

            false

          end

        end



        # Создавать комментарии к своим собственным комментариям
        can :create_for_own, Comment do |parent_comment|

          # Если id родителя равен id пользователя
          if parent_comment.user.id == user.id

            # Если у родителя есть комментарии
            parent_comment.has_children?

          else

            true

          end

        end


        # Создавать отзывы
        can :create,  Feedback

        # Удалять и редактировать отзывы
        can [:delete, :edit], Feedback do |feedback|

          feedback.user.id == user.id

        end


      when 'guest'

        # Может завершить регистрацию
        can :signup_complete, User

        # Покупать
        can :edit, Order

        # Редактировать свои тренинги
        can :edit, Mytraining

        # Редактировать профиль
        can :edit, User

        # Смотреть меню пользователя
        can :manage, :main_menu

      else
        can :login, User
        can :signup, User

    end



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
