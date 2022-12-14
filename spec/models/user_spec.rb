require 'rails_helper'

RSpec.describe User, type: :model do
  it '有email' do
    user = User.new email: 'jack@x.com'
    expect(user.email).to eq 'jack@x.com'
  end
end
