require 'rails_helper'

RSpec.describe Project, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.build(:project)).to be_valid
  end

  it "is invalid without a name" do
  	person = FactoryBot.build(:project, name: nil)
    expect(person).not_to be_valid
  end

end
