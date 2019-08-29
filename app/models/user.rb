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
    validates :password, presence: true, if: -> { provider == "standard"}

    has_one :access_token, dependent: :destroy

    has_many :articles, dependent: :destroy
    has_many :comments, dependent: :destroy

    def password
        @password ||= BCrypt::Password.new(encrypted_password) if encrypted_password.present?
    end

    def password=(new_password)
        return @password = new_password if new_password.blank?
        @password = BCrypt::Password.create(new_password)
        self.encrypted_password = @password
    end
end
