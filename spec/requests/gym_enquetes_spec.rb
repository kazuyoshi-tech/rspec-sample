require 'rails_helper'

RSpec.describe "GymEnquetes", type: :request do
  # describe "GET /gym_enquetes" do
  #   it "works! (now write some real specs)" do
  #     get gym_enquetes_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe '正常' do
  	context "アンテートに回答する" do
  		it "ページが表示されないこと " do
  			get "/gym_enquetes/new"
  			expect(response).to have_http_status(404)
  		end
  	end
  end
end
