class FormatSpecifiers
    attr_reader :specifiers
    def initialize(string)
        @specifiers = []
        
        matches = string.scan(/%(\d)?\$?(@|d|D|u|U|x|X|o|O|f|e|E|g|G|c|C|s|S|p|a|A|F|ld|lx|lu|zx)/)
        matches.sort! { |a,b| a[0] <=> b[0] }
        matches.each { |match|
            @specifiers.push(match[1])
        }
    end
    
    def empty?
        @specifiers.empty?
    end
    
    def ==(other)
    self.class == other.class && self.specifiers == other.specifiers
    end

    def format_args
        args = []
        for i in 0..@specifiers.length-1 
            type = type_for_specifier(@specifiers[i])
            args.push("var#{i+1}: #{type}")
        end
        return args.join(", ")
    end

    def format_vars
        vars = []
        for i in 0..@specifiers.length-1 
            vars.push("var#{i+1}")
        end
        return vars.join(", ")
    end

    def type_for_specifier(specifier)
        case specifier
        when '@', 's', 'S'
            return "String"
        when 'd','D','u','U','x','X','o','O'
            return "Int"
        when 'f', 'F', 'e', 'E', 'g', 'G', 'a', 'A'
            return "Double"
        else
            return "AnyObject"
        end
    end

    def to_s
        @specifiers.to_s
    end
end