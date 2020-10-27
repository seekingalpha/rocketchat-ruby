require 'ostruct'

module RocketChat
  #
  # Rocket.Chat Room
  #
  class Room
    # Raw user data
    attr_reader :data

    TYPES = {
      'c' => 'public',
      'p' => 'private',
      'd' => 'IM'
    }.freeze

    #
    # @param [Hash] data Raw user data
    #
    def initialize(data)
      @data = Util.stringify_hash_keys data
    end

    # Channel ID
    def id
      data['_id']
    end

    # Channel name
    def name
      data['name']
    end

    # Channel owner
    def owner
      data['u']
    end

    def created_at
      data['ts']
    end

    def last_update
      data['_updatedAt']
    end

    def topic
      data['topic']
    end

    def description
      data['description']
    end

    def member_count
      data['usersCount']
    end

    ## AFAICT, this is BOGUS!
    ## 'usernames' does not actually appear in any Room API call,
    ## although it is falsely documented for `channels.list` at
    ##   https://docs.rocket.chat/api/rest-api/methods/channels/list
    ## Perhaps it was present in a _very_ early iteration of RC.
    ## Call `RocketChat::Messages::Room.members` instead.
    def members
      data['usernames'] || []
    end

    # Read-only status
    def read_only
      data['ro']
    end

    # Message count
    def message_count
      data['msgs']
    end

    # Last message timestamp
    def last_message
      data['lm']
    end

    # Channel type
    def type
      TYPES[data['t']] || data['t']
    end

    # System messages (user left, got invited, room renamed, etc)
    def system_messages
      data['sysMes']
    end

    def custom_fields
      @custom_fields ||= OpenStruct.new(data['customFields'])
    end

    def inspect
      format(
        '#<%s:0x%p @id="%s" @name="%s" @type="%s">',
        self.class.name,
        object_id,
        id,
        name,
        type
      )
    end
  end
end
