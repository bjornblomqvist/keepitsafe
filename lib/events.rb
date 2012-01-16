module Events
  
  def self.included(base)
    base.extend(Events::EventClassMethods)
  end
  
  def events
    @events || {}
  end
  
  def trigger name,options = {}
    @events ||= {}
    ((@events[name.to_sym] || []) + (self.class.events[name.to_sym] || [])).each do |v|
      v.call self,options
    end
  end
  
  def register_handler name,lambda = nil, &block
    @events ||= {}
    @events[name.to_sym] ||= []
    @events[name.to_sym] << (lambda || block)
  end
  
  
  # Add code for handeling the dsl on_error,after_error,etc...
  def method_missing(sym,*args, &block)
    if sym.to_s.match(/^(on|before|after)_/)
      register_handler(sym.to_s,args.first,&block)
    else
      super
    end
  end
  
  def respond_to?(sym)
    sym.to_s.match(/^(on|before|after)_/).nil? == false || super
  end
  
  module EventClassMethods
    
    def events
      @@events
    end
    
    def self.extended(base)
      @@events ||= {}
    end
  
    def register_handler name,lambda = nil, &block
      @@events[name.to_sym] ||= []
      @@events[name.to_sym] << (lambda || block)
    end
    
    # Add code for handeling the dsl on_error,after_error,etc...
    def method_missing(sym,*args, &block)
      if sym.to_s.match(/^(on|before|after)_/)
        register_handler(sym.to_s,args.first,&block)
      else
        super
      end
    end

    def respond_to?(sym)
      sym.to_s.match(/^(on|before|after)_/).nil? == false || super
    end
    
  end
  
end