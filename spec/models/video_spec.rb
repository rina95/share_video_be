require "rails_helper"

RSpec.describe Video, type: :model do
  describe "validation" do
    context "presence" do
      it { is_expected.to validate_presence_of(:url) }
    end

    context "uniqueness" do
      it { is_expected.to validate_uniqueness_of(:url) }
    end

    context "format" do
      it { is_expected.to allow_value("https://youtu.be/xxx/").for(:url) }
      it { is_expected.to allow_value("http://youtu.be/xxx").for(:url) }
      it { is_expected.to allow_value("https://youtu.be/xxx").for(:url) }
      it { is_expected.to allow_value("https://youtu.be/545vf45-").for(:url) }
      it { is_expected.to allow_value("https://www.youtube.com/watch?v=Wgjkapu45AA").for(:url) }
      it { is_expected.to allow_value("https://www.youtube.com/watch?v=Wgjkapu45AA&test=123").for(:url) }
      it { is_expected.to allow_value("https://youtu.be/SD8RvUUYawE").for(:url) }

      it { is_expected.not_to allow_value("https://youtu/SD8RvUUYawE").for(:url) }
      it { is_expected.not_to allow_value("https://yabc/SD8RvUUYawE").for(:url) }
    end
  end

  describe "association" do
    it { should belong_to(:user) }
  end

  describe "#embed_url" do
    let(:video) { build :video, video_id: "123Abc-" }

    it { expect(video.embed_url).to eq "https://www.youtube.com/embed/123Abc-" }
  end
end
