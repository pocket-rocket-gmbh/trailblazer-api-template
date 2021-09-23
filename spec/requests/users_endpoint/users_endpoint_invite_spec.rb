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
  end

  context 'CRUD' do
    context 'Create' do
      context 'roles' do
        shared_examples_for 'invite' do
          it 'should return status 201' do
            expect(response.status).to eq 201
          end

          it 'should have invited the user to the organization' do
            @new_user = @organization.users.find response.parsed_body['resource']['id']

            expect(@new_user.firstname).to eq @post_json[:firstname]
            expect(@new_user.lastname).to eq @post_json[:lastname]
            expect(@new_user.email).to eq @post_json[:email]
            expect(@new_user.status).to eq 'confirmed'
            expect(@new_user.role).to eq @post_json[:role]
          end
        end

        context 'as root' do
          before(:all) do
            @post_json = {
              "firstname": "Karl",
              "lastname": "Lauterbach",
              "email": Faker::Internet.email,
              "role": ['admin', 'user'].sample
            }
            post_json @endpoint, @post_json, @root_token
          end

          it_behaves_like 'invite'
        end

        context 'as admin' do
          before(:all) do
            @post_json = {
              "firstname": "Karl",
              "lastname": "Lauterbach",
              "email": Faker::Internet.email,
              "role": ['admin', 'user'].sample
            }
            post_json @endpoint, @post_json, @admin_token
          end

          it_behaves_like 'invite'
        end

        context 'as user' do
          before(:all) do
            @post_json = {
              "firstname": "Karl",
              "lastname": "Lauterbach",
              "email": Faker::Internet.email,
              "role": ['admin', 'user'].sample
            }
            post_json @endpoint, @post_json, @user_token
          end

          it 'should return status 403' do
            expect(response.status).to eq 403
          end
        end
      end

      context 'with manual password' do
        before(:all) do
          @manual_password = Faker::Internet.password
          @post_json = {
            "firstname": "Karl",
            "lastname": "Lauterbach",
            "email": Faker::Internet.email,
            "role": ['admin', 'user'].sample,
            "password": @manual_password
          }
          post_json @endpoint, @post_json, @root_token
        end

        it 'should have invited the user with a manual password' do
          @new_user = @organization.users.find response.parsed_body['resource']['id']

          @new_user_token = login(@new_user.email, @manual_password)
          expect(@new_user_token).not_to eq nil
        end
      end

      context 'fail cases' do
        describe 'with invalid email' do
          before(:all) do
            @post_json_invalid = {
              "firstname": "Karl",
              "lastname": "Lauterbach",
              "email": "invalidmail@com",
              "role": ['admin', 'user'].sample
            }
          end
          context 'as admin' do
            before(:all) do
              post_json @endpoint, @post_json_invalid, @admin_token
            end

            it 'should return status 422' do
              expect(JSON.parse(response.body)['errors'][0]['message']) == 'email must_be_valid'
              expect(response.status).to eq 422
            end
          end
        end

        describe 'with email already in the database' do
          before(:all) do
            @post_json_invalid = {
              "firstname": "Karl",
              "lastname": "Lauterbach",
              "email": User.last.email,
              "role": ['admin', 'user'].sample
            }
          end
          context 'as admin' do
            before(:all) do
              post_json @endpoint, @post_json_invalid, @admin_token
            end

            it 'should return status 422' do
              expect(JSON.parse(response.body)['errors'][0]['message']) == 'email must_be_unique'
              expect(response.status).to eq 422
            end
          end
        end
      end
    end
  end
end
