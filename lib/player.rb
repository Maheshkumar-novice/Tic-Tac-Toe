#!/usr/bin/env ruby
# frozen_string_literal: true

module TicTacToe
  # Player Class
  class Player
    attr_accessor :name, :choice

    def initialize
      @name = nil
      @choice = nil
    end
  end
end
