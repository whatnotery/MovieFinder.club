class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :film
  # Add other associations as needed

  validate :check_favorite_limit, on: :create
  validates :user_id, uniqueness: {scope: :film_id}

  private

  def check_favorite_limit
    if Favorite.where(user_id: user_id).count >= 4
      errors.add(:base, "User can have only four favorites")
    end
  end
end
