class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    # Putting user checks to see if it exists prior to authenticating.  Short circuits to prevent error.
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email/password combination!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to events_url, notice: "You're now signed out!"
  end

end
