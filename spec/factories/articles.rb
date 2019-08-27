# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Title #{n-1}" }
    sequence(:content) { |n| "Content #{n-1}" }
    sequence(:slug) { |n| "Slug-#{n-1}" }
    association :user
  end
end
