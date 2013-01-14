require 'cinch'


bot = Cinch::Bot.new do
   configure do |c|
      c.server = "irc.freenode.org"
      c.channels = ["#5by5"]
      c.nick = "showcot"
   end
   
   on :message, "hello" do |m|
      m.reply "Hello, #{m.user.nick}"
   end
   
   on :channel do |m|
      formatted_string = m.time.to_s + ' - ' + m.user.nick + ': ' + m.message
      
      puts( formatted_string )
      
      file = File.new('./chat.log', 'a+')
      
      file.puts formatted_string
      
      file.close
      
   end
end

bot.start

