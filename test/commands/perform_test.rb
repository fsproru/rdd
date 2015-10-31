require 'test_helper'
require 'rdd/commands/perform'
require 'active_support/time'

module RDD::Commands
  class PerformTest < Minitest::Test
    class FakeDataProvider
      def query(sql)
      end
    end

    def test_calls_bigquery_with_the_right_date_range
      before = 5.days.ago
      after  = Time.now
      top    = 10
      data_provider = FakeDataProvider.new
      response = {
        "rows" => [
          {
            "f" => [
              { "v" => "rxantos/tubras" },
              { "v" => "20" }
            ]
          },
          {
            "f" => [
              { "v" => "ElementalKiss/Test" },
              { "v" => "221" }
            ]},
          {
            "f" => [
              { "v" => "stackwalker/docker-test" },
              { "v" => "20"}
            ]},
          {
            "f" => [
              { "v" => "Gooru/Gooru-Core-API" },
              { "v" => "280" }
            ]
          }
        ]
      }

      command = Perform.new(before: before, after: after, top: top, data_provider: data_provider)

      data_provider.stub(:query, response) do
        repos = command.execute
        assert_equal({"rxantos/tubras"=>"20", "ElementalKiss/Test"=>"221", "stackwalker/docker-test"=>"20", "Gooru/Gooru-Core-API"=>"280"}, repos)
      end
    end
  end
end
