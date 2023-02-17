# frozen_string_literal: true

require "rails_helper"
require "json"

describe Users::SessionsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  let!(:user) { create(:user) }

  let(:url) { "login" }
  let(:params) do
    {
      user: {
        login: user.email,
        password: user.password
      }
    }
  end
  describe "login" do
    context "when params are correct" do
      subject { post(:create, params: { user: { email: user.email, password: user.password } }, format: :json) }

      it { expect(subject).to have_http_status(200) }

      it "returns JTW token in response body" do
        expect(JSON[subject.body]["jwt"]).to be_present
        expect(subject.headers["jwt"]).to be_present
      end

      it "returns valid JWT token" do
        decoded_token = JWT.decode(JSON[subject.body]["jwt"], Rails.application.secret_key_base, true)
        expect(decoded_token).to be_present
      end
    end

    context "when login params are incorrect" do
      subject { post(:create, params: {user: {email: "not_exists@example.com", password: "AaBbCcDd"}}, format: :json) }

      it "returns unathorized status" do
        expect(subject.status).to eq 401
      end
    end
    context "when not json" do
      subject { post(:create, params: {user: {email: "not_exists@example.com", password: "AaBbCcDd"}}) }

      it "returns not acceptable status" do
        expect(subject.status).to eq 406
      end
    end
  end

  describe "logout" do
    context "signed in user" do
      before do
        sign_in(user)
      end
      subject { delete(:destroy) }
      it { expect(subject.status).to eq(200) }
      it { expect(JSON[subject.body]["message"]).to eq("Successfully signed out.") }
    end
  end
  context "not signed in user" do
    subject { delete(:destroy) }
    it { expect(subject.status).to eq(401) }
    it { expect(JSON[subject.body]["message"]).to eq("You are not authorized.") }
  end
end
