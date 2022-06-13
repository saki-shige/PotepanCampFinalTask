require 'rails_helper'

RSpec.feature "Potepan::Products", type: :feature do
  describe '商品詳細ページから「一覧ページに戻る」機能' do
    let(:taxon) { create(:taxon) }
    let!(:product_with_taxon) { create(:product, name: 'product_with_taxon', taxons: [taxon]) }
    let(:product_without_taxon) { create(:product, name: 'product_without_taxon') }

    context 'カテゴリーページから商品詳細ページにアクセスした場合' do
      before do
        visit potepan_category_path(taxon.id)
        click_on product_with_taxon.name
      end

      it 'taxonのカテゴリーページに戻る' do
        click_on '一覧ページに戻る'
        expect(current_path).to eq potepan_category_path(taxon.id)
      end
    end

    context 'カテゴリーページ以外から商品詳細ページにアクセスした場合' do
      context '商品がtaxonを持っている場合' do
        it 'taxonのカテゴリーページを表示する' do
          visit potepan_product_path(product_with_taxon.id)
          click_on '一覧ページに戻る'
          expect(current_path).to eq potepan_category_path(taxon.id)
        end
      end

      context '商品がtaxonを持っていない場合' do
        it 'ホームページに戻る' do
          visit potepan_product_path(product_without_taxon.id)
          click_on '一覧ページに戻る'
          expect(current_path).to eq potepan_path
        end
      end
    end
  end
end
