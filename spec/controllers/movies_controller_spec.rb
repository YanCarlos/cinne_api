require 'rails_helper'

describe Api::V1::MoviesController do
  describe '#index' do
    let(:today) { Time.zone.today }
    let(:yesterday) { Time.zone.today - 1 }

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
      before do
        request.headers.merge!({ 'Authorization': 'Token token=api_key_test'})
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
      end
    end
  end
end
