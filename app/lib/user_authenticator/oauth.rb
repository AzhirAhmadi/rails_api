class UserAuthenticator::Oauth < UserAuthenticator
    
    attr_reader :user, :access_token

    def initialize(code)
        @code = code
    end

    def perform
        raise ErrorHandeler::AuthenticationError::Oauth if code.blank?
        raise ErrorHandeler::AuthenticationError::Oauth if token.try(:error).present?
        prrepare_user
        @access_token = if user.access_token.present?
            user.access_token
        else
            user.create_access_token(token: token)
        end
    end

    private
        attr_reader :code

        def client
            @client ||= Octokit::Client.new(
                client_id: "836b314d9f71e85a5f14",
                client_secret: "dc2528e56f5e8f95fd07399cfab70e4680d67abb"
            )
        end

        def token
            @token = client.exchange_code_for_token(code)
        end

        def user_data
            @user_data = Octokit::Client.new(access_token: token).user.to_h.slice(:login, :avatar_url, :url, :name)
        end

        def prrepare_user
            @user = if User.exists?(login: user_data[:login])
                User.find_by(login: user_data[:login])
            else
                User.create(user_data.merge(provider: "github"))
            end
        end
end