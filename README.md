応用課題フェーズ　課題❸ いいね/コメント機能実装

* モデルファイルの作成=>favoriteモデル、イイねしたユーザーIDとイイねされた投稿画像のIDのカラム定義
rails g model Favorite user_id:integer book_id:integer
rails db:migrate =>追加したカラムのマイグレート

* 追加したカラムのアソシエーション設定
=>favoriteモデルに対して、belongs_to :user,:book
=>book・userモデルに対して、has_many :favorite,dependent: :destroy
=>bookモデルに favorited_by?(user) favorites.exists?(user_id:user.id)を記述。

* ルート
resources book ...do resource :fovorite,only: [:create,:destroy] end

* コントローラ=>create、destroyのみ=>showの中に入れるので、Viewは必要なし
=>def create
    @book = Book.find(params[book_id])
    favorite = current_user.favorite.new(book_id:book_id)
    favorite.save
    redirect_to book_path(@book)
  end

=>def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: book.id)
    favorite.destroy
    redirect_to book_path(@book)
  end
  
 * showのViewへイイねボタンを実装
 =><td><% if @book.favorited_by?(current_user)%>
        <p>
          <%= link_to book_favorites_path(@book), method: :delete do %>
          ♥<%= @book.favorites.count %> いいね
          <% end %>
          </p>
          <% else %>
          <p>
          <%= link_to book_favorites_path(@book), method: :post do %>
          ♡<%= @book.favorites.count %> いいね
          <% end %>
          </p>
          <% end %>
         </td>