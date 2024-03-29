#!/usr/bin/env ruby

require_relative 'day'

class Day16 < Day
  class Packet
    class LiteralPacket < Packet
      attr_reader :value

      def initialize(version, value)
        @version = version
        @value = value
      end

      def version_sum
        @version
      end
    end

    class OperatorPacket < Packet
      class << self
        attr_accessor :operator

        def class_for_op(&block)
          Class.new(OperatorPacket).tap { |k| k.operator = block }
        end
      end

      CLASS_TYPE = {
        0 => SumPacket = class_for_op { |values| values.sum },
        1 => ProductPacket = class_for_op { |values| values.inject(&:*) },
        2 => MinPacket = class_for_op { |values| values.min },
        3 => MaxPacket = class_for_op { |values| values.max },
        5 => GreaterThanPacket = class_for_op { |values| values.inject(&:>) ? 1 : 0 },
        6 => LessThanPacket = class_for_op { |values| values.inject(&:<) ? 1 : 0 },
        7 => EqualsPacket = class_for_op { |values| values.inject(&:==) ? 1 : 0 },
      }

      def initialize(version, packets)
        @version = version
        @packets = packets
      end

      def value
        self.class.operator.call(@packets.map(&:value))
      end

      def version_sum
        @version + @packets.map(&:version_sum).sum
      end
    end

    class << self
      def parse(bits)
        version = bits.shift(3).join.to_i(2)
        type = bits.shift(3).join.to_i(2)
        if type == 4
          value = parse_literal(bits)
          LiteralPacket.new(version, value)
        else
          length_type, length = parse_length(bits)
          sub_packets = parse_sub_packets(bits, length_type, length)
          OperatorPacket::CLASS_TYPE[type].new(version, sub_packets)
        end
      end

      def parse_literal(bits)
        parse_literal_arr(bits).join.to_i(2)
      end

      def parse_literal_arr(bits)
        continue, *group = bits.shift(5)
        return group if continue.zero?
        group + parse_literal_arr(bits)
      end

      def parse_length(bits)
        length_type = bits.shift(1).first
        length = if length_type == 0
          bits.shift(15).join.to_i(2)
        else
          bits.shift(11).join.to_i(2)
        end
        [length_type, length]
      end

      def parse_sub_packets(bits, length_type, length)
        packets = []
        case length_type
        when 0
          sub_bits = bits.shift(length)
          until sub_bits.empty? do
            packets << parse(sub_bits)
          end
        when 1
          length.times { packets << parse(bits) }
        end
        packets
      end
    end
  end

  def initialize
    @packet = Packet.parse(input.to_i(16).digits(2).reverse)
  end

  def part_1
    @packet.version_sum
  end

  def part_2
    @packet.value
  end
end

Day16.run if __FILE__ == $0
