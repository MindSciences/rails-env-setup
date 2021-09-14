require 'spec_helper'
require 'env_setup/builder/json'

RSpec.describe EnvSetup::Builder::Json do
  let(:builder) { described_class.new(value, params) }
  let(:params) { {} }
  let(:value) do
    {
      'some' => {
        'custom' => 'data'
      }
    }
  end

  it 'generates json string format' do
    expect(builder.call).to eq "{\"some\"=>{\"custom\"=>\"data\"}}"
  end
end
