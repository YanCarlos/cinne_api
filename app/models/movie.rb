class Movie < ApplicationRecord
  has_many :schedules, dependent: :destroy

  scope :with_date, -> { where(id: 1) }

  scope :with_date, -> (date) do
    includes(:schedules).where(schedules: { date: date })
  end
end
