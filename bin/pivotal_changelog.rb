#!/usr/bin/env ruby

require_relative "pivotal_changelog"

token = ENV["PIVOTAL_TOKEN"]
project_id = ENV["PIVOTAL_PROJECT_ID"]

changelog = PivotalChangelog.new(token, project_id)

changelog.call
