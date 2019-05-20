1) Singleton Pattern:

Singleton is a design pattern that restricts instantiation of a class to only one instance that is globally available. 
It is useful when you need that instance to be accessible in different parts of the application, usually for logging 
functionality, communication with external systems, database access, etc.


2) Adapter pattern: 
  The Adapter Pattern can be used to wrap different
  interfaces  and provide a uniform interface. 
   
  Ex:
  ActiveRecord contains adapters for several databases.
  Although PostgreSQL and MySQL are both SQL databases, 
  there are many differences between them that ActiveRecord 
  hides these differences using the Adapter Pattern. 
  
  Example: rails implemented activerecord by using 
  MysqlAdapter, PostgresAdapter, SqliteAdapter
Ex2: Please check adapter_pattern.rb file.

3) Decorator pattern: 

The decorator pattern is used to extend the functionality of a
certain object in a runtime. Advantage of decorator pattern is 
we can reduce the number of classes creation. 

Ex:- Please check decorator_pattern.rb


4) observer pattern: 

The Ruby Standard Library includes an Observable module that 
implements this pattern.
An object, called the subject, maintains a list of its dependents, 
called observers, and notifies them automatically of any state 
changes, usually by calling one of their methods.

This pattern will be useful to send notification

5) Iterator pattern: 

iterator is a design pattern in which an iterator is used to traverse a container and access the 
containers elements.  The iterator can be thought of as a moveable pointer that allows access to 
elements encapsulated within a container.
the iterator pattern can be implemented in two ways.
1) external iterator : -

2) internal iterator : 

6) Template method pattern: 
https://medium.com/@joshsaintjacque/the-template-method-pattern-558f3e16879f
  The Template Method allows you to define the “skeleton” 
  of an algorithm with common methods, while leaving concrete 
  (i.e distinct behavior)implementation up to inheriting classes. 
  The template (in this case, the parent class) serves as an outline of the steps needed to
  complete the task, itself implementing any steps that 
  don’t vary and defining an interface for the steps that 
  do. It’s concrete-class children then go on to implement
  those missing steps.

7) STRATEGY Pattern : 

 strategy is software design pattern which enables an 
 alogorithm behavior to be selected at run time.  
 The strategy pattern

    1)defines a family of algorithms,
    2)encapsulates each algorithm, and
    3)makes the algorithms interchangeable within that 
    family.



 


