require 'discordrb'
require 'pry'

bot = Discordrb::Bot.new token: ENV["SNIPE_BOT_SECRET"]

$MESSAGE_HISTORY = {}
$SNIPED_MESSAGE_ID = nil

bot.message do |event|
  if event.message.content.start_with? "pls snipe"
    return if $SNIPED_MESSAGE_ID.nil?

    response = $MESSAGE_HISTORY[$SNIPED_MESSAGE_ID]

    embed = Discordrb::Webhooks::Embed.new

    event.send_embed do |embed|
      embed.title = "🤡"
      embed.add_field(name: "#{response.user.name} said", value: response.message.content)
      $MESSAGE_HISTORY = {}
      $SNIPED_MESSAGE_ID = nil
    end
  else
    $MESSAGE_HISTORY["#{event.message.id}"] = event
  end
end

bot.message_delete do |event|
  $SNIPED_MESSAGE_ID = "#{event.id}"
end

bot.run