class Movie < ApplicationRecord
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :image_url
  validates_presence_of :schedules

  validate :schedules_valid?

  scope :scheduled_on, -> (date) do
    includes(schedules: :bookings).where(schedules: { date: date })
  end

  private

  def schedules_valid?
    errors.add(:schedules, :blank, message: 'cannot be blank') if is_any_date_empty?
    errors.add(:schedules, message: "There is only one movie's show available per day") if has_repeated_schedule?
  end

  def is_any_date_empty?
    schedules.select{ |schedule| schedule['date'].blank? }.any?
  end

  def has_repeated_schedule?
    dates = schedules.collect(&:date)
    dates.detect{ |e| dates.count(e) > 1 }.present?
  end
end
