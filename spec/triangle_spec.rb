# frozen_string_literal: true

require_relative '../triangle'

RSpec.describe Triangle, type: :class do
  context 'when 2 angles are given' do
    it 'solves for the third angle' do
      triangle = Triangle.new(angle_a: 30, angle_b: 60).solve
      expect(triangle.angles[:c]).to eq 90
    end

    it 'has angles that add up to 180' do
      triangle = Triangle.new(angle_a: 23, angle_b: 100).solve
      expect(triangle.angles.values.sum).to eq 180
    end

    it 'assumes side A' do
      triangle = Triangle.new(angle_a: 42, angle_b: 97).solve
      expect(triangle.sides[:a]).to eq 1
    end

    it 'calculates ratio of based off assumed side' do
      triangle = Triangle.new(angle_a: 42, angle_b: 97).solve
      expect(triangle.sides.values).to match_array([1, 1.48, 0.98])
    end
  end

  context 'with 2 angles and 1 side non-inclusive' do
    let(:triangle) { Triangle.new(side_b: 6, angle_a: 40, angle_b: 60).solve }

    it 'solves for angle c' do
      expect(triangle.angles[:c]).to eq 80
    end

    it 'solves for side a' do
      expect(triangle.sides[:a]).to eq 4.45
    end

    it 'solves for side c' do
      expect(triangle.sides[:c]).to eq 6.82
    end

    it 'has angles that add up to 180' do
      expect(triangle.angles.values.sum).to be_within(0.02).of(180)
    end
  end

  context 'with 2 angles and 1 side inclusive' do
    let(:triangle) { Triangle.new(side_c: 4, angle_a: 23, angle_b: 101).solve }

    it 'solves for angle c' do
      expect(triangle.angles[:c]).to eq 56
    end

    it 'solves for side a' do
      expect(triangle.sides[:a]).to eq 1.89
    end

    it 'solves for side b' do
      expect(triangle.sides[:b]).to eq 4.74
    end

    it 'has angles that add up to 180' do
      expect(triangle.angles.values.sum).to be_within(0.02).of(180)
    end
  end

  context 'with 2 sides and 1 angle non-inclusive' do
    let(:triangle) { Triangle.new(angle_b: 60, side_a: 6, side_b: 6).solve }

    it 'solves for angle a' do
      expect(triangle.angles[:a]).to eq 60
    end

    it 'solves for angle c' do
      expect(triangle.angles[:c]).to eq 60
    end

    it 'solves for side c' do
      expect(triangle.sides[:c]).to eq 6
    end

    it 'has angles that add up to 180' do
      expect(triangle.angles.values.sum).to be_within(0.02).of(180)
    end
  end

  context 'with 2 sides and 1 angle inclusive' do
    let(:triangle) { Triangle.new(side_b: 4, side_c: 5, angle_a: 30).solve }

    it 'solves for side a' do
      expect(triangle.sides[:a]).to eq 2.52
    end

    it 'solves for angle b' do
      expect(triangle.angles[:b]).to eq 52.47
    end

    it 'solves for angle c' do
      expect(triangle.angles[:c]).to eq 97.55
    end

    it 'has angles that add up to 180' do
      expect(triangle.angles.values.sum).to be_within(0.02).of(180)
    end
  end
end
