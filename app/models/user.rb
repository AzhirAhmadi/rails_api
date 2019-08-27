# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  login      :string           not null
#  name       :string
#  url        :string
#  avatar_url :string
#  provider   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
    validates :login, presence: true, uniqueness: true
    validates :provider, presence: true

    has_one :access_token, dependent: :destroy

    has_many :articles, dependent: :destroy
end
