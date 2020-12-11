class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".message"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".message_success"
      redirect_to @user
    else
      flash[:danger] = t ".message_danger"
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit User::USER_PERMIT
    end
end
