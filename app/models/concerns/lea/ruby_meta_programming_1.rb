In metaprogramming, We write code that writes code.
 It’s dynamic code generation.
 
*-->) Singleton Methods, Singleton Class :-
==========================================
In Ruby we can define methods that are specific to a particular
object.These are called singleton methods.

Eg:
For example, let’s start with a simple string object:

animal = "cat" # Here animal is string object
def animal.speak
  puts "The #{self} says miaow"
end
animal.speak => "The cat says miaow"
puts animal.upcase => "CAt"

When we defined the singleton method for the object(eg:"cat"), 
Ruby created a new anonymous class and defined the speak 
method in that class. This anonymous class is sometimes called
as a "singleton class" and other times an "eigenclass". 
I prefer the former, because it ties in to the idea of 
singleton methods.

Ruby makes this singleton class as the class of the object and 
makes String (which was the original class of "cat") as the 
superclass of the singleton class. 

Now let’s follow the call to animal.speak. Ruby goes to the 
object referenced by animal and then looks in its class for 
the method speak. The class of the animal object is the newly
created singleton class, and it contains the method we need.

What happens if we instead call animal.upcase? The processing starts the same way: Ruby
looks for the method upcase in the singleton class but fails 
to find it there. It then follows the normal processing rules 
and starts looking up the chain of superclasses. The superclass
of the singleton is String, and Ruby finds the upcase method 
there. Notice that there is nos special-case processing here—Ruby method calls always work the same way.
Report

*--) Another Way to Access the Singleton Class :-
================================================

We’ve seen how you can create methods in an object’s singleton
class by adding the object reference to the method definition using something like def animal.speak.
You can do the same using Ruby’s class < < an_object notation:
Report

animal = "dog"
class << animal
  def speak
  puts "The #{self} says WOOF!"
  end
end
animal.speak

Inside this kind of class definition, self is set to the 
singleton class for the given object (animal in this case). 
Because class definitions return the value of the last 
statement executed in the class body, we can use this fact to 
get the singleton class object:

animal = "dog"
def animal.speak
  puts "The #{self} says WOOF!"
end
singleton = class << animal
  def lie
    puts "The #{self} lies down"
  end
  self # << return singleton class object
end

animal.speak
animal.lie
puts "Singleton class object is #{singleton}"
puts "It defines methods #{singleton.instance_methods '
cat'.methods}"

produces:
The dog says WOOF!
The dog lies down
Singleton class object is #<Class:#<String:0x0a36d8>>
It defines methods [:speak, :lie]

Note the notation that Ruby uses to denote a singleton class: #<Class:#<String:...> >.
Ruby goes to some trouble to stop you from using singleton classes outside the context of
their original object. For example, you can’t create a new instance of a singleton class:
Download samples/classes_10.rb
singleton = class << "cat"; self; end
singleton.new
produces:
prog.rb:2:in new: cant create instance of singleton class (TypeError)
from /tmp/prog.rb:2:in <main>

============================================================
*-->) attr_accessor:-

We can define instance methods in class using attr accessors.

class Person
  attr_accessor :name, :age
end
p = Person.new
p.age = 30
p.name="Sateesh"
p p.name #=> "Sateesh"
p p.age #=> 30

*--> Class level attr accessors :-
We can define class level methods by using class << self.
Eg:

class Student
	attr_accessor :name, :age # Defining instance level methods
	def initialize(name, age)
	  @name = name
	  @age = age
	end
  class << self # Defining class level methods
  	attr_accessor :teacher_name, :school_name
  end
end
Student.school_name = "ZPH"
Student.teacher_name = "Sk"
s = Student.new("Sateesh", 30)
p s.name # => "Sateesh"
p s.age #=> 30
p Student.school_name # => "ZPH"
p Student.teacher_name #=> "Sk"

============================================================
**Inheritance and Visibility :-
===============================
We can change the visibility of the parent class method in child 
class.
For example, you can do something like this:
class Base
  def a_method
    p "Calling base private method"
  end
  private :a_method
end
class Child1 < Base
  public :a_method
end
class Child2 < Base
end
Child1.new.a_method #=> "Calling base private method"
Child2.new.a_method #=> private method `a_method' called for #<Child2:0x00000001a44330>

In this example, you would be able to invoke a_method in 
instances of class Derived1 but not via instances of Base or 
Derived2. So, how does Ruby pull off this feat of having one 
method with two different visibilities? Simply put, it cheats.
If a subclass changes the visibility of a method in a parent, 
Ruby effectively inserts a hidden proxy method in the subclass
that invokes the original method using super. It then sets the
visibility of that proxy to whatever you requested. This means
that the following code:
class Derived1 < Base
public :a_method
end
is effectively the same as this:
class Derived1 < Base
  def a_method(*)
    super
  end
  public :a_method
end
The call to super can access the parent’s method regardless of
its visibility, so the rewrite allows the subclass to override
its parent’s visibility rules.
=============================================================
*** Modules and Mixins :-
==========================
You know that when you include a module into a Ruby class, 
the instance methods in that module become available as 
instance methods of the class.

You know that when you include a module into a Ruby class, 
the instance methods in that module become available as 
instance methods of the class.

module Logger
  def log(msg)
    STDERR.puts Time.now.strftime("%H:%M:%S: ") + "#{self} (#{msg})"
  end
end
class Song
include Logger
end
class Album
include Logger
end
s = Song.new
s.log("created")
produces:
13:26:13: #<Song:0x0a323c> (created)
Ruby implements include very simply: the module that you 
include is effectively added as a superclass of the class 
being defined. It’s as if the module was the parent of the 
class that it is mixed in to. And that would be the end of 
the description except for one small wrinkle.
Because the module is injected into the chain of superclasses,
it must itself hold a link to the original parent class. If it
didn’t, there’d be no way of traversing the superclass chain to
look up methods. However, you can mix the same module into many different classes, and
those classes could potentially have totally different superclass chains. If there were just one
module object that we mixed in to all these classes, there’d be no way of keeping track of
the different superclasses for each.
To get around this, Ruby uses a clever trick. When you include a module in class Example,
Ruby constructs a new class object, makes it the superclass of Example, and then sets the
superclass of the new class to be the original superclass of Example. It then references the
module from this new class object in such a way that when you look a method up in this
class, it actually looks it up in the module, as shown in Figure 24.5 on the following page.
A nice side effect of this arrangement is that if you change a module after including it in a
class, those changes are reflected in the class (and the class’s objects). In this way, modules
behave just like classes.
Download samples/classes_16.rb
module Mod
def greeting
"Hello"
end
end
class Example
include Mod
end
ex = Example.new
puts "Before change, greeting is #{ex.greeting}"
module Mod
def greeting
"Hi"
end
end
puts "After change, greeting is #{ex.greeting}"
produces:
Before change, greeting is Hello
After change, greeting is Hi
If a module itself includes other modules, a chain of proxy classes will be added to any class
that includes that module, one proxy for each module that is directly or indirectly included.
Finally, Ruby will include a module only once in an inheritance chain—including a module
that is already included by one of your superclasses is a no-op.
=============================================================
** extend :-
===========
The include method effectively adds a module as a superclass 
of self. It is used inside a class definition to make the 
instance methods in the module available to instances of the 
class.

However, it is sometimes useful to add the instance methods to a particular object. You do
this using Object#extend. For example:
Download samples/classes_17.rb
module Humor
  def tickle
    "#{self} says hee, hee!"
  end
end
obj = "Grouchy"
obj.extend Humor
puts obj.tickle
produces:
Grouchy says hee, hee!

Stop for a second to think about how this might be implemented....
When Ruby executes obj.tickle in this code example, it does 
the usual trick of looking in the class of obj for a method 
called tickle. For extend to work, it has to add the instance
methods in the Humor module into the superclass chain for the 
class of obj. So, just as with singleton method definitions, 
Ruby creates a singleton class for obj and then includes the
module Humor in that class. In fact, just to prove that this 
is all that happens, here’s the C implementation of extend in 
the current Ruby 1.9 interpreter:
void
rb_extend_object(VALUE obj, VALUE module)
{
  rb_include_module(rb_singleton_class(obj), module);
}
There is an interesting trick with extend. If you use it 
within a class definition, the module’s methods become class 
methods. This is because calling extend is equivalent to self.
extend, so the methods are added to self, which in a class 
definition is the class itself.
Here’s an example of adding a module’s methods at the class 
level:
Download samples/classes_19.rb
module Humor
  def tickle
    "#{self} says hee, hee!"
  end
end
class Grouchy
 extend Humor
end
puts Grouchy.tickle
produces:
Grouchy says hee, hee!
============================================================

** Subclassing Expressions :-
==============================

The first form is really nothing new—it’s simply a generalization of the regular class definition
syntax. You know that you can write this:
class Parent
...
end
class Child < Parent
...
end
What you might not know is that the thing to the right of the 
< needn’t be just a class name; it can be any expression that 
------------------------------- 
returns a class object. In this code example, we have the 
constant Parent. A constant is a simple form of expression, 
and in this case the constant Parent holds the class object 
of the first class we defined. Ruby comes with a class called 
Struct, which allows you to define classes that contain just
data attributes. For example, you could write this:

Person = Struct.new(:name, :address, :likes)
dave = Person.new('Dave', 'TX')
dave.likes = "Programming Languages"
puts dave
produces:
#<struct Person name="Dave", address="TX", likes="Programming Languages">
The return value from Struct.new(...) is a class object. By 
assigning it to the constant Person,we can thereafter use 
Person as if it were any other class.
But say we wanted to change the to_s method of our structure.
We could do it by opening up the class and writing the method:
Person = Struct.new(:name, :address, :likes)
class Person
  def to_s
    "#{self.name} lives in #{self.address} and likes #{self.likes}"
  end
end
However, we can do this more elegantly (although at the cost of an additional class object)
by writing this:

class Person < Struct.new(:name, :address, :likes)
  def to_s
   "#{self.name} lives in #{self.address} and likes #{self.likes}"
  end
end
dave = Person.new('Dave', 'Texas')
dave.likes = "Programming Languages"
puts dave
produces:
Dave lives in Texas and likes Programming Languages

Creating Singleton Classes / Dynamically defining classes:-
==========================================================

Let’s look at some Ruby code:
class Example
end
ex = Example.new
When we call Example.new, we’re invoking the method new on 
the class object Example. This is just a regular method 
call—Ruby looks for the method new in the class of the object
(and the class of Example is Class) and invokes it. It turns 
out that we can also invoke
Class#new directly:
some_class = Class.new
puts some_class.class
produces:
Class
If you pass Class.new a block, that block is used as the 
body of the class:

some_class = Class.new do
def self.class_method
  puts "In class method"
end
def instance_method
  puts "In instance method"
end
end
some_class.class_method
obj = some_class.new
obj.instance_method
produces:
In class method
In instance method
By default, these classes will be direct descendents of 
Object. You can give them a different
parent by passing the parent’s class as a parameter:

some_class = Class.new(String) do
def vowel_movement
tr 'aeiou', '*'
end
end
obj = some_class.new("now is the time")
puts obj.vowel_movement
produces:
n*w *s th* t*m*

How Classes Get Their Names
===============================

You may have noticed that the classes created by Class.new 
have no name. However, all is not lost. If you assign the 
class object for a class with no name to a constant, Ruby will automatically name the class
after the constant:
some_class = Class.new
obj = some_class.new
puts "Initial name is #{some_class.name}"
SomeClass = some_class
puts "Then the name is #{some_class.name}"
puts "also works via the object: #{obj.class.name}"
produces:
Initial name is
Then the name is SomeClass
also works via the object: SomeClass

We can use these dynamically constructed classes to extend 
Ruby in interesting ways. For example, here’s a simple reimplementation of the Ruby Struct 
class:

def MyStruct(*keys)
Class.new do
attr_accessor *keys
def initialize(hash)
hash.each do |key, value|
instance_variable_set("@#{key}", value)
end
end
end
end
Person = MyStruct :name, :address, :likes
dave = Person.new(name: "dave", address: "TX", likes: "Stilton")
chad = Person.new(name: "chad", likes: "Jazz")
chad.address = "CO"
puts "Dave's name is #{dave.name}"
puts "Chad lives in #{chad.address}"
produces:
Daves name is dave
Chad lives in CO
Report

