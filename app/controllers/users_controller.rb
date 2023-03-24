class UsersController < ApplicationController

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
  end

  def show_current_user
    render current_user, status: :ok
  end

  def update
    if current_user.update(user_params)
      render :show
    else 
      render json: {errors: current_user.errors}, status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.require(:user).permit(
      :google_token,
      :email, 
      :password, 
      :first_name, 
      :last_name
    )
  end

end 