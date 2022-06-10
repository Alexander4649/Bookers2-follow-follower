エラー詳細と解決方法

〜起動前編〜
* routes.rbにてエラー => end　が抜けている
* rails routesをしてもエラーになる (Run bundle install to install missing gems.)=>bundle installができていない=> bundle install実行
* rails sをしても起動しない =>ホストエラーになるので、config.hosts 内容をenviroment/development.rbに記述
* ActiveRecord::PendingMigrationErrorになる=> rails db:migrate or Run panding migrateにて対応
* Webpacker::Manifest::MissingEntryError in Devise::Sessions#new　エラー=>Webpackerをinstallできていない=>rail webpacker:installで対応

〜起動後編〜
* bootstrapが適用されていない=>yarn add jquery bootstrap@4.5 popper.js =>staylesheetsフォルダ=>application.scss作成=>@import '~bootstrap/scss/bootstrap'記述
* FontAwsome適用されていない=>yarn add @fortawesome/fontawesome-free@5.15.4=>application.scssに@import '~@fortawesome/fontawesome-free/scss/fontawesome'記述
* 起動後/user/signinにいってしまう =>before action :authenticate_user!(ログインしていないとログインページに飛ばされるbeforeアクション)が機能している為=>except: [:top,:about]追加
* Viewが呼ばれていない=>layout/application.html.erbに<%= yield %>が入っていないので、Viewを呼び出しできていない
* TopのViewが表示されない =>link_toのpathが複数形になっている為=> 「s」を外す ※ちなみに、link to後のsign upも大文字から小文字に変更
* ナブバーのHOME、About等全ての表記が違う=> header.htmlの記述を変更
* Sign upが起動しない=>registrations/new.html.erbの記述が違う=> name filedではなく、text filedに変更
* Sign upができない(Books must existエラーになる) =>モデル設定のアソシエーションが逆になっている=>user.rb(has_many :books)、book.rb(belongs to:user)
* Sign up後にHome(マイページ)にいかない => after sign in path for(resource)がroot_pathになっているので、users#showにしたいのでuser path(@user.id)にする

〜Sign up後編〜
* Homeボタンにてマイページに飛ばない=> users controleerのindexアクションにendが抜けている=> end記述
* UsersボタンにてActionView::MissingTemplate in Users#indexエラー=> from.html.erbファイルがusersフォルダにないので、'books/form'に変更
* UsersのViewがうまく表示されない=><div class='container px-5 px-sm-0'><div class='row'><div class='col-md-3'>と<div class='col-md-8 offset-md-1'>を追記
* editページに飛ばない=> NoMethodError=> users_controllerのeditアクションに記述がない=>@user = User.find(params[:id])追記
* editページにてname変更がTitleになっている=>edit.html.erbファイルのtitleをnameに変更
* editページのバリデーションが機能していない=>NoMethodError=>rederが"show"になっているので、editに変更
* editページ後にURLの記述がuser.id表記になっている。=>users controllerのupdateアクションにてリダイレクト先がusers_path(index行き)になっているのでuser path(show行き)に変更
* create bookボタンが機能しない=>book_params---permit(:title)=>,:bodyが抜けているので追記=>投稿保存まで完了
* create bookボタンを押すとBook/showにいくはずがエラー=>NameError undefined local variable or method `user'=> books controllerに@book = Book.new、@book = Book.find(params[:id])を記述
* create bookボタンを空欄で押してもバリデーションが機能しない=>book/indexに記述がない=> <%= form_with model:@book, local:true do |f| %>と<%= render 'layouts/errors', obj: @book %>を記述
* Booksに飛ばない=>index.html.erbのuser:に渡す引数が@userではなくcuurent_user(ログイン中のユーザー)にする必要がある=>記述変更=>レイアウトがおかしいので<div class='container px-5 px-sm-0'>を追記
* books/editページにてバリデーションが機能していない=><%= form_with model:@book, local:true do |f| %><%= render 'layouts/errors', obj: @book %>コードの追加
* Destory機能が機能しない=>Unknown action =>destroyアクションがdeleteになってる++destroyのスペルミスもあるので修正
* 他人の投稿記事にeditとdestroyボタンが出現してしまう=> <% if @book.user id == current_user.id %><%end%>をeditとdestroyを囲うように記述
* 他人のアカウントeditが操作できてしまう=>users controllerのensur eorrect user　if @user != current_user に記述変更又、[:update]のみなので[:edit]アクションも追加
* 他人のbook/editに遷移できてしまう=>before action :ensure correct book, only: [:update,:edit]をbooks controllerに記述追加
* introductionにバリデーション(文字数制限)が機能していない=>validates :introduction, length: { maximum: 50 }を記述
* 新規投稿後に、新規投稿フォームがeditフォームになっている=>controllerにbook.newの空の投稿をする
* 
そのほかは色々いじってたらできたパターン
今一度復習しよう、、、