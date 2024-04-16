class Favorite < ApplicationRecord
  belongs_to :user
  # Add other associations as needed

  validate :check_favorite_limit, on: :create

  private

  def check_favorite_limit
    if Favorite.where(user_id: user_id).count >= 3
      errors.add(:base, "User can have only three favorites")
    end
  end
end
