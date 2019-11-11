require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
	describe '正常系の機能' do
		context '回答する' do
			it '正しく登録できるころ　料理:やきそば food_id: 2,
			満足度:良い score: 3, 希望するプレゼント:ビール飲み放題 present_id: 1)' do

				enquete = FactoryBot.build(:food_enquete_tanaka)

				expect(enquete).to be_valid

				enquete.save

				answered_enquete = FoodEnquete.find(1);

				expect(answered_enquete.name).to eq('田中 太郎')
	            expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
	            expect(answered_enquete.age).to eq(25)
	            expect(answered_enquete.food_id).to eq(2)
	            expect(answered_enquete.score).to eq(3)
	            expect(answered_enquete.request).to eq('おいしかったです。')
	            expect(answered_enquete.present_id).to eq(1)
			end
		end
	end

    # describe '入力項目の有無' do

    # 	let(:new_enquete) { FoodEnquete.new }

    # 	context '必須入力であること' do
    #       it 'お名前が必須であること' do
    #       	# new_enquete = FoodEnquete.new
    #       	expect(new_enquete).not_to be_valid
    #       	expect(new_enquete.errors[:name]).to include(I18n.t('errors.messages.blank'))
    #       end

    #       it 'メールアドレスが必須であること' do
    #         # new_enquete = FoodEnquete.new
    #         expect(new_enquete).not_to be_valid
    #         expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.blank'))
    #       end

    #       it '登録できないこと' do
    #         # new_enquete = FoodEnquete.new

	   #      # [Point.3-4-4]保存に失敗することを検証します。
	   #      expect(new_enquete.save).to be_falsey
    #       end
    #     end
    #     context '任意入力であること' do
    #    	  it 'ご意見・ご要望が任意であること' do
    #    		# new_enquete = FoodEnquete.new
    #    		expect(new_enquete).not_to be_valid
    #    		expect(new_enquete.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
    #    	  end
    #     end
    # end

    # describe 'メールアドレスの形式' do
    # 	context '不正な形式のメールアドレスの場合' do
    # 		it 'エラーになること' do
    # 			new_enquete = FoodEnquete.new
    # 			new_enquete.mail = "tato.tanaka"
    # 			expect(new_enquete).not_to be_valid
    # 			expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.invalid'))
    # 		end
    # 	end
    # end

    describe 'アンケート回答時の条件' do
    	context 'メールアドレスを確認すること' do

    		before do
    		  FactoryBot.create(:food_enquete_tanaka)
    		end

    		it '同じメールアドレスで再び回答できないこと' do
    			# enquete_tanaka = FoodEnquete.new(
    			# 	name: '田中 太郎',
    			# 	mail: 'taro.tanaka@example.com',
    			# 	age: 25,
    			# 	food_id: 2,
    			# 	score: 3,
    			# 	request: '美味しかったです。',
    			# 	present_id: 1
    			# 	)
    			# enquete_tanaka.save

    			# re_enquete_tanaka = FoodEnquete.new(
    			# 	name: '田中 太郎',
    			# 	mail: 'taro.tanaka@example.com',
    			# 	age: 25,
    			# 	food_id: 0,
    			# 	score: 1,
    			# 	request: 'スープが緩かった',
    			# 	present_id: 0
    			# 	)

    			re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")

    			expect(re_enquete_tanaka).not_to be_valid
    			expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
    			expect(re_enquete_tanaka.save).to be_falsey
    			expect(FoodEnquete.all.size).to eq 1
    		end

    		it '異なるメールアドレスで回答できること' do
			     # [Point.3-10-1]各テストケースの最初に「田中 太郎」のテストデータを作成します。  

			    enquete_yamada = FactoryBot.build(:food_enquete_yamada)

			    expect(enquete_yamada).to be_valid
			    enquete_yamada.save
			    expect(FoodEnquete.all.size).to eq 2
		    end
		end

    	context '年齢を確認すること' do
    		it '未成年はビール飲み放題を選択すること' do
    			# enquete_ato = FoodEnquete.new(
    			# 	name: '佐藤 仁美',
    			# 	mail: 'hitomi.sato@example.com',
    			# 	age: 19,
    			# 	food_id: 2,
    			# 	score: 3,
    			# 	request: 'おいしかったです。',
    			# 	present_id: 1 #ビール飲み放題
    			# 	)

    			enquete_sato = FactoryBot.build(:food_enquete_sato)

    			expect(enquete_sato).not_to be_valid
    			expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
    		end

    		it '成人はビール飲み放題を選択できないこと' do
		        # [Point.3-5-5]未成年のテストデータを作成します。
		        # enquete_sato = FoodEnquete.new(
		        #   name: '佐藤 仁美',
		        #   mail: 'hitomi.sato@example.com',
		        #   age: 20,
		        #   food_id: 2,
		        #   score: 3,
		        #   request: 'おいしかったです。',
		        #   present_id: 1   # ビール飲み放題
		        # )

		        enquete_sato = FactoryBot.build(:food_enquete_sato, age: 20)

		        # [Point.3-5-6]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します。
		        expect(enquete_sato).to be_valid
		    end

		    it '異なるメールアドレスで回答できること' do
			        # enquete_tanaka = FoodEnquete.new(
			        #   name: '田中 太郎',
			        #   mail: 'taro.tanaka@example.com',
			        #   age: 25,
			        #   food_id: 2,
			        #   score: 3,
			        #   request: 'おいしかったです。',
			        #   present_id: 1
			        # )
			        # enquete_tanaka.save

			        FactoryBot.create(:food_enquete_tanaka)

			        # enquete_yamada = FoodEnquete.new(
			        #   name: '山田 次郎',
			        #   mail: 'jiro.yamada@example.com',
			        #   age: 22,
			        #   food_id: 1,
			        #   score: 2,
			        #   request: '',
			        #   present_id: 0
			        # )

			        enquete_yamada = FactoryBot.build(:food_enquete_yamada)

			        expect(enquete_yamada).to be_valid
			        enquete_yamada.save
			        # [Point.3-6-4]問題なく登録できます。
			        expect(FoodEnquete.all.size).to eq 2
			end
		end
	end

    describe '#adult?' do
    	it '20歳未満は成人ではないこと' do
    		foodEnquete = FoodEnquete.new
    		expect(foodEnquete.send(:adult?, 19)).to be_falsey
    	end

    	it '20歳以上は成人であること' do
    		foodEnquete = FoodEnquete.new
    		expect(foodEnquete.send(:adult?, 20)).to be_truthy
    	end
    end

    describe '共通バリデーション' do
        it_behaves_like '入力項目の有無'
        it_behaves_like 'メールアドレスの形式'
    end

    describe '共通メソッド' do
        it_behaves_like '価格の表示'
        it_behaves_like '満足度の表示'
    end
end
