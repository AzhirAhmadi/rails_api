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
#

class Article < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :slug, presence: true, uniqueness: true
end
