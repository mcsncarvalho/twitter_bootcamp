class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def following?(other_user)
    following.include?(other_user)
  end

  def follow!(other_user)
    following << other_user
  end
  
  def unfollow!(other_user)
    following.delete(other_user)
  end

  def feed
    # Este método irá gerar o feed para o usuário
    users_id = following.pluck(:id)
    users_id << self.id
    Tweet.where(user_id: users_id).order(created_at: :desc)
  end

end
