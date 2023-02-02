# frozen_string_literal: true

require 'tty-table'

# Class to represent a regular polygon with 3 sides
class Triangle
  attr_reader :angles, :sides

  def initialize(side_a: nil, side_b: nil, side_c: nil, angle_a: nil, angle_b: nil, angle_c: nil) # rubocop:disable Metrics/ParameterLists
    @angles = { a: angle_a, b: angle_b, c: angle_c }
    @sides = { a: side_a, b: side_b, c: side_c }

    sum_angles
    @sides[:a] = 1 if known_sides.empty?
  end

  def print
    puts TTY::Table.new(
      header: ['', 'Sides', 'Angles'],
      rows: @sides.keys.map do |key|
        [key.upcase, @sides[key], @angles[key]]
      end
    ).render(:unicode, alignment: :left, padding: [0, 1])
  end

  def solve
    return self unless solvable?

    loop do
      break if solved?

      sum_angles

      nil_sides.each { |side, _v| @sides[side] = cosine_for_side(side) || sine_for_side(side) }
      nil_angles.each { |angle, _v| @angles[angle] = cosine_for_angle(angle) || sine_for_angle(angle) }
    end

    self
  end

  def solvable?
    ((known_angles.values + known_sides.values).count >= 3 &&
      known_angles.count >= 1 &&
      known_sides.count >= 1) ||
      known_sides.count == 3
  end

  def solved?
    known_sides.count + known_angles.count == 6
  end

  def known_angles
    @angles.reject { |_k, v| v.nil? }
  end

  def known_sides
    @sides.reject { |_k, v| v.nil? }
  end

  def nil_angles
    @angles.select { |_k, v| v.nil? }
  end

  def nil_sides
    @sides.select { |_k, v| v.nil? }
  end

  private

  def radians(angle)
    angle * Math::PI / 180.0
  end

  def degrees(radians)
    radians * 180 / Math::PI
  end

  def known_pairs
    known_sides.keys & known_angles.keys
  end

  def nil_pairs
    nil_sides.keys & nil_angles.keys
  end

  def pair_without?(x) # rubocop:disable Naming/MethodParameterName
    !pairs_without(x).empty?
  end

  def pairs_without(x) # rubocop:disable Naming/MethodParameterName
    known_pairs - [x]
  end

  # Pitfall: this method could return an incorrect answer with the right set of inputs. This is due
  # to the fact that sometimes there are two correct answers.
  def sine_for_angle(angle)
    return unless known_sides.key?(angle) && pair_without?(angle)

    pair = pairs_without(angle).first
    degrees(Math.asin((@sides[angle] * Math.sin(radians(@angles[pair]))) / @sides[pair])).round(2)
  end

  def sine_for_side(angle)
    return unless known_angles.key?(angle) && pair_without?(angle)

    pair = pairs_without(angle).first
    ((@sides[pair] * Math.sin(radians(@angles[angle]))) / Math.sin(radians(@angles[pair]))).round(2)
  end

  def cosine_for_side(side) # rubocop:disable Metrics/AbcSize
    return unless known_sides.except(side).keys.count == 2 && known_angles.key?(side)

    sides = @sides.except(side).values
    Math.sqrt(sides.sum { |n| n**2 } - 2 * sides.reduce(&:*) * Math.cos(radians(@angles[side]))).round(2)
  end

  def cosine_for_angle(angle) # rubocop:disable Metrics/AbcSize
    return unless known_sides.count == 3

    numerator = @sides.except(angle).values.sum { |n| n**2 } - @sides[angle]**2
    denominator = 2 * @sides.except(angle).values.reduce(&:*).to_f
    degrees(Math.acos(numerator / denominator)).round(2)
  end

  def sum_angles
    return unless known_angles.count == 2

    @angles[nil_angles.keys.first] = 180 - known_angles.values.sum
  end
end
