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

class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :slug
end
