require 'rspec'
require_relative '../lib/stats'

describe Stats do
  subject { Stats.new([1, 4, 5, 1, 2, 2, 30, 2, 1, 1]) }
  its(:median) { should eql 2 }
  its(:mode) { should eql 1 }
  its(:average) { should eql 4.9 }
end
