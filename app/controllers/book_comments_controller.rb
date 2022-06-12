class BookCommentsController < ApplicationController
  
  def create
    @book_id = Book.find(params[:book_id])
    #book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = @book_id.id
    if @book_comment.save
    redirect_to book_path(@book_id.id),notice: "You have created comment successfully."
    else
      @user = @book_id.user
      @book = Book.new
      #redirect_back(fallback_location: root_path)
      render "books/show"
    end
  end
  
  def destroy
    @book_comment = BookComment.find_by(id: params[:id],book_id: params[:book_id])
    # #book_comment = Book_commnet.find(book_comments.id)
    @book_comment.destroy
    redirect_back(fallback_location: root_path)
    #redirect_to book_path(book.id)
  
    # BookComment.find_by(book_comment_params).destroy
    # redirect_back(fallback_location: root_path)
    # #redirect_to book_path(book.id)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
end
