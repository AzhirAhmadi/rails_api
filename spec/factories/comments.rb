FactoryBot.define do
  factory :comment do
    content { "Content" }
    association :article
    association :user
  end
end
