module Restforce
  module Bulk
    class Result
      include Restforce::Bulk::Attributes

      attr_accessor :id, :success, :created, :error, :job_id, :batch_id, :content_type

      def initialize(attributes={}, content_type)
        assign_attributes(attributes)
        @content_type = content_type
      end

      def content
        response = Restforce::Bulk.client.perform_request(:get, "job/#{job_id}/batch/#{batch_id}/result/#{id}")
        parser   = results_parser_for(response.body).new

        parser.content_on(response.body)
      end

      protected

      def results_parser_for(body)
        case content_type
        when :csv
          Restforce::Bulk::Parser::Csv
        when :json
          Restforce::Bulk::Parser::Json
        else
          Restforce::Bulk::Parser::Xml
        end
      end
    end
  end
end
