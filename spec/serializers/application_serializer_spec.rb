require "rails_helper"

describe ApplicationSerializer do
  let!(:user) { create(:user) }
  let!(:slot) { create(:slot, user: user) }
  let(:item) { create(:item, user: user, slot: slot) }
  subject { described_class.new(item).execute }
  describe "#execute" do
    it { expect { subject }.to raise_error(NotImplementedError) }
  end
end
