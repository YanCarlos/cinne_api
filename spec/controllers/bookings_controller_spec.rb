require 'rails_helper'

describe Api::V1::BookingsController do
  let(:api_key) { ENV['API_KEY'] }
  let!(:movie) { FactoryBot.create(:movie, schedules_attributes: [{ date: Time.zone.today }])}
  let!(:schedule) { movie.schedules.first }

  describe '#index' do
    context 'when the api key is not valid' do
      before do
        request.headers.merge!({ 'Authorization': 'Token token=fake_api_key'})
        get :index
      end

      it 'returns a unauthorized code' do
        expect(response.status).to eq(401)
      end
    end

    context 'when the api key is valid' do
      let!(:bookings) { FactoryBot.create_list(:booking, 10, schedule: schedule) }

      before do
        request.headers.merge!({ 'Authorization': "Token token=#{api_key}"})

        get :index
      end

      it 'returns a status code 200' do
        expect(response.status).to eq(200)
      end

      it 'returns 10 bookings' do
        expect(JSON.parse(response.body).count).to eq(10)
      end

      it 'returns the correct attributes' do
        expect(JSON.parse(response.body).first['movie_name'].present?).to eq(true)
        expect(JSON.parse(response.body).first['schedule'].present?).to eq(true)
      end
    end
  end

  describe '#create' do
    context 'when the api key is not valid' do
      before do
        request.headers.merge!({ 'Authorization': 'Token token=fake_api_key'})
        post :create, params: { id: schedule.id }
      end

      it 'returns a unauthorized code' do
        expect(response.status).to eq(401)
      end
    end

    context 'when the api key is valid' do
      before do
        request.headers.merge!({ 'Authorization': "Token token=#{api_key}"})
      end

      context 'When the booking is correct' do
        before do
          post :create, params: {
            id: schedule.id,
            booking: FactoryBot.attributes_for(:booking)
          }
        end

        it 'returns a code 200' do
          expect(response.status).to eq(200)
        end

        it 'returns a message and the booking data' do
          expect(JSON.parse(response.body)['message']).to eq("The movie's show was booked.")
          expect(JSON.parse(response.body)['data']).to eq(JSON.parse(Booking.last.to_json))
        end
      end

      context 'when the schedule is not found' do
        before do
          post :create, params: {
            id: 234324,
            booking: FactoryBot.attributes_for(:booking)
          }
        end

        it 'returns a not_found status' do
          expect(response.status).to eq(404)
        end

        it 'returns a not_found message' do
          expect(JSON.parse(response.body)['message']['not_found']).to include('Esa función de la pelicula no existe')
        end
      end

      context 'when the schedules has 10 bookings' do
        before do
          FactoryBot.create_list(:booking, 10, schedule: schedule)

          post :create, params: {
            id: schedule.id,
            booking: FactoryBot.attributes_for(:booking)
          }
        end

        it 'returns a bad request' do
          expect(response.status).to eq(400)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['message']['booking'][0]).to include('No hay cupos disponibles para esta función.')
        end
      end
    end
  end
end
