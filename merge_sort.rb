#!/usr/bin/env ruby

require "minitest/autorun"

module MergeSort
  def call(array)
    puts "Input: #{array.inspect}"
    length = array.length
    return array if length <= 1

    half = Integer(length / 2.0)
    remainder = length % 2

    self.merge(
      self.call(array.slice(0, (half + remainder))),
      self.call(array[(half * -1), half])
    )
  end

  module_function :call

  def merge(left, right)
    sorted = []
    left_index, right_index = [0,0]
    (1..(left.size + right.size)).each do
      l = left[left_index]
      r = right[right_index]

      sorted << l && next unless r
      sorted << r && next unless l

      if l < r
        sorted << l
        left_index += 1
      elsif r < l
        sorted << r
        right_index += 1
      end
    end
    puts "Sorted: #{sorted}"
    sorted
  end

  module_function :merge
end

class MergeSortTest < Minitest::Test
  # The initial, proivded scinero doesn't require a full merge-sort as the
  # provided arrays are each already sorted
  def test_sorted_arrays_of_equal_length
    assert_equal [1,2,3,4,5,6], MergeSort.merge([1,2,5],[3,4,6])
  end

  def test_sorted_arrays_of_unequal_length
    assert_equal [1,2,3,4,5,6,7], MergeSort.merge([1,2,5,7],[3,4,6])
  end

  # It gets more complicated with unsorted input
  def test_unsorted_array_of_even_length
    assert_equal [1,2,3,4,5,6], MergeSort.call([5,1,2,4,3,6])
  end

  def test_unsorted_array_of_odd_length
    assert_equal [1,2,3,4,5,6,7], MergeSort.call([5,1,2,7,4,3,6])
  end
end
