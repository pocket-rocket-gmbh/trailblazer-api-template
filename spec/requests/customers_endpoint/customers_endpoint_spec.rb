require "rails_helper"

RSpec.describe "Customer Endpoints - v1/customers", type: :request do
  before(:all) do
    @endpoint = '/v1/customers'
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
          "code": ('a'..'z').to_a.shuffle.first(4).join.upcase,
          "company_name": Faker::Company.name
        }
      end

      shared_examples_for 'create' do
        it 'should return status 201' do
          expect(response.status).to eq 201
        end

        it 'should create the customer' do
          @new_customer = Customer.find response.parsed_body['resource']['id']

          expect(@new_customer.code).to eq @post_json[:code]
          expect(@new_customer.company_name).to eq @post_json[:company_name]
        end
      end

      context 'as root' do
        before(:all) do
          post_json @endpoint, @post_json, @root_token
        end

        it_behaves_like 'create'
      end

      context 'as admin' do
        before(:all) do
          post_json @endpoint, @post_json, @admin_token
        end

        it_behaves_like 'create'
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
        @customer2 = FactoryBot.create(:customer, organization: @organization)
        @endpoint = "#{@endpoint}/#{@customer2.id}"
      end

      shared_examples_for 'show' do
        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should return the customer as json' do
          body = response.parsed_body
          res = body['resource']

          expect(res['id']).to eq @customer2.id
          expect(res['code']).to eq @customer2.code
          expect(res['company_name']).to eq @customer2.company_name
          expect(res['created_at']).not_to be_nil
          expect(res['updated_at']).not_to be_nil
        end
      end

      context 'as root' do
        before(:all) do
          get_json @endpoint, {}, @root_token
        end

        it_behaves_like 'show'
      end

      context 'as admin' do
        before(:all) do
          get_json @endpoint, {}, @admin_token
        end

        it_behaves_like 'show'
      end

      context 'as user' do
        before(:all) do
          get_json @endpoint, {}, @user_token
        end

        it_behaves_like 'show'
      end

      context "404" do
        it "returns 404" do
          get_json "/v1/customers/999", {}, @root_token
          expect(response.status).to eq 404
        end
      end
    end

    context 'Update' do
      before(:all) do
        @customer3 = FactoryBot.create(:customer, organization: @organization)
        @put_json = {
          "company_name": "FCK CDU",
          "code": "ABC"
        }
        @endpoint = "#{@endpoint}/#{@customer3.id}"
      end

      shared_examples_for 'update' do
        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should update the customer' do
          @customer3.reload
          expect(@customer3.company_name).to eq @put_json[:company_name]
          expect(@customer3.code).to eq @put_json[:code]
        end
      end

      context 'as root' do
        before(:all) do
          put_json @endpoint, @put_json, @root_token
        end

        it_behaves_like 'update'
      end

      context 'as admin' do
        before(:all) do
          put_json @endpoint, @put_json, @admin_token
        end

        it_behaves_like 'update'
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
      shared_examples_for 'delete' do
        it 'should return status 204' do
          expect(response.status).to eq 204
        end

        it 'should delete the customer' do
          expect(Customer.where(id: @customer4.id).count).to eq 0
        end
      end

      context 'as root' do
        before(:all) do
          @customer4 = FactoryBot.create(:customer, organization: @organization)
          @endpoint = "#{@endpoint}/#{@customer4.id}"
          delete_json @endpoint, {}, @root_token
        end

        it_behaves_like 'delete'
      end

      context 'as admin' do
        before(:all) do
          @customer4 = FactoryBot.create(:customer, organization: @organization)
          @endpoint = "#{@endpoint}/#{@customer4.id}"
          delete_json @endpoint, {}, @admin_token
        end

        it_behaves_like 'delete'
      end

      context 'as user' do
        before(:all) do
          @customer4 = FactoryBot.create(:customer, organization: @organization)
          @endpoint = "#{@endpoint}/#{@customer4.id}"
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

      shared_examples_for 'list' do
        it 'should return status 200' do
          expect(response.status).to eq 200
        end

        it 'should return all customers' do
          body = response.parsed_body
          expect(body['total_results']).to eq @organization.customers.count
        end
      end

      context 'as root' do
        before(:all) do
          get_json @endpoint, {}, @root_token
        end

        it_behaves_like 'list'
      end

      context 'as admin' do
        before(:all) do
          get_json @endpoint, {}, @admin_token
        end

        it_behaves_like 'list'
      end

      context 'as user' do
        before(:all) do
          get_json @endpoint, {}, @user_token
        end

        it_behaves_like 'list'
      end
    end
  end
end
