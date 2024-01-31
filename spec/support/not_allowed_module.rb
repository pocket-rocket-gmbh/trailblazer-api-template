RSpec.shared_examples "not_allowed_module" do
  before(:all) do
    organization = setup_organization([])
    root = setup_user_root(organization)
    root_token = login(root.email, root.password)
    get_json @endpoint, {}, root_token
  end

  it 'should return status 403' do
    expect(response.status).to eq 403
  end
end