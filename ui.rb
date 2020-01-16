require "thwait"
require "io/console"

class UI
    #ui and customization data stored here
    @@a_reset = "\033[0m"
    @@f_color = {
        :black =>"\033[30m",
        :dark_blue => "\033[34m",
        :dark_green => "\033[32m",
        :dark_cyan => "\033[36m",
        :dark_red => "\033[31m",
        :dark_magenta => "\033[35m",
        :dark_yellow => "\033[33m",
        :gray => "\033[37m",
        :dark_gray => "\033[30;1m",
        :blue => "\033[34;1m",
        :green => "\033[32;1m",
        :cyan => "\033[36;1m",
        :red => "\033[31;1m",
        :magenta => "\033[35;1m",
        :yellow => "\033[33;1m",
        :white => "\033[37;1m"
    }
    @@b_color = {
        :black => "\033[40m",
        :dark_blue => "\033[44m",
        :dark_green => "\033[42m",
        :dark_cyan => "\033[46m",
        :dark_red => "\033[41m",
        :dark_magenta => "\033[45m",
        :dark_yellow => "\033[43m",
        :gray => "\033[47m",
        :dark_gray => "\033[40;1m",
        :blue => "\033[44;1m",
        :green => "\033[42;1m",
        :cyan => "\033[46;1m",
        :red => "\033[41;1m",
        :magenta => "\033[45;1m",
        :yellow => "\033[43;1m",
        :white => "\033[47;1m"
    }
    @@ui_settings = {
        #Customize the UI Here by choosing between black, dark_blue, dark_green, dark_cyan, dark_red, dark_magenta, dark_yellow, gray, dark_gray, blue, green, cyan, red, magenta, yellow and white
        :prompt => (@@b_color[:green] + @@f_color[:white]),
        :prompt_input => (@@b_color[:black] + @@f_color[:white]),
        :stopping_error => (@@b_color[:red] + @@f_color[:white]),
        :retrying_error => (@@b_color[:red] + @@f_color[:white]),
        :source => (@@b_color[:blue] + @@f_color[:white]),
        :time => (@@b_color[:yellow] + @@f_color[:black]),
        :message => (@@b_color[:black] + @@f_color[:white])
    }
    def self.winsize
        IO.console.winsize
        rescue LoadError
        return [Integer(`tput li`), Integer(`tput co`)]
    end
    def self.ui_settings
        @@ui_settings
    end
    def self.a_reset
        @@a_reset
    end
end