class UserAuthenticator 
    
    attr_reader :authenticator

    def initialize(code: nil,login: nil, password: nil)
        @authenticator = if code.present?
            Oauth.new(code)
        else
            Standard.new(login, password)
        end
    end

    def perform
        authenticator.perform
    end

    def user
        authenticator.user
    end

    def access_token
        authenticator.access_token
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