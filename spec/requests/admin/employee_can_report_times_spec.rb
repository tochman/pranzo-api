# frozen_string_literal: true

RSpec.describe '/admin/timesheets', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:valid_auth_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'POST /admin/timesheets' do
    before do
      post '/admin/timesheets',
           params: {
             timesheet:
             { date: '2020-01-05', start_time: '09:00', end_time: '15:00' }
           },
           headers: valid_auth_headers
    end
    it {
      expect(response).to have_http_status 201
    }

    it 'is expected to return the start_time' do
      expect(response_json['timesheet']['start_time']).to eq '09:00'
    end

    it 'is expected to return the end_time' do
      expect(response_json['timesheet']['end_time']).to eq '15:00'
    end

    it 'is expected to return the duration' do
      expect(response_json['timesheet']['duration']).to eq '6.0'
    end
  end

  describe 'GET /admin/timesheets' do
    
  end
end