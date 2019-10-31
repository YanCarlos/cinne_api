module Api
  module V1
    class BookingsController < ApiController
      before_action :set_schedule, only: :create

      def index
        render json: Booking.with_schedule_and_movies
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
            message: @booking.errors,
            data: @booking
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
          render json: { message: e.message }, status: :not_found
        end
      end
    end
  end
end
