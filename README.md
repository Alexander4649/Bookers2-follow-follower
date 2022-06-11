応用課題フェーズ　課題❸ いいね/コメント機能実装

〜〜いいね機能〜〜
* モデルファイルの作成=>favoriteモデル、イイねしたユーザーIDとイイねされた投稿画像のIDのカラム定義
rails g model Favorite user_id:integer book_id:integer
rails db:migrate =>追加したカラムのマイグレート

* 追加したカラムのアソシエーション設定(user:favorite=1:N , book:favorite=1:N)
=>favoriteモデルに対して、belongs_to :user,:book
=>book・userモデルに対して、has_many :favorite,dependent: :destroy
=>bookモデルに favorited_by?(user) favorites.exists?(user_id:user.id)を記述。

* ルート
resource :favorites,only: [:create,:destroy]

* コントローラ=>create、destroyのみ=>showの中に入れるので、Viewは必要なし
def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id:@book.id)
    favorite.save
    redirect_to books_path
  end
  
  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id:@book.id)
    favorite.destroy
    redirect_to books_path
  end
  
 * showのViewへイイねボタンを実装
<td><% if book.favorited_by?(current_user)%>
          <%= link_to book_favorites_path(book.id), method: :delete do %>
          ♥<%= book.favorites.count %>
          <% end %>
          <% else %>
          <%= link_to book_favorites_path(book.id), method: :post do %>
          ♡<%= book.favorites.count %>
          <% end %>
        <% end %>
</td>

〜〜コメント機能〜〜
* モデルの作成
=>rails g model BookComment comment:text user_id:integer book_id:integer
=>rails db:migrate =>追加したカラムのマイグレート

* モデルにアソシエーションを設定(user:bookcomment=1:N , book:bookcomment=1:N)
=>commentモデルに対して、belongs_to :user,:book
=>user,bookモデルに対して、has_many :comments,dependent: :destroy

* コントローラを作成する
=> rails g controller book_comments

* ルーティング設定
=>resource :comments,only: [:create,:destroy]