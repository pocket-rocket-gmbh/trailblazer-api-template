require "rails_helper"

RSpec.describe "Users Endpoints - v1/users", type: :request do
  before(:all) do
    @endpoint = '/v1/users'
    @organization = setup_organization

    # setup users
    @root       = setup_user_root(@organization)
    @admin      = setup_user_admin(@organization)
    @user       = setup_user(@organization)

    # Login users to get tokens
    @root_token = login(@root.email, @root.password)
    @admin_token = login(@admin.email, @admin.password)
    @user_token = login(@user.email, @user.password)

    # sample data
    @organization2 = setup_organization
    @user1 = FactoryBot.create(:user, organization: @organization)
    @user2 = FactoryBot.create(:user, organization: @organization)
    @user_from_different_organization = FactoryBot.create(:user, organization: @organization2)
  end

  context 'Update' do
    before(:all) do
      base64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII="

      @put_json = {
        "firstname": "Hugo",
        "file": base64
      }
    end
    context 'roles' do
      shared_examples_for 'update' do
        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should return the user as json' do
          body = response.parsed_body
          res = body['resource']

          expect(res['firstname']).to eq @put_json[:firstname]
          expect(res['profile_image_url']).not_to eq nil
        end
      end

      context 'as root' do
        describe 'from same organization' do
          before(:all) do
            put_json "#{@endpoint}/#{@user1.id}", @put_json, @root_token
          end

          it_behaves_like 'update'
        end

        describe 'from different organization' do
          before(:all) do
            put_json "#{@endpoint}/#{@user_from_different_organization.id}", @put_json, @root_token
          end

          it_behaves_like 'update'
        end
      end

      context 'as admin' do
        describe 'from same organization' do
          before(:all) do
            put_json "#{@endpoint}/#{@user1.id}", @put_json, @admin_token
          end

          it_behaves_like 'update'
        end

        describe 'from different organization' do
          before(:all) do
            put_json "#{@endpoint}/#{@user_from_different_organization.id}", @put_json, @admin_token
          end

          it 'should return status 404' do
            expect(response.status).to eq 404
          end
        end
      end

      context 'as user' do
        describe 'own user' do
          before(:all) do
            put_json "#{@endpoint}/#{@user.id}", @put_json, @user_token
          end

          it_behaves_like 'update'
        end

        describe 'other user' do
          before(:all) do
            put_json "#{@endpoint}/#{@user1.id}", @put_json, @user_token
          end

          it 'should return status 404' do
            expect(response.status).to eq 404
          end
        end
      end
    end

    context 'set a new password' do
      before(:all) do
        @manual_password = Faker::Internet.password
        @put_json2 = {
          "firstname": "Karl",
          "lastname": "Lauterbach",
          "password": @manual_password
        }
      end

      shared_examples_for 'set_new_password' do
        it 'should have invited the user with a manual password' do
          @user.reload
          @new_user_token = login(@user.email, @manual_password)
          expect(@user.firstname).to eq @put_json2[:firstname]
          expect(@new_user_token).not_to eq nil
        end
      end

      context 'as admin' do
        before(:all) do
          @user = @user1
          put_json "#{@endpoint}/#{@user1.id}", @put_json2, @admin_token
        end

        it_behaves_like 'set_new_password'
      end

      context 'as user' do
        before(:all) do
          @user = @user2
          put_json "#{@endpoint}/#{@user2.id}", @put_json2, @user_token
        end

        it 'should not let the user login with the new password' do
          @json_params = FactoryBot.build(:authenticate_json,
            email: @user2.email,
            password: @manual_password).marshal_dump.as_json
          @result = Authentication::Operations::GenerateToken.(params: @json_params)
          expect(@result.failure?).to be_truthy
        end
      end
    end

    # update-password endpoint
    context 'change password individually' do
      describe 'user is current user' do
        before(:all) do
          @new_password = Faker::Internet.password
          @put_json2 = {
            password: @new_password,
            password_confirmation: @new_password
          }

          @endpoint2 = "/v1/users/#{@user.id}/update-password"
          put_json @endpoint2, @put_json2, @user_token
        end

        it 'should let the user login with the new password' do
          @user.reload
          @new_user_token = login(@user.email, @new_password)
          expect(@new_user_token).not_to eq nil
        end
      end

      describe 'try to update password of another user' do
        before(:all) do
          @new_password = Faker::Internet.password
          @put_json2 = {
            password: @new_password,
            password_confirmation: @new_password
          }

          @endpoint2 = "/v1/users/#{@user.id}/update-password"
          put_json @endpoint2, @put_json2, @admin_token
        end

        it 'should not let the user login with the new password' do
          @json_params = FactoryBot.build(:authenticate_json,
            email: @user.email,
            password: @new_password).marshal_dump.as_json
          @result = Authentication::Operations::GenerateToken.(params: @json_params)
          expect(@result.failure?).to be_truthy
        end
      end
    end

    context 'fail cases' do
      before(:all) do
        @put_json = {
          "firstname": "Hugo",
          "role": "user"
        }
      end
      context 'as user' do
        describe 'tries to edit its own role' do
          before(:all) do
            put_json "#{@endpoint}/#{@user2.id}", @put_json, @user_token
          end

          it 'should return status 403' do
            expect(response.status).to eq 403
          end
        end
      end
    end
  end
end
