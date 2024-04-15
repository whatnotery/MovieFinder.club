class Like < ApplicationRecord
  belongs_to :user
  belongs_to :film

  validates :user, :film, presence: true

  validates :user_id, uniqueness: {scope: :film_id}
end
