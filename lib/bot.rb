require 'date'
require 'cinch'
require 'data_mapper'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://vagrant:vagrant@localhost/5by5chatbot')

class Message
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :user,       String    
  property :type,       String    # A varchar type string, for short strings
  property :message,    Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

DataMapper.finalize

DataMapper.auto_upgrade!

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
         Message.create(
            :user => m.user.nick,
            :type => 'action',
            :message => m.action_message,
            :created_at => m.time
         )
      else
         formatted_string = '**' + m.time.to_s + '** - **&lt;' + m.user.nick + '&gt;** ' + m.message + '  '
         Message.create(
            :user => m.user.nick,
            :type => 'message',
            :message => m.message,
            :created_at => m.time
         )
      end
      
      puts( formatted_string )
      
   end
end

bot.start

