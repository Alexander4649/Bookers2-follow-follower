応用課題フェーズ　課題❹ フォロー/フォロワー機能実装



* コントローラ
relationshipsコントローラを追加
createアクションを追加
　用途：フォローを作成
destroyアクションを追加
　用途：フォローを削除
フォローする・外すボタンをクリックしたら元画面に遷移すること

=> rails g controller relationshps


* モデル
relationshipモデルを作成
follower_id:integer: フォローするユーザのid
followed_id:integer: フォローされるユーザのid

=> rails g model Relationship follower_id:integer followed_id:integer

* フォロー機能ではユーザー同士を結ぶ
* ユーザーは自分自身をフォローできない
* 複数のユーザーにフォローでき、複数のユーザーにフォローされる(多：多の関係)
* フォロー機能の実現には、「誰が誰をフォローしているのか」「誰が誰にフォローされているか」の情報を保持すればよい
* 多：多を解消する為に、中間テーブルが必要になる。これを使用し、「1:多」に置き換えることができる
* 中間テーブルを設けても前後の情報は変わらない
* フォローする側、フォローされる側両方からのアソシエーションが必要になる。=>リレーションシップに対して

 <モデル記述ヒント>

app/models/relationship.rb
  
  belongs_to :follower, class_name: "User"
  
  
  app/models/user.rb
  
  # foreign_key（FK）には、@user.とした際に「@user.idがfollower_idなのかfollowed_idなのか」を指定します。
  has_many :xxx, class_name: "モデル名", foreign_key: "○○_id", dependent: :destroy
  # @user.booksのように、@user.yyyで、
  # そのユーザがフォローしている人orフォローされている人の一覧を出したい
  has_many :yyy, through: :xxx, source: :zzz

* ルート
=>userモデルにネスト
resources :relationships,only: [:create,:destroy] =>URLがusers/id/relationship/id
となるのでresourcesにする

* ビュー

user/show

<サイドバーにフォロー数・フォロワー数を表示 >
=>users/show
フォロー数・フォロワー数はコメント機能と同様の手順(count up)

<マイページ以外のサイドバーにフォローする・外すボタンを追加>
=>user/show
edit、destroy機能にて実装したcuurent_userかどうかを調べる実装を加える
フォローするボタンは遷移先をどう設定するのか調べる。
クリック後、フォローを外すボタンに切り替えないといけない
フォロー外すボタンも同様に


<ユーザー一覧画面にフォロー数・フォロワー数・フォローする・外すボタンの設置>
=>user/index
コメント・イイね機能の実装と似ている！
遷移先をどうするのかを調べる

<フォロー・フォロワー一覧画面を作成すること>
=>user/relationship
フォーマットはuser/indexページと同様の実装になる
eachを使用して取り出すデータをrelationshipのデータにする必要がある

  
  
* ＜エラー集ヒント＞
  Couldn't find User without an ID
IDなしにUserを探せません、というエラーになります。
User.find(○○)というコードの場合、カッコ内の○○が正しくないことが多いです。
ターミナルやルーティングを確認してみましょう。


Could not find the source association(s) :xxx in model Relationship. Try ...(以下略)
Relationshipモデル内にxxxというリレーションが見つかりません、というエラーになります。
モデルに定義したアソシエーションが正しいか確認してみましょう。


<tr>
	  <th>
	   <% if @user != current_user %>
	    <% if current_user.is_followed_by?(@user)%>
	     <%= link_to user_relationships_path(@user), method: :post do %>
	     <button class = "btn btn-sm btn-success">フォローする</button>
	     <% end %>
	    <% else %>
	     <%= link_to user_relationships_path(@user), method: :delete do %>
	     <button class = "btn btn-sm btn-danger">フォロー外す</button>
	     <% end %>
	    <% end %>
	   <% end %>
	  </th>
  </tr>