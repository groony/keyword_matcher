RSpec.describe KeywordMatcher::Prophet do
  describe 'new' do
    it 'should downcase words' do
      expect(described_class.new('UPPER LOWER').explode).to eq(%w[upper lower])
    end

    it 'should strip words' do
      expect(described_class.new("   word1  word2 \n word3  \t").explode)
        .to eq(%w[word1 word2 word3])
    end

    it 'should split camelcase text properly' do
      expect(described_class.new('БиойогСлобода8,7%десерт125г').explode)
        .to eq(%w[биойог слобода 8-7% десерт 125г])
    end

    it 'should skip words of length <= 2' do
      expect(described_class.new('*3633409 Пиво НЕВ.св.4,6% ПЭТ 1.42л').explode)
        .to eq(['пиво', 'нев', 'св', '4-6%', 'пэт', '1-42л'])
    end

    it 'should skip words with 5 or more digits' do
      expect(described_class.new('3452097 K.Ц.Хлеб ДАРНИЦ.форм.нар.325г').explode)
        .to eq(%w[k ц хлеб дарниц форм нар 325г])
    end

    it 'should not split up measures' do
      expect(described_class.new('0,3кг 0.3кг 3кг 33кг 0,3 кг 0.3 кг 33.кг').explode)
        .to eq(['0-3кг', '0-3кг', '3кг', '33кг', '0-3кг', '0-3кг', '33кг'])
    end

    it 'identify measures correctly' do
      expect(described_class.new('4 шт + 5 уп мсла=это 121 ед пр-ции/11,мл(2.г) смеси').explode)
        .to eq(%w[4шт + 5уп мсла это 121ед пр-ции 11мл 2г смеси])
    end

    it 'trim dots from measures correctly' do
      expect(described_class.new('211315079, VENUS, Сменные кассеты Swirl 4 шт.').explode)
        .to eq(%w[venus сменные кассеты swirl 4шт])
    end

    it 'phone model with plus sign' do
      expect(described_class.new('СМФ Samsung Galaxy A6+ Золотой(шт)').explode)
        .to eq(%w[смф samsung galaxy a6+ золотой шт])
    end

    it 'phone model without plus sign' do
      expect(described_class.new('СМФ Samsung Galaxy A6 Золотой(шт)').explode)
        .to eq(%w[смф samsung galaxy a6 золотой шт])
    end

    it 'should split milka' do
      expect(described_class.new('75063 ШоколадМилкаЕлкаНг100Г').explode)
        .to eq(%w[шоколад милка елка нг 100г])
    end

    it 'should split alternating Russian English' do
      expect(described_class.new('Массажер Д/Лицаscarlett Sc - Ca301f02').explode)
        .to eq(%w[массажер д лица scarlett sc - ca301f02])
    end

    it 'should split #' do
      expect(described_class.new('#Шок. Милка карам/арахис').explode)
        .to eq(%w[шок милка карам арахис])
    end

    it 'should split measure from amount' do
      expect(described_class.new('404566 Корж молочный в/с75гХЗ№5').explode)
        .to eq(%w[корж молочный в с 75г хз№5])
    end

    it 'should remove gteq five-digit' do
      expect(described_class.new('4680009030336 Горбуша "Доброфлот" Натур. 245г Ж/Б С Кольцом /Рос').explode)
        .to eq(%w[горбуша доброфлот натур 245г ж б с кольцом рос])
    end
  end
end
