module Api
  module V1
    class BookingsController < ApiController
      before_action :set_schedule, only: :create
      before_action :set_date, only: :index

      def index
        render json: Booking.scheduled_on(@date)
      end

      def create
        @booking = Booking.new(booking_params)
        if @schedule.bookings << @booking
           render json: { 
            message: "The movie's show was booked.",
            data: @booking
          }, status: :ok
        else
          render json: { 
            message: @booking.errors.messages,
          }, status: :bad_request
        end
      end

      private

      def booking_params
        params.require(:booking).permit(
          :name,
          :phone,
          :identification,
          :email
        )
      end

      def set_schedule
        begin
          @schedule = Schedule.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { message: { 'not_found': 'Esa función de la pelicula no existe' }}, status: :not_found
        end
      end

      def set_date
        @date = params[:date] || Time.zone.today
      end
    end
  end
end
