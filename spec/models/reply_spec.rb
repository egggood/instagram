require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:reply) { create(:reply) }

  it "has valid Factory" do
    expect(reply).to be_valid
  end

  it "failds to save without a content" do
    reply.content = ""
    reply.valid?
    expect(reply.errors[:content]).to include("can't be blank")
  end

  it "failds to save with a content containig than 140 character" do
    reply.content = "a" * 141
    reply.valid?
    expect(reply.errors[:content]).to include("is too long (maximum is 140 characters)")
  end
end
