# == Schema Information
#
# Table name: access_tokens
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# FactoryBot.define do
#   factory :access_token do
#     token { "MyString" }
#     user { nil }
#   end
# end

FactoryBot.define do
  factory :access_token do
    #token is generated after initialization
    association :user
  end
end