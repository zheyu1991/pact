require 'pact/provider/rspec'
require 'rspec/mocks'

class StubbedThing
  def self.stub_me
  end
end

class App
  def self.call env
    [200, {}, [StubbedThing.stub_me]]
  end
end

Pact.provider_states_for 'Consumer' do
  provider_state 'something is stubbed' do
    set_up do
      allow(StubbedThing).to receive(:stub_me).and_return("stubbing works")
    end
  end
end

# Include the ExampleMethods module after the provider states are declared
# to ensure the ordering doesn't matter

Pact.configure do | config |
  config.include RSpec::Mocks::ExampleMethods
end

Pact.service_provider 'Provider' do
  app { App }
end