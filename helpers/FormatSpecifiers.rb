class FormatSpecifiers
    attr_reader :specifiers
    def initialize(string)
        @specifiers = []
        @tags = []
        
        matches = string.scan(/%(\d)?\$?(@|d|D|u|U|x|X|o|O|f|e|E|g|G|c|C|s|S|p|a|A|F|ld|lx|lu|zx)/)
        matches.sort! { |a,b| a[0] <=> b[0] }
        matches.each { |match|
            @specifiers.push(match[1])
        }
        tagsmatch = string.scan(/\{\{(.*?)\}\}/)
        tagsmatch.each { |match|
            @tags.push(match[0])
        }
    end
    
    def empty?
        @specifiers.empty? && @tags.empty?
    end

    def has_tags?
        !@tags.empty?
    end
    
    def ==(other)
    self.class == other.class && self.specifiers == other.specifiers && self.tags == other.tags
    end

    def format_args
        args = []
        for i in 0..@specifiers.length-1 
            type = type_for_specifier(@specifiers[i])
            args.push("_ var#{i+1}: #{type}")
        end
        @tags.each { |tag|
            args.push("#{tag}: String")
        }
        return args.join(", ")
    end

    def format_vars
        vars = []
        for i in 0..@specifiers.length-1 
            vars.push("var#{i+1}")
        end
        return vars.join(", ")
    end

    def replacement_tags
        replacements = []
        @tags.each { |tag|
            replacements.push("replacingOccurrences(of: \"{{#{tag}}}\", with: #{tag})")
        }
        return replacements.join(".")
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
        return @specifiers.to_s unless @specifiers.empty?
        @tags.to_s
    end
end