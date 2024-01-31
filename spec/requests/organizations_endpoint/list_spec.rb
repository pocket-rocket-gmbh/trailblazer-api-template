require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organizations", type: :request do
  describe '#list' do
    before(:all) do
      Organization.destroy_all
      @setup = setup_specs("v1", "organizations")
      @endpoint = @setup[:endpoint]
      @list = FactoryBot.create_list(:organization, 10)
      @list << @setup[:organization]
      @list << @setup[:another_organization]
    end
    context 'when ressources are found' do
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
          @model = Organization.all
        end
        include_examples "list", "allowed", 12
        it_behaves_like 'list'
      end

      context 'for scope admin' do
        before(:all) do
          @token = @setup[:admin_token]
          @model = Organization.all
        end
        include_examples "list", "forbidden"
        it_behaves_like 'list'
      end

      context 'for scope user' do
        before(:all) do
          @token = @setup[:user_token]
          @model = Organization.all
        end
        include_examples "list", "forbidden"
        it_behaves_like 'list'
      end
    end
  end
end