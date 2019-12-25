class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  #def require_signin
  #  unless current_user
  #    redirect_to new_session_url, alert: "Please sign in first!"
  #  end
  #end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def edit
    # The require_correct_user is creating a @user local variable ...
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    #@user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to events_url, alert: "Account successfully deleted!"
  end

  private

  def require_correct_user
    @user = User.find(params[:id])
    #unless current_user == @user
    #unless current_user?(@user)
    #  redirect_to events_url
    #end
    redirect_to events_url unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
