class Booking < ApplicationRecord
  belongs_to :schedule

  validates_presence_of :name
  validates_presence_of :identification
  validates_presence_of :phone
  validates_presence_of :email
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validate :can_booking?

  scope :with_schedule_and_movies, -> { includes(schedule: :movie) }

  private

  def can_booking?
    errors.add(:booking, "The movie's room is full.") unless schedule&.can_booking?
  end
end
