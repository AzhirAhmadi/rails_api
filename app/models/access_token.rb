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

class AccessToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true

  belongs_to :user
  after_initialize :generate_token

  private

  def generate_token
    loop do
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)
      self.token = SecureRandom.hex(10)
    end
  end
end
