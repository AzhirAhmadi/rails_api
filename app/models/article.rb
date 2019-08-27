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

class Article < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :slug, presence: true, uniqueness: true

    belongs_to :user

    has_many :comments, dependent: :destroy

    scope :recent, -> {order(created_at: :desc)}
end
