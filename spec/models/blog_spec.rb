require 'rails_helper'
require 'support/factory_girl'

RSpec.describe Blog, type: :model do

  subject { blog }

  context 'with title' do
    let(:blog) { FactoryGirl.build(:blog) }

    it { is_expected.to be_valid }
  end
  context 'without title' do
    let(:blog) { FactoryGirl.build(:blog, title: '') }

    it { is_expected.not_to be_valid }
  end
end
