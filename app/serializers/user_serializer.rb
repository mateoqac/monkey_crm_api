# app/serializers/user_serializer.rb
class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email
end
