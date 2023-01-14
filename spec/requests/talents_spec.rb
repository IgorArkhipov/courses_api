# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Talents' do
  let(:headers) { { 'Accept' => JSONAPI::MEDIA_TYPE, 'Content-Type' => JSONAPI::MEDIA_TYPE } }

  before do
    author = create(:author)
    talent = create(:talent)
    course = create(:course, author: author)
    create(:talent_course, talent: talent, course: course)
  end

  describe 'GET #talents' do
    context 'when requesting a list of talents' do
      before do
        get talents_url, headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct talents' do
        expect(json_parsed[:data].size).to eq(User.count)
      end

      it 'returns correct relationship' do
        expect(json_parsed[:data].first[:relationships].key?(:courses)).to be true
      end
    end

    context 'when requesting a list of courses taken by the talent' do
      let(:talent) { User.find_by(is_author: false) }

      before do
        get talent_related_courses_url(talent_id: talent.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns correct courses' do
        expect(json_parsed[:data].size).to eq(talent.courses.count)
      end
    end
  end

  describe 'POST #talents' do
    context 'when creating a talent' do
      let(:valid_params) do
        '{"data":{"type":"talents","attributes":{"name":"Tttest","email":"tttest@mail.com"}}}'
      end

      before do
        post talents_url, headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct courses' do
        expect(json_parsed[:data][:attributes][:name]).to eq('Tttest')
      end
    end
  end

  describe 'PUT #talent' do
    context 'when updating a talent' do
      let(:talent) { User.find_by(is_author: false) }
      let(:valid_params) do
        "{\"data\":{\"id\":#{talent.id},\"type\":\"talents\",\"attributes\":{\"name\":\"TTnew\"}}}"
      end

      before do
        put talent_url(id: talent.id), headers: headers, params: valid_params
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns updated talent' do
        expect(json_parsed[:data][:attributes][:name]).to eq('TTnew')
      end
    end
  end

  describe 'DELETE #talent' do
    context 'when deleting a talent' do
      let(:talent) { User.find_by(is_author: false) }

      before do
        delete talent_url(id: talent.id), headers: headers
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
