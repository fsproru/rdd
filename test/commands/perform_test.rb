require 'test_helper'
require 'rdd/commands/perform'
require 'active_support/time'

module RDD::Commands
  class PerformTest < Minitest::Test
    class FakeDataProvider
      def query(sql)
      end
    end

    def setup
      @before        = DateTime.parse('2015-10-31')
      @after         = DateTime.parse('2015-10-25')
      @top           = 10
      @data_provider = FakeDataProvider.new
      @logger        = Minitest::Mock.new
      @response = {
        "rows" => [
          {
            "f" => [
              { "v" => "Gooru/Gooru-Core-API" },
              { "v" => "280" }
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
              { "v" => "rxantos/tubras" },
              { "v" => "20" }
            ]
          }
        ]
      }

      @command = Perform.new(before: @before, after: @after, top: @top, data_provider: @data_provider, logger: @logger)
    end

    def test_calls_bigquery_with_the_right_date_range
      @logger.expect(:info, nil, ['Getting Github statistics for 2015-10-25T00:00:00+00:00 - 2015-10-31T00:00:00+00:00'])
      @logger.expect(:info, nil, ['Results (~0 seconds):'])
      @logger.expect(:info, nil, ['Gooru/Gooru-Core-API - 280 points'])
      @logger.expect(:info, nil, ['ElementalKiss/Test - 221 points'])
      @logger.expect(:info, nil, ['stackwalker/docker-test - 20 points'])
      @logger.expect(:info, nil, ['rxantos/tubras - 20 points'])

      @data_provider.stub(:query, @response) do
        repos = @command.execute
        assert_equal({"Gooru/Gooru-Core-API"=>"280", "ElementalKiss/Test"=>"221", "stackwalker/docker-test"=>"20", "rxantos/tubras"=>"20"}, repos)
      end

      @logger.verify
    end
  end
end
