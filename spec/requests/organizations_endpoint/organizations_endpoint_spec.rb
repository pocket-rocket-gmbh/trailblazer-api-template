require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organization", type: :request do
  before(:all) do
    @endpoint = '/v1/organizations'
    @organization = setup_organization

    # setup users
    @root   = setup_user_root(@organization)
    @admin  = setup_user_admin(@organization)
    @user   = setup_user(@organization)

    # Login users to get tokens
    @root_token = login(@root.email, @root.password)
    @admin_token = login(@admin.email, @admin.password)
    @user_token = login(@user.email, @user.password)
  end

  context 'CRUD' do
    context 'Create' do
      before(:all) do
        @post_json = {
          "name": Faker::Company.name,
          "email": Faker::Internet.email
        }
      end

      context 'as root' do
        before(:all) do
          post_json @endpoint, @post_json, @root_token
        end

        it 'should return status 201' do
          expect(response.status).to eq 201
        end

        it 'should create the organization' do
          @new_organization = Organization.find response.parsed_body['resource']['id']

          expect(@new_organization.name).to eq @post_json[:name]
          expect(@new_organization.email).to eq @post_json[:email]
        end
      end

      context 'as admin' do
        before(:all) do
          post_json @endpoint, @post_json, @admin_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end

      context 'as user' do
        before(:all) do
          post_json @endpoint, @post_json, @user_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end
    end

    context 'Show' do
      before(:all) do
        @organization2 = FactoryBot.create(:organization)
        @endpoint = "#{@endpoint}/#{@organization2.id}"
      end

      context 'as root' do
        before(:all) do
          get_json @endpoint, {}, @root_token
        end

        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should return the organization as json' do
          body = response.parsed_body
          res = body['resource']

          expect(res['id']).to eq @organization2.id
          expect(res['email']).to eq @organization2.email
          expect(res['name']).to eq @organization2.name
          expect(res['created_at']).not_to be_nil
          expect(res['updated_at']).not_to be_nil
        end
      end

      context 'as admin' do
        before(:all) do
          get_json @endpoint, {}, @admin_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end

      context 'as user' do
        before(:all) do
          get_json @endpoint, {}, @user_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end
    end

    context 'Update' do
      before(:all) do
        @organization3 = FactoryBot.create(:organization)
        @put_json = {
          "name": "My new awesome org",
          "email": "snake@jazz.com"
        }
        @endpoint = "#{@endpoint}/#{@organization3.id}"
      end

      context 'as root' do
        before(:all) do
          put_json @endpoint, @put_json, @root_token
        end

        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should update the organization' do
          @organization3.reload
          expect(@organization3.name).to eq @put_json[:name]
          expect(@organization3.email).to eq @put_json[:email]
        end
      end

      context 'as admin' do
        before(:all) do
          put_json @endpoint, @put_json, @admin_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end

      context 'as user' do
        before(:all) do
          put_json @endpoint, @put_json, @user_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end
    end

    context 'Delete' do
      before(:all) do
        @organization4 = FactoryBot.create(:organization)
        @endpoint = "#{@endpoint}/#{@organization4.id}"
      end

      context 'as root' do
        before(:all) do
          delete_json @endpoint, {}, @root_token
        end

        it 'should return status 204' do
          expect(response.status).to eq 204
        end

        it 'should delete the organization' do
          expect(Organization.where(id: @organization4.id).count).to eq 0
        end
      end

      context 'as admin' do
        before(:all) do
          delete_json @endpoint, {}, @admin_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end

      context 'as user' do
        before(:all) do
          delete_json @endpoint, {}, @user_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end
    end
  end

  context 'Other' do
    context 'List' do
      context 'as root' do
        before(:all) do
          get_json @endpoint, {}, @root_token
        end

        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should return all organizations' do
          body = response.parsed_body
          expect(body['total_results']).to eq Organization.count
        end
      end

      context 'as admin' do
        before(:all) do
          get_json @endpoint, {}, @admin_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end

      context 'as user' do
        before(:all) do
          get_json @endpoint, {}, @user_token
        end

        it 'should return status 403' do
          expect(response.status).to eq 403
        end
      end
    end
  end
end
