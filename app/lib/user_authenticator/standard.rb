class UserAuthenticator::Standard < UserAuthenticator
    def initialize(login: nil, password: nil)

    end
    
    def perform
        raise ErrorHandeler::AuthenticationError::Standard
    end
end