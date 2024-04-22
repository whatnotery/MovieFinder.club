class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :reviews
  has_many :favorites
  has_many :favorite_films, through: :favorites, source: :film
  has_many :likes
  has_many :liked_films, through: :likes, source: :film

  validate :user_name, :no_current_user_as_user_name

  def no_current_user_as_user_name
    errors.add(:user_name, :exclusion) if "current_user".include?(:user_name.to_s)
  end

  def is_admin?
    is_admin
  end
end
