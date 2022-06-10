class BooksController < ApplicationController
  before_action :ensure_correct_book, only: [:update,:edit]

  def show
    @book = Book.new
    @book_id = Book.find(params[:id])
    @user = @book_id.user
  end

  def index
    @book = Book.new
    @user = User.find(current_user.id)
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = User.find(current_user.id)
    @books = Book.all
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end
  
   def ensure_correct_book
     @book = Book.find(params[:id])
     @user = @book.user
   if
      @user != current_user
      redirect_to books_path
   end
   end
end
