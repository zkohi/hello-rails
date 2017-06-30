require 'rails_helper'
require 'support/factory_girl'

RSpec.describe Blog, type: :model do

  subject { blog.valid? }

  context 'with title' do
    let(:blog) { build(:blog) }

    it { is_expected.to be_truthy }
  end
  context 'without title' do
    let(:blog) { build(:blog, title: '') }

    it { is_expected.to be_falsy }
  end
end
