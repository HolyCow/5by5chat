require 'date'
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
   
      if m.action?
         formatted_string = '**' + m.time.to_s + '** - *' + m.user.nick + ' ' + m.action_message + '*  '
      else
         formatted_string = '**' + m.time.to_s + '** - **&lt;' + m.user.nick + '&gt;** ' + m.message + '  '
      end
      
      puts( formatted_string )
      
      today = Date.today
      
      file = File.new(File.expand_path('~/data/' + Time.now.strftime("%Y-%m-%d") + '-Chat-for-' + Time.now.strftime("%Y-%m-%d") + '.md'), 'a+')
      
      file.puts formatted_string
      
      file.close
      
   end
end

bot.start

