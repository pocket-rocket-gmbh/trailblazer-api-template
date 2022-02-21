require "rails_helper"

RSpec.describe "Authentication Endpoints - Login and Logout - v1", type: :request do
  before(:all) do
    @organization = setup_organization
    @login_endpoint = '/v1/auth'
    @logout_endpoint = '/v1/users/logout'

    @user = FactoryBot.create(:user, organization: @organization)
  end

  describe 'standard auth login' do
    before(:all) do
      post_json @login_endpoint, { email: @user.email, password: @user.password }, nil
      @parsed_response = JSON.parse(response.body)
      @decoded_token = JWT.decode(@parsed_response["jwt_token"],
        Rails.application.credentials[:secret_key_base], true, { algorithm: 'HS512'})
    end

    it 'should be successful' do
      expect(response.status).to eq 200
    end

    it 'should set a correct jwt_token for the user' do
      expect(@parsed_response["jwt_token"]).not_to eq nil

      expect(@decoded_token[0]["email"]).to eq @user.email
      expect(@decoded_token[0]["user_id"]).to eq @user.id
      expect(@decoded_token[0]["organization_id"]).to eq @user.organization.id
      expect(@decoded_token[0]["role"]).to eq "user"
    end

    it 'should set expiration time ~24h' do
      expiration_in_seconds = ((Time.now - Time.at(@decoded_token[0]["exp"]).to_datetime).to_i) * -1
      expect(expiration_in_seconds < 86401).to be_truthy
      expect(expiration_in_seconds > 86395).to be_truthy
    end
  end

  describe 'jwt token expired' do
    before(:all) do
      expiration_time = (Time.now - 2.days).to_i
      payload = {
        'email': @user.email,
        'user_id': @user.id,
        'organization_id': @organization.id,
        'role': @user.role,
        'exp': expiration_time
      }

      @jwt = JWT.encode(payload,
        Rails.application.credentials[:secret_key_base], 'HS512',
        { exp: expiration_time, :user_id => @user.id }
      )

      # try something with the expired token
      get_json '/v1/users/me', {}, @jwt
    end

    it 'should return 401' do
      # TODO: check why no response body is available
      expect(response.status).to eq 401
    end
  end

  describe 'wrong credentials' do
    before(:all) do
      post_json @login_endpoint, { email: @user.email, password: "definetelywrong" }, nil
      @parsed_response = JSON.parse(response.body)
    end

    it 'should not be successful' do
      expect(response.status).to eq 401
    end
  end
end
