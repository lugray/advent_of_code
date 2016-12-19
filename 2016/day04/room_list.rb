class RoomList
  class Room
    def initialize(encrypted_name)
      @encrypted_name = encrypted_name
    end

    def encrypted_name
      parts = @encrypted_name.split('-')
      parts = parts.first(parts.length - 1)
      parts.join('-')
    end

    def computed_checksum
      counts = Hash.new(0)
      encrypted_name.each_char do |char|
        counts[char] += 1
      end
      counts.delete("-")
      counts.to_a.sort{ |a, b| num = b[1] <=> a[1]; num == 0 ? a[0] <=> b[0] : num}.first(5).map(&:first).join
    end

    def sector_id
      @encrypted_name.split('-').last.split('[').first.to_i
    end

    def real_room?
      checksum == computed_checksum
    end

    def checksum
      @encrypted_name.split('[').last.tr(']', '')
    end

    def name
      encrypted_name.each_char.map do |character|
        if character == '-'
          ' '
        else
          ((character.ord - 'a'.ord + sector_id).modulo(26) + 'a'.ord).chr
        end
      end.join
    end
  end

  def initialize(input)
    @rooms = input.each_line.map(&:strip).reject{ |room| room == "" }.map { |room| Room.new(room) }
  end

  def sector_sum
    @rooms.select(&:real_room?).map(&:sector_id).inject(:+)
  end

  def room_list
    @rooms.select(&:real_room?).select{ |room| 'northpole object storage' == room.name }.map{ |room| "#{room.name}: #{room.sector_id}"}
  end
end

puts RoomList.new(File.open(File.dirname(__FILE__) + '/input.txt').read).sector_sum
puts RoomList.new(File.open(File.dirname(__FILE__) + '/input.txt').read).room_list
