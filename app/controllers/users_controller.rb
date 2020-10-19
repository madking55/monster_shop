class UsersController < ApplicationController 
  before_action :require_user, only: :show

  def show
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to profile_path
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end