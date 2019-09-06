class AnswerFullSerializer < ActiveModel::Serializer
  include Serialized

  attributes :id, :body, :created_at, :updated_at
end
