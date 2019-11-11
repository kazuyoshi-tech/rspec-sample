require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  # describe "GET /food_enquetes" do
  #   it "works! (now write some real specs)" do
  #     get food_enquetes_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe '正常' do
  	context 'アンケートに回答する' do
  		it "回答できること" do
  			#アンケートページにアクセス
  			get "/food_enquetes/new"
  			#正常に応答することを確認します
  			expect(response).to have_http_status(200)

  			#正常に入力することを確認します
  			post "/food_enquetes", params: { food_enquete: FactoryBot.attributes_for(:food_enquete_tanaka) }

  			#リダイレクト先に移動します
  			follow_redirect!

  			#送信完了のメッセージが含まれることを検証します
  			# expect(response.body).to include "お食事に関数するアンケートを送信しました"
  		end
  	end
  end

  describe '異常' do
  	context "アンケートに回答する" do
  		it "エラーメッセージが表示されること" do
  			get "/food_enquetes/new"
  			expect(response).to have_http_status(200)

  			#異常な入力値を送信します
  			post "/food_enquetes", params: { food_enquete: { name: '' } }

  			expect(response.body).not_to include "お食事に関するアンケートを送信しました"
  		end
  	end
  end
end
