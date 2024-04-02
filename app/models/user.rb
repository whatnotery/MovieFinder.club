class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api
  
  has_many :reviews
  has_many :likes
  has_many :liked_films, through: :likes, source: :film     

  validate :no_current_user_as_user_name

  def no_current_user_as_user_name
    errors.add(:user_name, :exclusion) if user_name.include?("current_user")
  end

  def is_admin?
    is_admin
  end

end
