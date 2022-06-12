class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  has_one_attached :image
  
  # 引数で渡されたユーザーidがFavoriteテーブル内に存在(exsits?)しているか
  def favorited_by?(user)
    favorites.exists?(user_id:user.id)
    favorites.where(user_id: user.id).exists?
  end
end
