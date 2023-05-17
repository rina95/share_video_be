FactoryBot.define do
  factory :video do
    sequence(:url) { |n| "https://youtu.be/xxxxx#{n}" }
    title { "title" }
    description { "content" }
    association :user
  end
end
