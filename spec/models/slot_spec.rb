require "rails_helper"

describe Api::SlotsController, type: :controller do
  describe "#create" do
    let(:user) { create(:user) }
    before { sign_in user }

    context "#create" do
      subject { post(:create, params: { code: "A1", name: "test" }, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it { expect { subject }.to change { Slot.count }.by(1) }
    end
  end
end
