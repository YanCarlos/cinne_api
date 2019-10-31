class MovieSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :schedule_id, :can_booking

  def schedule_id
    object.schedules.first.id
  end

  def can_booking
    object.schedules.first.can_booking?
  end
end
