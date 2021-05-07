# coding: utf-8
# frozen_string_literal: true

require_relative 'helper'

# Just to confirm `current behavior` for some testing reasons. Basically does not support subclass behaviors.
class TestULIDSubClass < Test::Unit::TestCase
  class Subclass < ULID
  end

  def setup
    @actual_timezone = ENV['TZ']
    ENV['TZ'] = 'EST' # Just chosen from not UTC and JST
  end

  def test_ensure_testing_environment
    assert_equal(Encoding::UTF_8, ''.encoding)
    assert_equal('EST', Time.now.zone)
  end

  def test_generators_return_own_instance_and_does_not_raise_in_some_basic_comparison
    ulid = ULID.sample
    [
      Subclass.sample,
      Subclass.generate,
      Subclass.parse('01ARZ3NDEKTSV4RRFFQ69G5FAV'),
      Subclass.at(Time.now),
      Subclass.from_integer(42),
      Subclass.from_uuidv4(SecureRandom.uuid)
    ].each do |instance|
      assert_not_instance_of(ULID, instance)
      assert_instance_of(Subclass, instance)
      assert_equal(true, ULID === instance)
      assert_boolean(ulid == instance)
      assert_boolean(ulid === instance)
      assert_boolean(ulid.eql?(instance))
      assert_boolean(ulid.equal?(instance))
      assert_equal(true, [0, 1, -1].include?(ulid <=> instance))
    end
  end

  def teardown
    ENV['TZ'] = @actual_timezone
  end
end