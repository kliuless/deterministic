require 'spec_helper'


# A Unit of Work for validating an address
module ValidateAddress
  extend Deterministic::Prelude::Result

  def self.call(candidate)
    errors = {}
    errors[:street] = "Street cannot be empty" unless candidate.has_key? :street
    errors[:city]   = "Street cannot be empty" unless candidate.has_key? :city
    errors[:postal] = "Street cannot be empty" unless candidate.has_key? :postal

    errors.empty? ? Success(candidate) : Failure(errors)
  end
end

describe ValidateAddress do
  include Deterministic
  subject { ValidateAddress.call(candidate)  }
  context 'sunny day' do
    let(:candidate) { {title: "Hobbiton", street: "501 Buckland Rd", city: "Matamata", postal: "3472", country: "nz"} }
    specify { expect(subject).to be_a Deterministic::Result::Success }
    specify { expect(subject.value).to eq candidate }
  end

  context 'empty data' do
    let(:candidate) { {} }
    specify { expect(subject).to be_a Deterministic::Result::Failure }
    specify { expect(subject.value).to include(:street, :city, :postal) }
  end
end
