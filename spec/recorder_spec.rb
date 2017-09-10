# encoding: utf-8
require 'spec_helper'

describe Bugsnag::Breadcrumbs::Recorder do

    context "when adding breadcrumbs" do
        before do
            @recorder = Bugsnag::Breadcrumbs::Recorder.new
        end

        it "stores the breadcrumb" do
            @recorder.add_breadcrumb "Test"
            expect(@recorder.length).to eq(1)
            expect(@recorder).to include("Test")
        end

        it "does not store more than MAX_ITEMS breadcrumbs" do
            max_items = Bugsnag::Breadcrumbs::Recorder::MAX_ITEMS
            [*1..(max_items + 10)].each do |crumb|
                @recorder.add_breadcrumb crumb
            end
            expect(@recorder.length).to be <= max_items
        end

        it "wraps the breadcrumbs" do
            max_items = Bugsnag::Breadcrumbs::Recorder::MAX_ITEMS
            [*1..(max_items + 10)].each do |crumb|
                @recorder.add_breadcrumb crumb
            end
            [*11..(max_items + 10)].each do |val|
                expect(@recorder).to include(val)
            end
            [*1..10].each do |val|
                expect(@recorder).to_not include(val)
            end
        end
    end

    context "when retrieving the breadcrumbs" do
        before do
            @recorder = Bugsnag::Breadcrumbs::Recorder.new
        end

        it "yields breadcrumbs in order" do
            input = [*1..10]
            input.each do |crumb|
                @recorder.add_breadcrumb crumb
            end
            output = []
            @recorder.each do |crumb|
                output.push(crumb)
            end
            expect(output).to eq(input)
        end

        it "yields breadcrumbs in order of addition when wrapped" do
            max_items = Bugsnag::Breadcrumbs::Recorder::MAX_ITEMS
            [*1..(max_items + 10)].each do |crumb|
                @recorder.add_breadcrumb crumb
            end
            output = []
            @recorder.each do |crumb|
                output.push(crumb)
            end
            expect(output).to eq([*11..(max_items + 10)])
        end
    end
end