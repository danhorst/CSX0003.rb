#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

module MergeSort
  def call(array, second_array = [])
    array = array + second_array
    length = array.length
    return array if length <= 1

    Merge.call(
      call(array.slice!(0, (length / 2 + length % 2))),
      call(array)
    )
  end

  module_function :call

  def merge(left, right)
    sorted = []
    left_index = 0
    right_index = 0
    (left.size + right.size).times do
      l = left[left_index]
      r = right[right_index]

      if r.nil?
        sorted << l
        left_index += 1
        next
      end

      if l.nil?
        sorted << r
        right_index += 1
        next
      end

      if l <= r
        sorted << l
        left_index += 1
      elsif r <= l
        sorted << r
        right_index += 1
      end
    end
    sorted
  end

  module_function :merge

  class Merge
    def self.call(left, right)
      merge = new(left, right)
      merge.sorted
    end

    def initialize(left, right)
      @left_index, @right_index = [0, 0]
      @sorted = []

      (left.size + right.size).times do
        @l = left[left_index]
        @r = right[right_index]

        add_left  && next if @r.nil?
        add_right && next if @l.nil?

        add_left  && next if l <= r
        add_right         if r < l
      end
    end

    attr_reader :sorted

    private

    def add_left
      @sorted << l
      @left_index += 1
    end

    def add_right
      @sorted << r
      @right_index += 1
    end

    attr_accessor :l, :left_index, :r, :right_index
  end

end

class MergeSortTest < Minitest::Test
  # The initial, proivded scinero doesn't require a full merge-sort as the
  # provided arrays are each already sorted
  def test_sorted_arrays_of_equal_length
    sorted = [1, 2, 3, 4, 5, 6]
    assert_equal sorted, MergeSort.merge([1, 2, 5], [3, 4, 6])
    assert_equal sorted, MergeSort::Merge.call([1, 2, 5], [3, 4, 6])
    assert_equal sorted, MergeSort.call([1, 2, 5], [3, 4, 6])
  end

  def test_sorted_arrays_of_unequal_length
    sorted = [1, 2, 3, 4, 5, 6, 7]
    assert_equal sorted, MergeSort.merge([1, 2, 5, 7], [3, 4, 6])
    assert_equal sorted, MergeSort::Merge.call([1, 2, 5, 7], [3, 4, 6])
    assert_equal sorted, MergeSort.call([1, 2, 5, 7, 3, 4, 6])
  end

  # It gets more complicated with unsorted input
  def test_unsorted_array_of_even_length
    assert_equal [1, 2, 3, 4, 5, 6], MergeSort.call([5, 1, 2, 4, 3, 6])
  end

  def test_unsorted_array_of_odd_length
    assert_equal [1, 2, 3, 4, 5, 6, 7], MergeSort.call([5, 1, 2, 7, 4, 3, 6])
  end

  def test_unsorted_array_of_odd_length_with_duplicates
    assert_equal [1, 2, 3, 3, 4, 5, 6, 7, 7], MergeSort.call([3, 5, 1, 2, 4], [7, 7, 3, 6])
  end
end
