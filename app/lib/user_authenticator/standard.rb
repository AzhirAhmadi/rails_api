class UserAuthenticator::Standard < UserAuthenticator
    attr_reader :user
    
    def initialize(login, password)
        @login = login
        @password =password
    end
    
    def perform
        raise ErrorHandeler::AuthenticationError::Standard if (login.blank? || password.blank?)
        raise ErrorHandeler::AuthenticationError::Standard unless User.exists?(login: login)

        user =User.find_by(login: login)

        raise ErrorHandeler::AuthenticationError::Standard unless user.password == password

        @user = user
    end

    private
        attr_reader :login, :password
end