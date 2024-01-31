require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organizations", type: :request do
  describe '#show' do
    before(:all) do
      Organization.destroy_all
      @setup = setup_specs("v1", "organizations")
      @resource = FactoryBot.create(:organization)
    end
    context 'when resource is found' do
      before(:all) do
        @endpoint = "#{@setup[:endpoint]}/#{@resource.id}"
      end
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "show", "allowed"
        it_behaves_like 'show'
      end

      context 'for scope admin' do
        before(:all) do
          @token = @setup[:admin_token]
        end
        include_examples "show", "forbidden"
        it_behaves_like 'show'
      end

      context 'for scope user' do
        before(:all) do
          @token = @setup[:user_token]
        end
        include_examples "show", "forbidden"
        it_behaves_like 'show'
      end
    end

    context 'when resource is not found' do
      before(:all) do
        @endpoint = "#{@setup[:endpoint]}/39754493857349875"
      end
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "show", "not_found"
        it_behaves_like 'show'
      end
    end
  end
end