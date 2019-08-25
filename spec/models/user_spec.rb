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

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    it "shuold have valid factory" do
      user = build :user
      expect(user).to be_valid
    end

    it "should validate presence of attributes" do
      user = build :user, login: nil, provider: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end

    it "should validate uniqueness of login" do
      user = create :user
      other_user = build :user, login: user.login
      expect(other_user).not_to  be_valid
      other_user.login = "new_login"
      expect(other_user).to be_valid
    end
  end
end
