# frozen_string_literal: true

RSpec.describe 'POST /api/vendors', type: :request do
  let!(:existing_user) { create(:user, email: 'existing_user@mail.com') }
  describe 'with valid attributes and address' do # Not a valid use case
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com',
               addresses_attributes: [{
                 street: 'High Street 190',
                 post_code: '90900',
                 city: 'Lucasville',
                 country: 'USA'
               }, {
                 street: 'Low Street 190',
                 post_code: '80000',
                 city: 'York',
                 country: 'USA'
               }]
             },
             user: {
               name: 'Karl Andersson',
               email: 'karl@mail.com',
               password: 'password',
               password_confirmation: 'password'
             }
           },
           headers: {}
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2 # TODO: There is a system user created every time a Vendor is instantiated
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Restaurant'
    end

    it 'is expected to save vendor address in database' do
      expect(Vendor.last.addresses.first.street).to eq 'High Street 190'
    end

    it 'is expected to save all vendor addresses in database' do
      expect(Vendor.last.addresses.count).to eq 2
    end
  end

  # describe 'without valid vendor attributes' do
  #   before do
  #     post '/api/vendors',
  #          params: {
  #            vendor: {
  #              name: 'The Restaurant',
  #              description: '',
  #              primary_email: ''
  #            },
  #            user: {
  #              name: '',
  #              email: '',
  #              password: '',
  #              password_confirmation: ''
  #            }
  #          },
  #          headers: {}
  #   end

  #   it {
  #     expect(response).to have_http_status 422
  #   }

  #   it 'is expected to respond with error message' do
  #     expect(response_json)
  #       .to have_key('message')
  #       .and have_value("Description can't be blank and Primary email can't be blank and remember to create a user account for yourself")
  #   end
  # end

  describe 'Created by a Superadmin (TODO: this is with flaws!)' do
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com'
             },
             user: {
               name: 'Existing User',
               email: 'existing_user@mail.com',
               password: 'password',
               password_confirmation: 'password'
             }
           },
           headers: {} #we need to authenticate the admin
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2 # TODO: There is a system user created every time a Vendor is instantiated
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Restaurant'
    end
  end

  describe 'without user attributes but authenticated' do
    let(:credentials) { existing_user.create_new_auth_token }
    let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
    before do
      post '/api/vendors',
           params: {
             vendor: {
               name: 'The Other Restaurant',
               description: 'The best food in this shithole town....',
               primary_email: 'the_restaurant@mail.com'
             }, user: {}
           },
           headers: valid_auth_headers
    end

    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to respond with representation of the new resource' do
      expect(response_json['vendor']['users'].count).to eq 2 # TODO: There is a system user created every time a Vendor is instantiated
    end

    it 'is expected to have associated users' do
      expect(Vendor.last.users.count).to eq 2
    end

    it 'is expected to save vendor in database' do
      expect(Vendor.last.name).to eq 'The Other Restaurant'
    end
  end
end