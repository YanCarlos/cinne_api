require 'rails_helper'

describe Movie do
  it { have_many :schedules }
  it{ should accept_nested_attributes_for :schedules }

  it { should validate_presence_of(:name).with_message('El nombre no puede estar en blanco.')  }
  it { should validate_presence_of(:description).with_message('La descripción no puede estar en blanco.') }
  it { should validate_presence_of(:image_url).with_message('La url de la imagen no puede estar en blanco.') }
  it { should validate_presence_of(:schedules).with_message('Las fechas de las funciones son necesarias.') }

  describe 'schedules_valid?' do
    let(:movie) {
      Movie.new({
        name: 'a movie',
        description: 'This is a movie',
        image_url: 'a url'
      })
    }

    describe '#is_any_date_empty?' do
      context 'when any date of schedules is empty' do
        before do
          movie.update({ schedules_attributes: [{ date: '' }]})
        end

        it 'is not valid' do
          expect(movie.valid?).to eq(false)
        end
      end

      context 'when there is not empty date in schedules' do
        before do
          movie.update({ schedules_attributes: [{ date: Time.zone.today }]})
        end

        it 'is valid' do
          expect(movie.valid?).to eq(true)
        end
      end
    end

    describe '#has_repeated_schedule?' do
      context 'when it has repeated schedules' do
        before do
          movie.update({ 
            schedules_attributes: [
              { date: Time.zone.today },
              { date: Time.zone.today }
            ] 
          })
        end
        it 'is not valid' do
          expect(movie.valid?).to eq(false)
        end
      end

      context 'when it does not have repeated schedules' do
        before do
          movie.update({ 
            schedules_attributes: [
              { date: Time.zone.today },
              { date: Time.zone.yesterday }
            ] 
          })
        end

        it 'is valid' do
          expect(movie.valid?).to eq(true)
        end
      end
    end
  end
end
