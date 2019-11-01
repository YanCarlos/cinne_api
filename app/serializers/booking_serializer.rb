class BookingSerializer < ActiveModel::Serializer
  attributes :id, :identification, :name, :phone, :email, :movie_name, :schedule

  def movie_name
    object.schedule.movie_name
  end

  def schedule
    object.schedule.date
  end
end
