Slack.configure do |config|
  config.token = Rails.application.credentials.dig(:slack)
  # config.token = "xoxp-123-456"
end
