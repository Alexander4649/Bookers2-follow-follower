class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update,:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
    # ログインしているユーザー以外の情報を取得したいので、(id: cuurent_user.id)を記述する人自分以外の情報取得するとなる
    @users = User.where.not(id: current_user.id)
  end
  
  #あるユーザーがフォローしている人全員を取得するアクションが必要
  def followings
    user = User.find(params[:id])
    # あるユーザーに結びついている(ユーザーがフォローしている)人の情報を全て取得する
    # user.rbにてfollowingsの定義をしている為、使用できる記述
    @users = User.followings
  end
  
  #あるユーザーをフォローしている人全員を取得するアクションが必要
  
  def followers
    user = User.find(params[:id])
    # あるユーザーにフォローしている人の情報を全て取得する
    # user.rbにてfollowersの定義をしている為、使用できる記述
    @users = User.followers
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end
end
