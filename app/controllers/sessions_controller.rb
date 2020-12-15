class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      flash[:success] = t ".message_success_login"
      redirect_to user
    else
      flash[:danger] = t ".message"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t ".message_success_logout"
    redirect_to home_path
  end
end
