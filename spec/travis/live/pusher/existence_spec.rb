require 'spec_helper'
require 'travis/live/pusher/existence'

describe Travis::Live::Pusher::Existence do
  let(:existence) { described_class.new }

  describe '#occupied!' do
    it 'sets channel to occupied state' do
      existence.occupied!('foo')
      existence.occupied?('foo').should be_true

      # check new instance
      described_class.new.occupied?('foo').should be_true
    end
  end

  describe '#vacant!' do
    before do
      existence.occupied!('foo')
      existence.occupied?('foo').should be_true
    end

    it 'sets channel to vacant state' do
      existence.vacant!('foo')
      existence.occupied?('foo').should be_false

      # check new instance
      described_class.new.occupied?('foo').should be_false
    end
  end
end
