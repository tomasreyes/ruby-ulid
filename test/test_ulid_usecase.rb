# coding: utf-8
# frozen_string_literal: true

require_relative 'helper'

class TestULIDUseCase < Test::Unit::TestCase
  def test_range_elements
    begin_ulid = ULID.generate
    ulid2 = begin_ulid.next
    ulid3 = ulid2.next
    ulid4 = ulid3.next
    ulid5 = ulid4.next
    end_ulid = ulid5.next

    include_end = begin_ulid..end_ulid
    exclude_end = begin_ulid...end_ulid

    assert_equal([begin_ulid, ulid2, ulid3, ulid4, ulid5, end_ulid], include_end.each.to_a)
    assert_equal([begin_ulid, ulid2, ulid3, ulid4, ulid5], exclude_end.each.to_a)

    assert_equal([begin_ulid, ulid3, ulid5], include_end.step(2).to_a)
    assert_equal([begin_ulid, ulid4], include_end.step(3).to_a)
    assert_equal([begin_ulid, end_ulid], include_end.step(5).to_a)
    assert_equal([begin_ulid, ulid3, ulid5], exclude_end.step(2).to_a)
    assert_equal([begin_ulid, ulid4], exclude_end.step(3).to_a)
    assert_equal([begin_ulid], exclude_end.step(5).to_a)
  end

  # https://github.com/kachick/ruby-ulid/issues/47
  def test_filter_ulids_by_time
    time1_1 = Time.at(1, Rational('122999.999'))
    time1_2 = Time.at(1, Rational('123456.789'))
    time1_3 = Time.at(1, Rational('124000.000'))

    time2 = Time.at(2, Rational('123456.789'))

    time3_1 = Time.at(3, Rational('122999.000'))
    time3_2 = Time.at(3, Rational('123456.789'))
    time3_3 = Time.at(3, Rational('123999.999'))
    time3_4 = Time.at(3, Rational('124000.000'))

    time4 = Time.at(4, Rational('123456.789'))

    ulids = [
      ulid1_1 = ULID.generate(moment: time1_1),
      ulid1_2 = ULID.generate(moment: time1_2),
      ulid1_3 = ULID.generate(moment: time1_3),
      ulid2 = ULID.generate(moment: time2),
      ulid3_1 = ULID.generate(moment: time3_1),
      ulid3_2 = ULID.generate(moment: time3_2),
      ulid3_3 = ULID.generate(moment: time3_3),
      ulid3_4 = ULID.generate(moment: time3_4),
      ulid4 = ULID.generate(moment: time4),
    ]

    assert_equal([ulid1_2, ulid1_3, ulid2, ulid3_1, ulid3_2, ulid3_3], ulids.grep(ULID.range(time1_2..time3_2)))
    assert_equal([ulid1_2, ulid1_3, ulid2, ulid3_1], ulids.grep(ULID.range(time1_2...time3_3)))
  end
end
