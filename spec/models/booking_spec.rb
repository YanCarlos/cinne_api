require 'rails_helper'

describe Booking do
  it { belong_to :schedule }

  it { should validate_presence_of(:name).with_message('El nombre no puede estar en blanco.') }
  it { should validate_presence_of(:email).with_message('El email no puede estar en blanco.') }
  it { should validate_presence_of(:phone).with_message('El telefono no puede estar en blanco.') }
  it { should validate_presence_of(:identification).with_message('La identificación no puede estar en blanco.') }
end
