module Api
  module V1
    class MoviesController < ApiController
      before_action :set_date, only: :index

      def index
        render json: Movie.scheduled_on(@date), status: :ok
      end

      def create
        @movie = Movie.new(movie_params)
        if @movie.save
          render json: { 
            message: 'Movie was created successfully.',
            data: @movie
          }, status: :ok
        else
          render json: { 
            message: @movie.errors.messages,
          }, status: :bad_request
        end
      end

      private

      def movie_params
        params.require(:movie).permit(
          :name,
          :description,
          :image_url,
          schedules_attributes: [:date]
        )
      end

      def set_date
        @date = params[:date] || Time.zone.today
      end
    end
  end
end
