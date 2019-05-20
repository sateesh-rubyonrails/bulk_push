1. eval :-
> The module Kernel has the eval() method and is used to 
execute code in a string. 

> calling eval() effectively compiles the code in the string 
before executing it. 
> But, even worse, eval() can be dangerous.
If theres any chance that external data - stuff that comes 
from outside your application - can wind up inside the 
parameter to eval(), then you have a security hole, because 
that external data may end up containing arbitrary code that 
your application will blindly execute. 
> eval() is now considered a method of last resort.
> eval Receives string as argument and run it as a Ruby code.

name = "Hello World"
puts eval "name"

Optionally you can pass a context which eval operates on 
with binding.

def get_binding
  binding
end

class Klass
  def initialize
    @var = 42
  end

  def self.class_func
    11
  end

  def get_binding
    binding
  end
end

puts self                                 #=> main
puts eval('self', get_binding)            #=> main
puts eval('self', Klass.new.get_binding)  #=> #<Klass:0x007f77d1161728>
puts eval('@var', Klass.new.get_binding)  #=> 42

=============================================================
2. class_eval :- We can use class_eval to define instance 
methods on that class.

Eg:-

class Person
end

Person.class_eval do
  def say_hello
   "Hello!"
  end
end

jimmy = Person.new
jimmy.say_hello # "Hello!"

The module_eval and class_eval methods operate on modules and 
classes rather than on objects. The class_eval is defined as 
an alias of module_eval.

> The module_eval and class_eval methods can be used to add and 
retrieve the values of class variables from outside a class.

class Rubyist
  @@geek = "Ruby's Matz"
end
puts Rubyist.class_eval("@@geek") # => Ruby's Matz

> The module_eval and class_eval methods can also be used to 
add instance methods to a module and a class. In spite of 
their names, module_eval and class_eval are functionally 
identical and each may be used with ether a module or a class.

class Rubyist
end
Rubyist.class_eval do
  def who
    "Geek"
  end
end
obj = Rubyist.new
puts obj.who # => Geek

Note: class_eval defines instance methods, and instance_eval 
defines class methods.

Eg2 :- I am creating attribute_accessors method which
whill create read and write methods.

Object.class_eval do # its going to create instance methods.
  class << self # It will define class method
    def attribute_accessors(*attribute_names)
      attribute_names.each do |attribute_name|
        class_eval %Q&  #its going to create instance methods.
          def #{attribute_name}
            @#{attribute_name}
          end
          def #{attribute_name}=(new_value)
            @#{attribute_name} = new_value
          end
        &
      end
    end
  end
end

class Dog
  attribute_accessors :name
end

d = Dog.new
d.name = "Bow! Bow!"
p d.name

Eg2:-
class MyClass
end
MyClass.class_eval do
  def instance_method
    puts "In an instance method"
  end
end
obj = MyClass.new
obj.instance_method
produces:
In an instance method


Eg 3:-
 class Klass
 end
 
 Klass.class_eval do |obj|
   puts obj #=> Klass
   def another_instance_method
     14
   end
 end
 
 puts Klass.new.another_instance_method # returns 14
 
**--> class_exec :-
================
class_exec allows you to pass an argument to a block.

Klass.class_exec(1) do |obj|
  puts obj                  #=> 1 (or nil if no arguments passed to class_exec)
  def yet_another_func
    18
  end
end
puts Klass.new.yet_another_func #=> 18
 

# because class_{exec,eval} opens `Klass` itlelf any 
#@variables are class instance variables (like instance_exec 
#on a class)
# but any methods defined are instance methods
Klass.class_exec(1) do |obj|
  @_obj = obj
  puts @_obj                    #=> 1
  def yet_another_func1
    @_obj
  end
end
puts Klass.new.yet_another_func1 #=> nil
puts Klass.instance_variables    #=> @_obj

 
 
class_eval and instance_eval both set self for the duration of
the block. However, they differ in the way they set up the 
environment for method definition. 
class_eval sets things up as if you were 'in the body of a 
class definition', so method definitions will define instance
methods.

Why class_eval creates instance methods ?
-------------------------------------------
class_eval is a method of the "Module class", meaning that the 
receiver will be a module or a class. The block you pass to 
class_eval is evaluated in the context of that class. 
Defining a method with the standard def keyword within a 
class defines an instance method, and thats exactly what 
happens here.
==============================================================

3. instance_eval :-
=====================

We can use instance_eval to define class methods. 

the instance_eval method assigns self to the receiver in 
the block, thus providing access to the receiver’s 
instance variables, public methods, and private methods.
i.e we can access instance variables, private methods from
outside class using instance_eval.
Eg1 :-
class KlassWithSecret
  def initialize
    @secret = 99
  end
  private
  def hello
    "This is private method"
  end
end
k = KlassWithSecret.new
p k.instance_eval { @secret }   #=> 99
p k.instance_eval { hello } #=> This is private method

Eg2:- Defining class methods using instance_eval.

class Person
end
Person.instance_eval do 
  def human?
    true
  end
end
p Person.human?

Eg3: -
"cat".instance_eval do
  puts "Upper case = #{upcase}"
  puts "Length is #{self.length}"
end
produces:
Upper case = CAT
Length is 3

Both forms also take a string

Eg4: - Defining methods by passing string as argument to instance_eval
"cat".instance_eval('puts "Upper=#{upcase}, length=#{self.length}"')
produces:
Upper=CAT, length=3

Eg5:-
class Klass
  def initialize
    @var = 42
  end

  def self.class_func
    11
  end

  def get_binding
    binding
  end
end


instance_eval Allows you to operate on object with self set 
to this object.It also can accept block instead of string to 
evaluate it. Somewhat similar to eval with binding.

# self is also passed as a block argument
Klass.new.instance_eval do |obj|
  puts @var             #=> 42
  puts self             #=> #<Klass:0x007f0c71f4d7e0>
  puts obj == self      #=> true
end

# Class itself in an instance of class `Class`
Klass.instance_eval do |obj|
  puts class_func       #=> 11
  puts self             #=> Klass
  puts obj == self      #=> true
end

# works with string too
Klass.new.instance_eval "puts @var" #=> 42

**-->instance_exec :-
====================
Similar to instance_eval, but also allows you to pass an 
argument to a block.

# instance_exec can pass an argument(s)
Klass.new.instance_exec(1, 2) do |obj1, obj2|
  puts @var             #=> 42
  puts self             #=> #<Klass:0x007f1136e57060>
  puts obj1             #=> 1
  puts obj2             #=> 2
end

# for example, you can define methods dynamically with instance_exec
instance = Klass.new
instance.instance_exec(3) do |obj|
  @_obj = obj
  def new_func
    @_obj
  end
end
puts instance.new_func  #=> 3 (or nil if no arguments passed to instance_exec)

# works only with block
Klass.new.instance_exec "puts 'hello'" #=> no block given (LocalJumpError)

Difference between instance_eval vs instance_exec :-
=================================================
1. instance_eval accepts both blocks and strings as argument.
but instance_exec only allows blocks as arguments.

2. instance_exec block accepts additionl arguments for blocks.
but instance_eval wont accept additionl arguments for blocks.   

** Why instance_eval creates class methods?
-----------------------------------
instance_eval is a method of the "Object" class, meaning that 
the receiver will be an object. The block you pass to 
instance_eval is evaluated in the context of that object. That
means that Person.instance_eval is evaluated in the context 
of the Person object. Remember that a class name is simply a 
constant which points to an instance of the class Class. 
Because of this fact, defining a method in the context of 
Class instance referenced by Person creates a class method 
for Person class.
=============================================================
3. module_eval : Using module_eval we can create instance
methods for classes and we can also add methods to modules.

Eg1: Adding methods to module
module M1
end
M1.module_eval do 
  def method1
    puts "module M1 method1"
  end
  def method2
    puts "module M1 method2"
  end
  def self.method3 # Its defines module method
    puts "module M1 method3"
  end
end
class Test
  include M1
end
Test.new.method1 # We are able to access module methods
Test.new.method2 # We are able to access module methods
M1.method3# Calling module method.

Eg2: We can also module_eval inside classes.

class Base
  module_eval do
    def method
      puts "Defining method inside class"
    end 
  end
end

p Base.new.method # => returns output. 
============================================================
Hook Methods :-
==============

included is an example of a hook method (sometimes called a 
callback). A hook method is a method that you write but that 
Ruby calls from within the interpreter when some particular
event occurs. The interpreter looks for these methods by 
name—if you define a method in the right context with an 
appropriate name, Ruby will call it when the corresponding 
event happens.

=============================================================

*--> class_variable_set :-
We will use this variable to set class variable value.

class Base
  @@name = "bar"
  def self.foo
    @@name
  end
end

p "Before setting class variable"
p Base.foo # => "bar"
Base.class_variable_set(:@@name, "bar1");
p "After setting class variable"
p Base.foo #=> "bar1"

*-->) class_variable_get:-
==========================
Returns the value of the given class variable (or throws a 
NameError exception).

class Fred
  @@foo = 99
end

Fred.class_variable_get(:@@foo)

*-->) class_variables:-
=======================

We can use this method to return all class variables defined in class.
class Base
  @@name = "bar"
  @@location = "Hyderabad"
end
p Base.class_variable_get(:@@name)
p Base.class_variables #=> [:@@name, :@@location]

*--> instance_variable_set :- 
============================
We can use this method to set instance variable value.
class Person
  def initialize
    @name = "person"
  end
  def name
    @name
  end
end
pramod = Person.new
pramod.instance_variable_set(:@name, "Pramod")
p pramod.name

*-->) instance_variable_get :-
============================
We will use this method to get instance variable value.
class Person
  def initialize
    @name = "Sathyam"
  end
end
person = Person.new
p person.instance_variable_get(:@name)

*--> instance_variable_set :-
We will use this method to set instance variable value.

class Person
 def initialize
    @name = "Sathyam"
    @age = 32
  end
end
person = Person.new
p "Before Update"
p person.instance_variable_get(:@name)
p person.instance_variable_get(:@age)

person.instance_variable_set(:@name, "Sundar") # Updating variable data
person.instance_variable_set(:@age, 30)
        
p "Getting instance variables data after update"
p person.instance_variable_get(:@name)
p person.instance_variable_get(:@age)

*--> instance_variables :-
=======================
To get all the instance variables defined on object.

class Person
  def initialize
    @name = "Sathyam"
    @age = 32
  end
end
person = Person.new
p person.instance_variables #=>[:@name, :@age] 

*---> const_set :-
================
We can use this method to set create new constant.
Note: If you are updating existing constant value then it 
show warning msg like ' warning: already 
initialized constant Person::LOCATION'. But it will update
the value.

Math.const_set("HIGH_SCHOOL_PI", 22.0/7.0)
p Math.const_get("HIGH_SCHOOL_PI")
p Math::HIGH_SCHOOL_PI

*---> const_get :-
===============
To get the constant value we will use this method.

Eg: 
p Math.const_get("HIGH_SCHOOL_PI") # => 3.14
p Math::HIGH_SCHOOL_PI #3.14

*---> send :-
==============
Using send  we can call methods dynamically at run time.

Using send we can invoke both instance methods and class methods
on class.

Using send we can also call private methods in class.

send( ) is an instance method of the Object class. The first 
argument to send( ) is the message that you are sending to the 
object, i.e the name of a method, remaining arguments 
are simply passed as arguments to invoked method. 

class Rubyist
  def welcome(*args)
    "Hey Welcome to " + args.join(" ")
  end
  def self.test(*args)
    p "Hello This is class method" + " with params: " + args.join(" ")
  end
  private
    def private_method
      p "This is private method"
    end
end
r = Rubyist.new
p r.send(:welcome, "famous", "Rubyists");
Rubyist.send(:test, 33, 89)
r.send(:private_method) # => This is private method.

*-->) define_method :-
=======================

The Module#define_method( ) is a private instance method of 
the class Module. The define_method is only defined on 
classes and modules. You can dynamically define an instance 
method in the receiver with define_method( ). You just need 
to provide a method name and a block, which becomes the 
method body:
Eg:-

class Rubyist
  define_method(:hello) do |name|
    p "Welcome to #{name}"
  end
end
Rubyist.new.hello("Matz")

When we can use define_method :?
=================================

We define methods using def keywords which is fine for most 
of the cases.But consider a situation where you have to create 
a series of methods all of which have the same basic structure
and logic then it seems repititive and not dry.
Ruby, being a dynamic language, you can create methods on the 
fly.

Lets see code:-
 class User
    ACTIVE = 0
    INACTIVE = 1
    PENDING = 2
    attr_accessor :status
    def active?
      status == ACTIVE
    end
    def inactive?
      status == User::INACTIVE
    end
    def pending?
      status == User::PENDING
    end
  end
  user = User.new
  user.status = 1
  user.inactive?#=> true
  user.active?#=> false

Lets see refactored code.

class User
  ACTIVE = 0
  INACTIVE = 1
  PENDING = 2
  attr_accessor :status
  def self.states *methods
    methods.each do |method|
      define_method("#{method}?") do 
        status == User.const_get(method.upcase)
      end
    end
  end
  user = User.new
  user.status = 1
  user.inactive?#=> true
  user.active?#=> false

Now, what about class methods. The simplest way is
class A
  class << self
    define_method method_name do
      #...
    end
  end
end

**Note:
=======
 we don’t use define_method inside *_eval, becasue it does 
not matter if you use define_method inside class_eval 
or instance_eval it would always create an instance method.
Eg:
class Base
  class << self
    define_method(:class_method2) do 
      pt "class method 2"
    end
  end
end
Base.class_eval do 
  define_method(:instance_method) do 
    p "Creating instance method"
  end
end
Base.instance_eval do 
  # This method won't create class method.
  # Since define_method will always create instance methods
  # inside evals. it won't care whether you are using 
  # class_eval/instance_eval.
  # To define class methods its better to use class << self format as shown above.
  define_method(:class_method) do 
    p "It should create class method"
  end
  def class_method1
    p "It should create class method1"
  end
end
base_obj = Base.new
base_obj.instance_method
base_obj.class_method
Base.class_method1
Base.class_method2
Base.class_method # =>  it throws error
# undefined method `class_method' for Base:Class (NoMethodError)

*-->) remove_method and undef_method :-
=====================================

To remove existing methods, you can use the remove_method within the scope of a given class. If a method with the same name is defined for an ancestor of that class, the ancestor class method is not removed. The undef_method, by contrast, prevents the specified class from responding to a method call even if a method with the same name is defined in one of its ancestors.

class Rubyist
  def method_missing(m, *args, &block)
    puts "Method Missing: Called #{m} with #{args.inspect} and #{block}"
  end

  def hello
    puts "Hello from class Rubyist"
  end
end

class IndianRubyist < Rubyist
  def hello
    puts "Hello from class IndianRubyist"
  end
end

obj = IndianRubyist.new
obj.hello # => Hello from class IndianRubyist

class IndianRubyist
  remove_method :hello  # removed from IndianRubyist, but still in Rubyist
end
obj.hello # => Hello from class Rubyist

class IndianRubyist
  undef_method :hello   # prevent any calls to 'hello'
end
obj.hello # => Method Missing: Called hello with [] and

*-->) method_missing:-
=======================

When Ruby does a method look-up and cant find a particular 
method, it calls a method named method_missing( ) on the 
original receiver. The method_missing( ) method is passed the 
symbol of the non-existent method, an array of the arguments 
that were passed in the original call and any block passed 
to the original method. Ruby knows that method_missing( ) is 
there, because its an instance method of Kernel that every 
object inherits. The Kernel#method_missing( ) responds by 
raising a NoMethodError. Overriding method_missing( ) allows 
you to call methods that dont really exist.

class Rubyist
  def method_missing(m, *args, &block)
    puts "Called #{m} with #{args.inspect} and #{block}"
  end
end
Rubyist.new.anything # => Called anything with [] and
Rubyist.new.anything(3, 4) { something } # => Called anything with [3, 4] and #<Proc:0x02efd664@tmp2.rb:7>
Note: we can also define method missing for class methods 
using self.method_missing

Eg: Defining method missing for class methods. 
class Rubyist
  def self.method_missing(method, *args, &block)
    p "Called method: #{method} with args: #{args.join('')} with block: #{block}"
  end
end
Rubyist.sum(1,2) do |arg1, arg2|
  p "sum of two numers is #{arg1 + arg2}"
end
produces: 
"Called method: sum with args: 12 with block: #<Proc:0x00000001e403a8@p26.rb:7>"

*-->) Class.new :- 

To create classes dynamically at run time or to create anonymous
classes we will use this syntax.

Eg:-

Person = Class.new do 
  def instance_method
     "defining instance method"
  end
  def self.class_method
     "calling class method"
  end
end
ram = Person.new
p ram.instance_method
p Person.class_method

Eg2:- Dynamically creating multiple classes.
class Parent
  def test1
    p "Calling test1 method"
  end
end
# Dynamic classes creation code starts here.
["Child1", "Foo", "Bar"].each do |klass_name|
  # We are generating new class by passing "Parent" as parent class name.
  klass = Class.new(Parent) do
    def name
      p self.class
    end
    def hello
      p "i am #{self.name}"
    end
  end
  # Note here: We are assinging klass_name
  Object.const_set(klass_name, klass)
end
child1 =  Child1.new
child1.hello #=> "i am Child1"
#Note here: Calling parent class method form child class.
child1.test1 #=> "Calling test1 method"

Eg3: 
class ClassFactory
  def self.create_class class_name, *fields
    @@fields = fields
    klass =  Class.new do 
      def initialize(*values)
        @@fields.each_with_index do |field, index|
          instance_variable_set("@#{field}", values[index])
        end
     end
      fields.each do |field|
        define_method field.intern do 
          instance_variable_get("@#{field}")
        end
        define_method "#{field}=" do |value|
          instance_variable_set("@#{field}", value)
        end
      end
    end
    Object.const_set class_name, klass
  end
end
ClassFactory.create_class "Car", "make", "model", "year"
maruti_honda = Car.new("Nissan","Maxima",2010)
p maruti_honda.inspect
p "make: #{maruti_honda.make}"
p "model: #{maruti_honda.model}"
p "year: #{maruti_honda.year}"
p maruti_honda.year = 2016
p maruti_honda.inspect
produces:-
"#<Car:0x00000000ed3028 @make=\"Nissan\", @model=\"Maxima\", @year=2010>"
"make: Nissan"
"model: Maxima"
"year: 2010"
2016
"#<Car:0x00000000ed3028 @make=\"Nissan\", @model=\"Maxima\", @year=2016>"

In Ruby, classes are simply objects like any other, which are 
then assigned to a constant.  Hence, to create a new class 
dynamically we instantiate the class Class with Class.new, and
then assign it to a constant via const_set (we invoke it on 
Kernel so that it is a top-level constant like any other 
class).  We then add the code that makes up the class in a 
do-end block.

In that do-end block, for each field we invoke define_method 
twice, first for the getter method and then the setter method 
with get_instance_variable and set_instance_variable, 
respectively.  For each field, we create the instance 
variables (e.g., for make, we use @make).  Note how we make 
use of passing the argument in for the setter.

Additionally, if I wanted to make the class a sub-class, I 
could have used Class.new(parent_class)
*-->) instance_methods :-
==========================
We can use this method to get all instance_methods avilable
for particular class.
By default it will give instance methods of super classes also.
To get instance methods of current class we need to pass 
false as argument to this method.

Eg:-

class Rubyist
  define_method(:hello) do |name|
    p "Welcome to #{name}"
  end
end
Rubyist.new.hello("Matz")
# Below method only give instance methods of current class.
Rubyist.instance_methods(false) #=> :hello

*-->  respond_to? :-
=====================
 You can determine in advance (before you ask the object to 
 do something) whether the object knows how to handle the 
 message you want to send it, by using the respond_to? 
 method. This method exists for all objects; you can ask any 
 object whether it responds to any message.
 
obj = Object.new
if obj.respond_to?(:program)
  obj.program
else
  puts "Sorry, the object doesn't understand the 'program' message."
end












