#!/usr/bin/env ruby

require "minitest/autorun"

module MergeSort
  def merge(left, right)
    sorted = []
    left_index, right_index = [0,0]
    (1..(left.size + right.size)).each do |_pass|
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
    sorted
  end

  module_function :merge
end

class MergeSortTest < Minitest::Test
  def test_sorted_arrays_of_equal_length
    assert_equal [1,2,3,4,5,6], MergeSort.merge([1,2,5],[3,4,6])
  end
end
