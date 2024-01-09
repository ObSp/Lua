local classes = require("classes") -- path to your module

local person = classes({

    __init__ = function(self, name, age) -- create a new init function
        self.Name = name -- set the name
        self.age = age -- set the age to the parameter
        return self -- return the self table
    end,

    __str__ = function(self) -- specify the __str__ function, which controls the object's tostring() behavior
        return `{self.Name} is {self.age} years old` -- return a string containing the person's name and age
    end,

    SetAge = function(self, new_age) -- object method to set the person's age
        self.age = new_age -- set the new age
        return self -- self must ALWAYS be returned, otherwise changes won't apply outside of this function
    end

}) -- define the functions inside a table

local John = person("John", 21) -- create a person named John who is 21 years old
local Bob = person("bob", 1212120) -- create bob, who is very old
print(John, Bob) -- will print:  John is 21 years old, bob is 1212120 years old

Bob:SetAge(15) -- change bob's age, object methods MUST be called with a colon unless you want to pass the object again in the parameters, there is no other way to get the self parameter
print(Bob) -- will print: bob is 15 years old
