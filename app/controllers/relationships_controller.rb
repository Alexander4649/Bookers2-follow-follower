class RelationshipsController < ApplicationController
  before_action :authenticate_user!#ログインしているか確認!
  
  def create
    # フォローすることは = ログイン中のユーザーがフォローを行うこと(cuurent_user.relationships.build)、これによりカレントユーザーに紐づいたリレーションシップを作成することができる
    # フォローを行うことはフォローされる側のidが必要になるので、(follwer_id)と記述。follwer_idはパラメータ(URL)から取得する番号である為、params[:user_id]となる。
    # user.rbにてhas_many :relationshipsと記述してあるお陰で、cuurent_userには「following_idが」勝手に入るようになります。
    following = current_user.relationships.new(follower_id:params[:user_id])
    following.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    following = current_user.relationships.find_by(follower_id:params[:user_id])
    following.destroy
    redirect_back(fallback_location: root_path)
  end
end
