# frozen_string_literal: true

class UserFinderFactory
  def initialize(provider)
    @provider = provider
  end

  def finder
    "#{@provider.titleize}UsersFinder".constantize.new
  end
end
