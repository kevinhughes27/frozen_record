require 'spec_helper'

describe FrozenRecord::Base do

  describe '.base_path' do

    it 'raise a RuntimeError  on first query attempt if not set' do
      allow(Country).to receive_message_chain(:base_path).and_return(nil)
      expect {
        Country.file_path
      }.to raise_error(ArgumentError)
    end

  end

  describe '#load_records' do

    it 'processes erb' do
      country = Country.first
      expect(country.capital).to be == 'Ottawa'
    end

  end

  describe '#==' do

    it 'returns true if both instances are from the same class and have the same id' do
      country = Country.first
      second_country = country.dup

      expect(country).to be == second_country
    end

    it 'returns false if both instances are not from the same class' do
      country = Country.first
      car = Car.new(id: country.id)

      expect(country).to_not be == car
    end

    it 'returns false if both instances do not have the same id' do
      country = Country.first
      second_country = Country.last

      expect(country).to_not be == second_country
    end

  end

  describe '#attributes' do

    it 'returns a Hash of the record attributes' do
      attributes = Country.first.attributes
      expect(attributes).to be == {
        'id' => 1,
        'name' => 'Canada',
        'capital' => 'Ottawa',
        'density' => 3.5,
        'population' => 33.88,
        'founded_on' => Date.parse('1867-07-01'),
        'updated_at' => Time.parse('2014-02-24T19:08:06-05:00'),
        'king' => 'Elisabeth II',
        'nato' => true,
      }
    end

  end

  describe '`attribute`?' do

    let(:blank) { Country.new(id: 0, name: '', nato: false, king: nil) }

    let(:present) { Country.new(id: 42, name: 'Groland', nato: true, king: Object.new) }

    it 'considers `0` as missing' do
      expect(blank.id?).to be false
    end

    it 'considers `""` as missing' do
      expect(blank.name?).to be false
    end

    it 'considers `false` as missing' do
      expect(blank.nato?).to be false
    end

    it 'considers `nil` as missing' do
      expect(blank.king?).to be false
    end

    it 'considers other numbers than `0` as present' do
      expect(present.id?).to be true
    end

    it 'considers other strings than `""` as present' do
      expect(present.name?).to be true
    end

    it 'considers `true` as present' do
      expect(present.nato?).to be true
    end

    it 'considers not `nil` objects as present' do
      expect(present.king?).to be true
    end

  end

  describe '#count' do

    it 'can count objects with no records' do
      expect(Car.count).to be 0
    end

    it 'can count objects with records' do
      expect(Country.count).to be 3
    end

  end
end
