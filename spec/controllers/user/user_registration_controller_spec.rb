# frozen_string_literal: true

require "rails_helper"

describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe "registration" do
    context "#create" do
      subject { post(:create, params: {user: {email: "test@gmail.com", password: 123456}}, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it { expect { subject }.to change(User, :count).by(1) }
    end
    context "when params has errors" do
      subject { post(:create, params: {user: {email: "com", password: 56}}, format: :json) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end

  describe "update" do
    let!(:user2) { create(:user) }
    before { sign_in(user2) }
    subject { put(:update, params: {user: {email: "testXXX@gmail.com", password: 123456}}, format: :json) }
    it { is_expected.to have_http_status(:ok) }
    it { expect(subject.body).to include("testxxx@gmail.com") }

    context "when params are wrong" do
      subject { put(:update, params: {user: {email: "tes", password: 123456}}, format: :json) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end
end
