class UserAuthenticator::Oauth < UserAuthenticator
    
    attr_reader :user

    def initialize(code)
        @code = code
    end

    def perform
        raise ErrorHandeler::AuthenticationError::Oauth if code.blank?
        raise ErrorHandeler::AuthenticationError::Oauth if token.try(:error).present?
        prrepare_user
    end

    private
        attr_reader :code

        def client
            @client ||= Octokit::Client.new(
                client_id: ENV["client_id"],
                client_secret: ENV["client_secret"]
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