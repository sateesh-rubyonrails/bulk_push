Ruby Modules are similar to classes in that they hold a 
collection of methods, constants, and other module and class 
definitions. Modules are defined much like classes are, but 
the module keyword is used in place of the class keyword. 
Unlike classes, you cannot create objects based on modules 
nor can you subclass them; instead, you specify that you 
want the functionality of a particular module to be added to 
the functionality of a class, or of a specific object. Modules
stand alone; there is no "module hierarchy" of inheritance. 
Modules is a good place to collect all your constants in a 
central location.

Modules serve two purposes:

First they act as namespace, letting you define methods whose 
===========================
names will not clash with those defined elsewhere. The example
s p058mytrig.rb, p059mymoral.rb, p060usemodule.rb illustrates this.
# p058mytrig.rb  
module Trig  
  PI = 3.1416  
  # class methods  
  def Trig.sin(x)  
    # ...  
  end  
  def Trig.cos(x)  
    # ...  
  end  
end  
  
# p059mymoral.rb  
module Moral  
  VERY_BAD = 0  
  BAD         = 1  
  def Moral.sin(badness)  
    # ...  
  end  
end  
  
# p060usemodule.rb  
require_relative 'p058mytrig'  
require_relative 'p059mymoral'  
Trig.sin(Trig::PI/4)  
Moral.sin(Moral::VERY_BAD)  
Second, they allow you to share functionality between classes 
if a class mixes in a module, that modules instance methods 
become available as if they had been defined in the class. 
They get mixed in. The program p061mixins.rb illustrates this.
---------------------------------------------------
# p061mixins.rb  
module D  
  def initialize(name)  
    @name =name  
  end  
  def to_s  
    @name  
  end  
end  
  
module Debug  
  include D  
  # Methods that act as queries are often  
  # named with a trailing ?  
  def who_am_i?  
    "#{self.class.name} (\##{self.object_id}): #{self.to_s}"  
  end  
end  
  
class Phonograph  
  # the include statement simply makes a reference to a named module  
  # If that module is in a separate file, use require to drag the file in  
  # before using include  
  include Debug  
  # ...  
end  
  
class EightTrack  
  include Debug  
  # ...  
end  
  
ph = Phonograph.new("West End Blues")  
et = EightTrack.new("Real Pillow")  
puts ph.who_am_i?  
puts et.who_am_i?  

Ruby is a programming language that only allows single inheritance. 
This means a class can only inherit from one parent class.

However, there are a lot of situations where it would be 
advantageous to “inherit” functionality from multiple places.

Fortunately Ruby provides this functionality as Mixins. 

What is a Mixin?
A Mixin is basically just a Module that is included into a 
Class. When you “mixin” a Module into a Class, the Class will 
have access to the methods of the Module.

The methods of a Module that are mixed into a class can 
either be "Class Methods" or "Instance methods" depending on 
how you add the Mixin to the Class.

*--->) Using Modules methods as Instance Methods :-
       =========================================

To add Module methods as instance methods on a Class you 
should include the Mixin as part of the Class.

For example, imagine you had this incredibly useful Module:

module Greetings
  def hello
    puts "Hello!"
  end
 
  def bonjour
    puts "Bonjour!"
  end
 
  def hola
    puts "Hola!"
  end
end

To add these methods as instance methods on a class, you 
would simply do this:

class User
  include Greetings
end
Now you will have access to the methods on any instance of 
that Class:

philip = User.new
philip.hola
=> Hola!

But if you try to call the methods as Class Methods, you will
get an error:

User.hola
=> undefined method 'hola' for User:Class (NoMethodError)

*--->) Using Modules methods as Class Methods
       =======================================

To add Module methods as Class Methods, instead of using 
include you would use extend:
Important Note: 
1] When you extend module into class then the 
module instance methods will be added as singleton methods 
for that class. (Because by default all class methods of the class
are stored as instance methods on singleton class of that class)

Eg: -
module Base
  def hi
    p "Hi"
  end
end

class User
  extend Base
  def self.class_method
    p "This is users class method"
  end
end

p User.singleton_methods => [:class_method, :hi]

2] When you add class methods to the class then those methods
will be added to singleton class of that class.
Because of that class methods will be avilable as singleton methods.
# Accessing singleton class using self keyword.
st =  class << User
        self
      end
p st.inspect => "#<Class:User>"
p st.instance_methods(false) => [:class_method]
# Accessing singleton class using singletong_class method.
p User.singleton_class.instance_methods(false) => [:class_method] 




 
class User
  extend Greetings
end
Now you can call the methods on the Class:

User.hola!
=> Hola!
But not on an instance of the Class:
philip = User.new
philip.hola
=> undefined method 'hola' for #<User:0x007fbd5b9ae438> (NoMethodError)

*--->)Using module methods as both instance and class methods :-
      ======================================================

When you create a new instance of a Class, the initialize 
method will automatically be invoked.

When you include a Module in a Class, the included method 
will be invoked on that Module.

This makes it very easy to add both Instance Methods and 
Class Methods using a pattern you will see a lot in Ruby code.

For example, imagine we have the following Utilities module:

module Utilities
  def method_one
    puts "Hello from an instance method"
  end
 
  module ClassMethods
    def method_two
      puts "Hello from a class method"
    end
  end
end

In this example I’ve separated the Class Methods into their 
own nested module. You don’t have to name the module 
ClassMethods, but this is the convention you will see being 
used.

Next we can implement the self.included hook that will be 
automatically called whenever this module is included in a 
Class:

def self.included(base)
  base.extend(ClassMethods)
end

Eg:
module Utilities
  def self.included(base)
    base.extend(ClassMethods)
  end

  def method_one
    puts "Hello from an instance method"
  end
 
  module ClassMethods
    def method_two
      puts "Hello from a class method"
    end
  end
end

This method will receive the instance of the Clas s that is 
being instantiated. Inside of the included method we use the 
extend method to add the ClassMethods module.

Now when we include this module in a Class we have access to 
both the Instance Methods and the Class Methods.

class User
  include Utilities
end
 
User.new.method_one
=> Hello from an instance method
 
User.method_two
=> Hello from a class method

Why would you use a Mixin?

So hopefully it’s clear as to how to use a Mixin, but an 
important question is why you would want to use a Mixin?

Mixins are perfect when you want to share functionality 
between different classes. Instead of repeating the same 
code over and over again, you can simple group the common 
functionality into a Module and then include it into each 
Class that requires it.

============================================================
*-->) Include one module into another module :-
     ======================================

We can include or extend one module to another module.

include to class: When you include one module(eg: A) into another
module(eg: B) and then include this module B into class
(eg: Test) then all methods of both modules will be avilable 
as instance methods

extend to class: When you include one module(eg: A) into 
another module(eg: B) and if then extend this module B 
into class(eg: Test1) then all methods of both modules will be
avilable as class methods.

module A
  def self.included(base)
  	 puts "Calling included from module A"
  	 puts base.inspect
  end

  def mod_a_method
  	puts "module a method"
  end 
end

module B
  include A
  def mod_b_method
  	puts "module b method"
  end
end

class Test 
  include B
end

class Test1 
  extend B
end

  => mixing as instance methods :-
  ----------------------------
  t = Test.new
  t.mod_a_method
  t.mod_b_method

  => mixing as class methods :-
  ----------------------------
  t1=Test1.new
  Test1.mod_a_method
  Test1.mod_b_method
  #t1.mod_b_method => This will raise error.
==============================================================

*-->) extend one module to another module :-
      ====================================
When you extend one module(eg: A) methods to another module
(eg:B). Then module A methods will be avilable as module(i.e self) 
methods for module B and module A methods wont be avilable 
for class which is including/extending module B.

module A
  def mod_a_method
    puts "module A instance method"
  end
end

module B
  extend A
  def mod_b_method
    puts "module B  method"
  end
end

class Test
  include B
end

puts B.mod_a_method
#puts Test.mod_a_method => This will raise error
#puts Test.new.mod_a_method => This will raise error.
puts Test.new.mod_b_method

=============================================================
*--->) module/self methods on modules:-
       ==============================
if you define methods with "self." inside module then those 
methods will act as module methods for that module.We can access
those methods only by that module name. Even if we 
include/extend that module to another class/module, but still 
we cant access it from them.

Eg:-
module A
  def method
    puts "module A instance method"
  end
  def self.module_method
  	puts "module A method.Which can invoked by module A only"
  end
end
module B
  include A #Note: Here we are including module A To module B 
end

class Test
  include B
end
t = Test.new
t.method
A.module_method
#B.module_method => This will raise undefined method error.
#Test.module_method => This will raise undefined method error. 

============================================================

How You Nest Modules Matters in Ruby(i.e scope issues)
Ruby provides two different syntaxes to nest modules (and classes):

# Syntax #1
module API
  module V1
  end
end

# Syntax #2
module API::V1
end

Syntax #2 requires that API module already exists. Most 
#Rubyists know that. Besides this difference, they think that 
#these two syntaxes are interchangeable. With that line of 
#thinking, what syntax to use for nesting modules turns out to
#be a matter of preference.

But, the syntax you choose matters, which I will demonstrate 
shortly with examples that relate to how you would organize a 
versioned REST API.

Modules are just constants in Ruby, as such, regular constant 
look-up rules apply. The very first rule relates to how module
s are nested. For the purpose of this blog post, we will 
ignore regular constants and just focus on modules.

When you reference a constant in a nested context, Ruby looks 
it up inside out:

module API
  class Responder
  end

  module V1
    class Controller
      def action
        Responder.respond_with('Hello, World!')
      end
    end
  end
end

When #action gets called, Ruby will see if Responder is 
defined inside API::V1::Controller first, API::V1 second, 
API third, and finally in the top level. If it 
wasnt for this inside-out look-up, referencing Responder as 
above would not have worked. Instead, it would have to be 
referenced as API::Responder.

You can actually access the nesting information Ruby uses for 
this look-up with Module.nesting:

module API
  class Responder
  end

  module V1
    class Controller
      p Module.nesting #=> [API::V1::Controller, API::V1, API]

      def action
        Responder.respond_with('Hello, World!')
      end
    end
  end
end

Now, lets see how the look-up behavior changes when we mix in syntax #2:

module API
  class Responder
  end
end

module API::V1
  class Controller
    p Module.nesting #=> [API::V1::Controller, API::V1]

    def action
      Responder.respond_with('Hello, World!')
    end
  end
end

When #action gets called, you will now get a NameError:

NameError: uninitialized constant API::V1::Controller::Responder

This is because some nesting information gets lost when you use syntax #2. You can see this from what Module.nesting returns in the example above. As per that example, Ruby now looks for Responder inside API::V1::Controller and API::V1. It no longer looks inside API, where Responder is actually defined hence the error.
Conclusion

The syntax you use for nesting modules in Ruby should not be a matter of preference. The syntax you use could be the difference between a working program, and the one that throws an error. So choose wisely. Having said that, I prefer syntax #1.

By the way, weve explored just one aspect of how constant look-up works in Ruby in general. If you use Rails, the matters gets even more complicated with the autoloading magic. The following references will help you learn more:

> module_function :- 
-----------------
Using module_function we can access one method which is defined
in module as module method and we can also access same method 
from the class where it included/extended.

Eg: 
module Base
  def hello
    p "Hi Base Module"
  end
  module_function :hello
end 
# Here hello method is avilable as private instance method.
class User
  include Base
end
# Here hello method is avilable as private class method.
class Customer
  extend Base
end

Base.hello => Hi Base Module
# Since hello method is private calling using send.
User.new.send(:hello) => Hi Base Module
# Since hello method is private calling using send.
Customer.send(:hello) => Hi Base Module

> How to acces one module methods as module methods
and instance/class method for class :-
--------------------------------------------------------------
module Base
  def base_method
    p "Calling base method"
  end
  module Child
    def child_method
      p "Calling child method"
    end
  end
  extend Child # Here Child module is merged into Base module. So Child module methods are avilable as module methods for Base module
end

class User
  include Base
  include Base::Child # Here Child module methods are avilable as instance method for User class.
end
Here I am accessing child_method as module method for module Base
and instance method for User class.

User.new.child_method => "Calling child method"
Base.child_method => "Calling child method"


> Declaring modules Dynamically 
================================
===============================
We can define modules dynamically using Module.new
We can define methods dynamically using define_method 

msg = "Hello World"
M = Module.new do 
  define_method(:hello) do  
    puts msg
  end
  module_function :hello
end

M.hello

> Calling module methods using :: notation
Singleton methods of a module can either be called with 
dot notation (Batman.sidekick) or :: notation (Batman::sidekick).
module Batman
  def self.sidekick
    'robin'
  end
end

p Batman::sidekick
p Batman.sidekick

> extending module on object of class :- 
Here I am extending Hello module on object of Person class.

module Hello
  def say_hello
    p "My name is #{@name}"
  end
end
class Person
  def initialize(name)
    @name = name
  end
end

p = Person.new("Sateesh")
p.extend(Hello)
p.say_hello

Note: We can only extend module on object of call.
We can't include module on object of the class.'
if you try it will throw you undefined method include
on object of the class.


> Module inside module with class methods pattern :-

module M
  def self.included(obj)
    obj.extend(SingletonMethods)
  end

  def yo; 'yo yo'; end

  module SingletonMethods
    def hi; 'hey hey'; end
  end
end

class C
  include M
end

p C.new.yo
p C.hi

'yo yo'
'hey hey'

This is a common Ruby design pattern to include instance methods 
and singleton methods to a class from a single module. The 
M.included? callback method is run when M is included in C and 
enables the singleton methods to be included in the singleton 
class. This is a nifty design pattern thats used by many Ruby 
libraries and should be memorized

