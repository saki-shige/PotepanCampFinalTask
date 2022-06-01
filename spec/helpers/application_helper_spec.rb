require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'ページタイトル' do
    let(:default_title) { 'BIGBAG store' }

    shared_examples_for 'デフォルトタイトルが表示される' do
      it { expect(helper.title_for_header(title)).to eq(default_title) }
    end

    shared_examples_for 'titleを追加したタイトルが表示される' do
      it { expect(helper.title_for_header(title)).to eq(title + ' - ' + default_title) }
    end

    context 'titleがnilの時' do
      let(:title) { nil }

      it_behaves_like 'デフォルトタイトルが表示される'
    end

    context 'titleがemptyの時' do
      let(:title) { '' }

      it_behaves_like 'デフォルトタイトルが表示される'
    end

    context 'titleが存在するとき' do
      let(:title) { 't-shirt' }

      it_behaves_like 'titleを追加したタイトルが表示される'
    end
  end
end
