# frozen_string_literal: true

require "rails_helper"

describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe "registration" do
    context "#create" do
      subject { post(:create, params: {user: {email: "test@gmail.com", password: 123456}}, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it { expect { subject }.to change(User, :count).by(1) }
    end
  end
  context "#login" do
    let(:user) { create(:user) }
    subject { get(:index) }
    it {
      is_expected.to have_http_status(:ok)
      pp(user)
    }
  end

  describe "#sign_in" do
  end
end
