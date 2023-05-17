require "rails_helper"

RSpec.describe User, type: :model do
  describe "validation" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
    it { is_expected.to validate_uniqueness_of(:email) }
    

    it { is_expected.to allow_value("ss@gmail.vn").for(:email) }
    it { is_expected.not_to allow_value("ss@gmail").for(:email) }
    it { is_expected.not_to allow_value("@gmail.test").for(:email) }

    it { should have_many(:videos).dependent(:destroy) }
  end
end
