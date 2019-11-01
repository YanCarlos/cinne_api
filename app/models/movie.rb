class Movie < ApplicationRecord
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules

  validates_presence_of :name, message: 'El nombre no puede estar en blanco.'
  validates_presence_of :description, message: 'La descripción no puede estar en blanco.'
  validates_presence_of :image_url, message: 'La url de la imagen no puede estar en blanco.'
  validates_presence_of :schedules, message: 'Las fechas de las funciones son necesarias.'

  validate :schedules_valid?

  scope :scheduled_on, -> (date) do
    includes(schedules: :bookings).where(schedules: { date: date })
  end

  private

  def schedules_valid?
    errors.add(:schedule_date, 'Ninguna fecha puede estar en blanco.') if is_any_date_empty?
    errors.add(:schedule, 'Solo hay una funcion disponible al dia por pelicula') if has_repeated_schedule?
  end

  def is_any_date_empty?
    schedules.select{ |schedule| schedule['date'].blank? }.any?
  end

  def has_repeated_schedule?
    dates = schedules.collect(&:date)
    dates.detect{ |e| dates.count(e) > 1 }.present?
  end
end
