require "active_record"
require "foxy_fixtures/extensions/fixtures"

FOXY_SUPPORTED_ADAPTERS = %w(mysql sqlite)

FOXY_SUPPORTED_ADAPTERS.each do |adapter|
  require "foxy_fixtures/extensions/active_record/connection_adapters/#{adapter}_adapter"
end
