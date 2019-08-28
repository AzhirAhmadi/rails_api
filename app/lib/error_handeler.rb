module ErrorHandeler
    class AuthenticationError
        class Oauth < StandardError;end
        class Standard < StandardError; end
    end
    class AuthorizationError < StandardError; end
    class ErrorSerializer < ActiveModel::Serializer::ErrorSerializer; end
end