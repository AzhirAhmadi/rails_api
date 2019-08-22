class UserAuthenticator 
    class AuthenticationError < StandardError; end
    attr_reader :user

    def initialize(code)
        @code = code
    end

    def perform
        client = Octokit::Client.new(
            client_id: "836b314d9f71e85a5f14",
            client_secret: "dc2528e56f5e8f95fd07399cfab70e4680d67abb"
        )
        token = client.exchange_code_for_token(code)
        if token.try(:error).present?
            raise AuthenticationError
        else
            user_client = Octokit::Client.new(access_token: token)
            user_data = user_client.user.to_h.slice(:login, :avatar_url, :url, :name)
            User.create(user_data.merge(provider: "github"))

        end
    end

    private
        attr_reader :code
end