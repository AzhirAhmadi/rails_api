class ErrorHandeler
    class AuthenticationError < StandardError; end
    class AuthorizationError < StandardError; end
end