class ErrorHandeler
    class AuthenticationError < StandardError; end
    class AuthorizationError < StandardError; end
    class ErrorSerializer < ActiveModel::Serializer::ErrorSerializer; end
end