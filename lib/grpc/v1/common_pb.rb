# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: common.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("common.proto", :syntax => :proto3) do
    add_message "v1.common_pb.Pager" do
      optional :page, :int64, 1
      optional :page_size, :int64, 2
      optional :total_rows, :int64, 3
    end
  end
end

module V1
  module CommonPb
    Pager = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("v1.common_pb.Pager").msgclass
  end
end