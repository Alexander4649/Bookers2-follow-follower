class Favorite < ApplicationRecord
  
  belongs_to :user#イイねはuserから見れば一回だけなのでbelongs_toを使用する。(bookも同様)
  belongs_to :book
  
end
