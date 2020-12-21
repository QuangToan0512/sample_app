class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(edit update correct_user destroy )
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.paginate.number_of_page
  end

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

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".message_success"
      redirect_to @user
    else
      flash[:danger] = t ".message_danger"
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".message_success"
    else
      flash[:danger] = t ".message_danger"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.logged_in_user.message_danger"
    redirect_to login_url
  end



  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user
    @user = User.find params[:id]
    return if @user
    flash[:danger] = t "signup.message.login"
    redirect_to @user
  end

end
