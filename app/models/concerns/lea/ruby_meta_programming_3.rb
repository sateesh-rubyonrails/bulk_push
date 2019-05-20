1. Class#superclass :-
=======================
To get the parent of particular class we can use this method.

Eg1:
Integer.superclass # => returns "Numeric"

**Eg2: 
To get the list of superclasses of particular class 
we can use this method.

klass = Integer
puts "List of super classes for #{klass}"
begin
  print klass
  klass = klass.superclass
  print " < " if klass
end while klass
puts ""

Output :-
List of super classes for Integer
Integer < Numeric < Object < BasicObject
2. Module#ancestors :-
=======================
lists both superclasses and mixed-in modules.

Eg1: 
puts Integer.ancestors.inspect

Output:-
[Integer, Numeric, Comparable, Object, Kernel, BasicObject]

3. Get public, protected, private instance methods
=====================================================
> public_instance_methods(false) => To get all public methods of class.
> protected_instance_methods(false) => to get all protected instance methods.
> private_instance_methods(false) => To get all private instance methods.
> class_variables => To list class variables of class.
> constants => to list constants
> singleton_methods(false) => To list class methods of class.


class Demo
  @@var = 99
  STATUS = "Actvie"
  private
    def private_method
    end
  protected
    def protected_method
    end
  public
    def public_method
      @inst = 1
      i = 1
      j = 2
      local_variables
    end
  def self.class_method
  end
end
p "Public instance methods"
p Demo.public_instance_methods(false)
p "Protected instance methods"
p Demo.protected_instance_methods(false)
p "Private instance methods"
p Demo.private_instance_methods(false)
p "Singleton methods"
p Demo.singleton_methods(false)
p "Class variables"
p Demo.class_variables
p "Constants"
p Demo.constants

demo = Demo.new
p "Instance variables"
p demo.instance_variables

p "Calling  public method to list variables"
p demo.public_method

p "Instance variables"
p demo.instance_variables



 