class Booking < ApplicationRecord
  belongs_to :schedule

  validates_presence_of :name, message: 'El nombre no puede estar en blanco.'
  validates_presence_of :identification, message: 'La identificación no puede estar en blanco.'
  validates_presence_of :phone, message: 'El telefono no puede estar en blanco.'
  validates_presence_of :email, message: 'El email no puede estar en blanco.'
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validate :can_booking?

  scope :scheduled_on, -> (date) do
    includes(schedule: :movie).where(schedules: { date: date })
  end

  private

  def can_booking?
    errors.add(:booking, 'No hay cupos disponibles para esta función.') unless schedule&.can_booking?
  end
end
