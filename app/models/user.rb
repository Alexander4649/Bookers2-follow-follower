class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  
  #1 フォローされる側なのか、フォローする側かのhas_manyかわからないので、foreign_keyを設定してフォローする側からのhas_manyだと認識させてあげる
  has_many :relationships, foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  #フォローしている人全員の情報を取得するので、任意名ですが、followedと記述
  #has_many_throughにて中間テーブルを経由して情報を持ってくる際に使用する。その為、今回はrelationshipsと記述
  #relationshipsから何の情報をとってくるのか、これを指定する際にsourceを使用する
  #あるアカウントがフォローしている情報をリレーションシップの中間テーブルを経由してフォローされる側の情報を抽出するという記述の意味となる。
  
  
  #1とは逆にフォローされる側からのhas_manyだと認識させてあげるが、relationshipsと記述すると、フォローする側のアソシエーションと重複してしまうので、reverse_of_を使用する
  #但し、reverse_of_relationshipsのテーブルを見つけようとするので、class_nameを使ってrelationshipテーブルであると認識させる。
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :following
  #あるユーザーをフォローしてくれている人を抽出する
  #自分をフォローしてくれる人の情報を全部取ってくる記述なので、source: :followingとなる
  
  #あるユーザが引数で渡されたUserにフォローされているのか否か判定できるメソッド
  def is_followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present?
  end
  
  
  
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true,presence: true
  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image
  
  def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  #def get_profile_image
  #  (profile_image.attached?) ? profile_image : 'no_image.jpg'
  #end
end
