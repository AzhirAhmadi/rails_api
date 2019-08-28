class UserAuthenticator::Standard < UserAuthenticator
    attr_reader :user, :access_token
    
    def initialize(login, password)

    end
    
    def perform
        raise ErrorHandeler::AuthenticationError::Standard
    end
end