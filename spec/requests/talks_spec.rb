require 'rails_helper'

RSpec.describe "/talks", type: :request do
  let(:talk) { create(:talk) }

  let(:valid_attributes) {
    attributes_for(:talk, title: 'Valid Title', description: 'this text is valid.')
  }

  let(:invalid_attributes) {
    attributes_for(:talk, title: "#{ 'test'*100 } Invalid Title", description: '')
  }

  before do
    create(:membership, user: talk.user, group: talk.group)
    sign_in talk.user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get group_talks_url(talk.group)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get group_talk_url(talk.group, talk)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_group_talk_url(talk.group)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_group_talk_url(talk.group, talk)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Talk" do
        expect {
          post group_talks_url(talk.group), params: { talk: valid_attributes }
        }.to change(Talk, :count).by(1)
      end

      it "redirects to the created talk" do
        post group_talks_url(talk.group), params: { talk: valid_attributes }
        expect(response).to redirect_to(group_talk_url(talk.group, Talk.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Talk" do
        expect {
          post group_talks_url(talk.group), params: { talk: invalid_attributes }
        }.not_to change(Talk, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post group_talks_url(talk.group), params: { talk: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        attributes_for(:talk, title: 'New Title', description: 'New Text')
      }

      it "updates the requested talk and redirects to the talk" do
        patch group_talk_url(talk.group, talk), params: { talk: new_attributes }
        talk.reload

        expect(talk.title).to eq 'New Title'
        expect(talk.description).to eq 'New Text'
        expect(response).to redirect_to(group_talk_path(talk.group, talk))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch group_talk_url(talk.group, talk), params: { talk: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested talk and redirects to the talks list" do
      group = talk.group
      expect {
        delete group_talk_url(talk.group, talk)
      }.to change(Talk, :count).by(-1)

      expect(response).to redirect_to(group_talks_url(group))
    end
  end
end
