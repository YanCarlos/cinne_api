require 'rails_helper'

describe Schedule do
  it { belong_to :schedules }
  it { have_many :bookings }
end
