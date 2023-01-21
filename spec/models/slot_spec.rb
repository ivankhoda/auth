require "rails_helper"

describe Api::SlotsController do
  describe "#create" do
    let(:user) { create(:user) }

    context "#create" do
      subject { post(:create, params: {slot: {code: "A1", name: "test", user: user}}, format: :json) }
      it { is_expected.to have_http_status(:ok) }
      it {
        pp(Slot.all)
        is_expected.to change(Slot, :count).by(1)
      }
    end
  end
end
