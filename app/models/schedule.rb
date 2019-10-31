class Schedule < ApplicationRecord
  belongs_to :movie
  has_many :bookings, dependent: :destroy

  def can_booking?
    bookings.size < 10
  end

  def movie_name
    return '' if movie.nil?

    movie.name
  end
end
