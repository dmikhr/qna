class QuestionFullSerializer < ActiveModel::Serializer
  include Serialized

  attributes :id, :title, :body, :created_at, :updated_at
end
