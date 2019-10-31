require 'rails_helper'

describe Booking do
  it { belong_to :schedule }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:identification) }
end
