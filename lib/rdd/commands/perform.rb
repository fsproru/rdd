require 'big_query'
require 'dotenv'
Dotenv.load

module RDD
  module Commands
    class Perform
      attr_reader :before, :after, :top, :data_provider, :logger

      class PlainTextLogger
        def info(message)
          puts message
        end
      end

      module Scores
        NEW_REPO     = 10
        FORK         = 5
        MEMBER_ADDED = 3
        PULL_REQUEST = 2
        OTHER        = 1
      end

      BIG_QUERY_OPTIONS = {
        'client_id'     => ENV['BIG_QUERY_CLIENT_ID'],
        'service_email' => ENV['BIG_QUERY_SERVICE_EMAIL'],
        'key'           => File.expand_path("../../../certs/#{ENV['BIG_QUERY_KEY_FILE_NAME']}", __dir__),
        'project_id'    => ENV['BIG_QUERY_PROJECT_ID'],
        'dataset'       => ENV['BIG_QUERY_DATASET'],
      }

      def initialize(before:, after:, top:, data_provider: BigQuery::Client.new(BIG_QUERY_OPTIONS), logger: PlainTextLogger.new )
        @before        = before
        @after         = after
        @top           = top
        @data_provider = data_provider
        @logger        = logger
      end

      def execute
        log("Getting Github statistics for #{after} - #{before}")
        start_time, response, end_time = query_data_provider

        log("Results (~#{(end_time - start_time).to_i} seconds):")
        repos_and_scores = parse_data_provider_response(response)
        repos_and_scores.each do |repo, score|
          log("#{repo} - #{score} points")
        end
      end

      private

      def query_data_provider
        begin
          start_time = Time.now
          response   = @data_provider.query(query)
          end_time   = Time.now
        rescue BigQuery::Errors::BigQueryError => e
          raise RuntimeError.new("Failed to query a data provider: #{e.message}")
        end

        [start_time, response, end_time]
      end

      def query
"SELECT repo_name,
  SUM (
    CASE
      WHEN type = 'CreateEvent' THEN #{Scores::NEW_REPO}
      WHEN type = 'ForkEvent' THEN #{Scores::FORK}
      WHEN type = 'MemberEvent' THEN #{Scores::MEMBER_ADDED}
      WHEN type = 'PullRequestEvent' THEN #{Scores::PULL_REQUEST}
      ELSE #{Scores::OTHER}
    END) as sum
FROM
  (
    SELECT type,
           repo.name as repo_name
    FROM
    (TABLE_DATE_RANGE([githubarchive:day.events_],
      TIMESTAMP('#{after.to_s}'),
      TIMESTAMP('#{before.to_s}'))
    )
    WHERE
      (type='CreateEvent' AND JSON_EXTRACT(payload, '$.ref_type')='repository')
      OR type in ('ForkEvent', 'MemberEvent', 'PullRequestEvent', 'WatchEvent', 'IssuesEvent')
  )
GROUP BY repo_name
ORDER BY sum DESC
LIMIT #{top}"
      end

      def log(message)
        logger.info(message)
      end

      def parse_data_provider_response(response)
        repos_and_scores = {}
        response['rows'].each do |element|
          repo  = element['f'][0]['v']
          score = element['f'][1]['v']
          repos_and_scores[repo] = score
        end

        repos_and_scores
      end
    end
  end
end
