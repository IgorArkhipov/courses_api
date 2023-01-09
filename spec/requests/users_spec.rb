# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  let(:headers) { { 'Accept' => JSONAPI::MEDIA_TYPE, 'Content-Type' => JSONAPI::MEDIA_TYPE } }

  before do
    author = create(:author)
    talent = create(:talent)
    course = create(:course, author: author)
    create(:talent_course, talent: talent, course: course)
  end

  describe 'GET #users' do
    context 'when requesting a list of users' do
      before do
        get users_url, headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct users' do
        expect(json_parsed[:data].size).to eq(User.count)
      end

      it 'returns correct first relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:'authored-courses')).to be true
      end

      it 'returns correct second relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:courses)).to be true
      end
    end

    context 'when requesting a list of courses taken by the user' do
      let(:talent) { User.find_by(is_author: false) }

      before do
        get user_related_courses_url(user_id: talent.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct courses' do
        expect(json_parsed[:data].size).to eq(talent.courses.count)
      end
    end

    context 'when requesting a list of courses authored by the user' do
      let(:author) { User.find_by(is_author: true) }

      before do
        get user_related_authored_courses_url(user_id: author.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct courses' do
        expect(json_parsed[:data].size).to eq(author.authored_courses.count)
      end
    end
  end

  describe 'POST #users' do
    context 'when creating a user' do
      let(:valid_params) do
        '{"data":{"type":"users","attributes":{"name":"Tttest","email":"tttest@mail.com","is-author":false}}}'
      end

      before do
        post users_url, headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct courses' do
        expect(json_parsed[:data][:attributes][:name]).to eq('Tttest')
      end
    end
  end

  describe 'PUT #user' do
    context 'when updating a user' do
      let(:author) { User.find_by(is_author: true) }
      let(:valid_params) do
        "{\"data\":{\"id\":#{author.id},\"type\":\"users\",\"attributes\":{\"name\":\"TTnew\"}}}"
      end

      before do
        put user_url(id: author.id), headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns updated user' do
        expect(json_parsed[:data][:attributes][:name]).to eq('TTnew')
      end
    end
  end

  describe 'DELETE #user' do
    context 'when deleting a user' do
      let(:author) { User.find_by(is_author: true) }

      before do
        delete user_url(id: author.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
