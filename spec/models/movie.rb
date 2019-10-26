require 'rails_helper'

describe Movie do
  it { have_many :schedules }
end
