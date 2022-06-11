class BookCommentsController < ApplicationController
  
  def create
    book = Book.find(params[:book_id])
    comment = current_user.post_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_to book_path(params[:id])
  end
  
  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  
  end

  private

  def book_comment_params
    params.require(:book).permit(:comment)
  end
  
end
