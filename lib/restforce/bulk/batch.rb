module Restforce
  module Bulk
    class Batch
      include Restforce::Bulk::Attributes

      class << self
        def create(job_id, data, operation, content_type=:json)
          builder  = builder_class_for(content_type).new(operation)

          response = Restforce::Bulk.client.perform_request(:post, "job/#{job_id}/batch", builder.transform(data, operation, content_type), content_type)
          body = (content_type == :json ? response.body : response.body.batchInfo)
          new(body, content_type)
        end

        def find(job_id, id)
          new(job_id: job_id, id: id).tap(&:refresh)
        end

        def builder_class_for(content_type)
          Restforce::Bulk::Builder.const_get(content_type.to_s.camelize)
        end
      end

      attr_accessor :id, :job_id, :state, :created_date, :system_modstamp, :number_records_processed, :number_records_failed, :state_message, :total_processing_time, :content_type

      def initialize(attributes={}, content_type=:json )
        assign_attributes(attributes)
        @content_type = content_type
      end

      def queued?
        state == 'Queued'
      end

      def in_progress?
        state == 'InProgress'
      end

      def completed?
        state == 'Completed'
      end

      def failed?
        state == 'Failed'
      end

      def not_processed?
        state == 'Not Processed'
      end

      def refresh
        response = Restforce::Bulk.client.perform_request(:get, "job/#{job_id}/batch/#{id}")
        body = (content_type == :json ? response.body : response.body.batchInfo)
        assign_attributes(body)
      end

      def results
        response = Restforce::Bulk.client.perform_request(:get, "job/#{job_id}/batch/#{id}/result")
        parser   = results_parser_for(response.body).new

        parser.results_on(response.body).map do |result|
          if content_type == :json
            Restforce::Bulk::Result.new({job_id: job_id, batch_id: id, id: result}, content_type)
          else
            Restforce::Bulk::Result.new({job_id: job_id, batch_id: id}.merge(result), content_type)
          end
        end
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
