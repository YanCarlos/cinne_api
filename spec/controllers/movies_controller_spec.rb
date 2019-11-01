require 'rails_helper'

describe Api::V1::MoviesController do
  let(:api_key) { ENV['API_KEY'] }
  let(:yesterday) { Time.zone.today - 1 }

  describe '#index' do
    context 'when the api key is not valid' do
      before do
        request.headers.merge!({ 'Authorization': 'Token token=fake_api_key'})
        get :index
      end

      it 'returns a unauthorized code' do
        expect(response.status).to eq(401)
      end

      it 'returns a error message' do
        expect(JSON.parse(response.body)['message']).to include('El api_key no es valido')
      end
    end

    context 'when the api key is valid' do
      before do
        request.headers.merge!({ 'Authorization': "Token token=#{api_key}"})
        get :index
      end

      it 'returns a status code 200' do
        expect(response.status).to eq(200)
      end

      context 'when the date is sent as a param' do
        before do
          FactoryBot.create_list(:movie, 5, :with_schedules)

          get :index, params: { date: yesterday }
        end

        it 'returns all movies' do
          expect(JSON.parse(response.body).count).to eq(5)
        end
      end

      context 'when the date is not sent' do
        context 'when there is a movie for today' do
          before do
            FactoryBot.create_list(:movie, 8, :with_schedules)

            get :index
          end

          it 'returns movies with today schedule' do
            expect(JSON.parse(response.body).count).to eq(8)
          end
        end

        context 'when there is not a movie for today' do
          before do
             get :index
          end

          it 'returns empty' do
            expect(JSON.parse(response.body).count).to eq(0)
          end
        end

        context 'when the schedule movie has a schedules with 10 bookings' do
          let!(:movie) { FactoryBot.create(:movie, schedules_attributes: [{ date: yesterday }])}
          let!(:schedule) { movie.schedules.first }

          before do
            FactoryBot.create_list(:booking, 10, schedule: schedule)

            get :index, params: { date: yesterday }
          end

          it 'returns schedule_id' do
            expect(JSON.parse(response.body)[0]['schedule_id']).to eq(schedule.id)
          end

          it 'returns can_booking? in false' do
            expect(JSON.parse(response.body)[0]['can_booking']).to eq(false)
          end
        end

        context 'when  the schedule movie has a schedule with 5 bookings' do
          let!(:movie) { FactoryBot.create(:movie, schedules_attributes: [{ date: yesterday }])}
          let!(:schedule) { movie.schedules.first }

          before do
            FactoryBot.create_list(:booking, 5, schedule: schedule)

            get :index, params: { date: yesterday }
          end

          it 'returns can_booking? in true' do
            expect(JSON.parse(response.body)[0]['can_booking']).to eq(true)
          end
        end
      end
    end
  end

  describe '#create' do
    context 'when the api key is not valid' do
      before do
        request.headers.merge!({ 'Authorization': 'Token token=fake_api_key'})
        post :create, params: { }
      end

      it 'returns a unauthorized code' do
        expect(response.status).to eq(401)
      end
    end

    context 'when the api key is valid' do
      before do
        request.headers.merge!({ 'Authorization': "Token token=#{api_key}"})
      end

      context 'When the movie is correct' do
        before do
          post :create, params: {
            movie: FactoryBot.attributes_for(:movie, :with_schedules)
          }
        end

        it 'returns a code 200' do
          expect(response.status).to eq(200)
        end

        it 'returns a message and the move data' do
          expect(JSON.parse(response.body)['message']).to eq('Movie was created successfully.')
          expect(JSON.parse(response.body)['data']).to eq(JSON.parse(Movie.last.to_json))
        end
      end

      context 'when movie is not sent' do
        before do
          post :create, params: {}
        end

        it 'returns a bad request' do
          expect(response.status).to eq(400)
        end

        it 'returns a error message' do
          expect(JSON.parse(response.body)['message']).to eq('param is missing or the value is empty: movie')
        end
      end

      context 'a schedule date is empty' do
        before do
          post :create, params: {
            movie: FactoryBot.attributes_for(:movie, schedules_attributes: [ { date: '' }])
          }
        end

        it 'returns a bad request' do
          expect(response.status).to eq(400)
        end

        it 'returns a error message' do
          expect(JSON.parse(response.body)['message']['schedule_date']).to include('Ninguna fecha puede estar en blanco.')
        end
      end

      context 'when an unpermitted param is sent' do
        before do
          post :create, params: {
            movie: {
              duration: '2h'
            }
          }
        end

        it 'returns a bad request code' do
          expect(response.status).to eq(400)
        end

        it 'returns a error message' do
          expect(JSON.parse(response.body)['message']).to eq('found unpermitted parameter: :duration')
        end
      end

      context 'when movie has repeated schedules' do
        before do
          post :create, params: {
            movie: FactoryBot.attributes_for(
              :movie, 
              schedules_attributes: [
                { date: yesterday },
                { date: yesterday }
              ]
            )
          }
        end

        it 'returns a bad request' do
          expect(response.status).to eq(400)
        end

        it 'returns a error message' do
          expect(JSON.parse(response.body)['message']['schedule']).to include('Solo hay una funcion disponible al dia por pelicula')
        end
      end
    end
  end
end
