require "rails_helper"

RSpec.describe "Organization Endpoints - v1/organizations", type: :request do
  describe '#sneak_in' do
    before(:all) do
      Organization.destroy_all
      @setup = setup_specs("v1", "organizations")
			@root = @setup[:root]
      @resource = FactoryBot.create(:organization)
    end
    context 'when resource is found' do
      before(:all) do
        @endpoint = "#{@setup[:endpoint]}/#{@resource.id}/sneak_in"
      end
      context 'for scope root' do
        before(:all) do
          @token = @setup[:root_token]
        end
        include_examples "show", "allowed"
        it_behaves_like 'show'
        it 'should set the roots organization to a new organization' do
          @root.reload
          expect(@root.organization).to eq @resource
        end
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
        @endpoint = "#{@setup[:endpoint]}/39754493857349875/sneak_in"
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