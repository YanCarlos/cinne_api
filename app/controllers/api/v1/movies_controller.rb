module Api
  module V1
    class MoviesController < ApiController
      before_action :set_date, only: :index

      def index
        render json: Movie.with_date(@date)
      end

      private

      def set_date
        @date = params[:date] || Time.zone.today
      end
    end
  end
end
