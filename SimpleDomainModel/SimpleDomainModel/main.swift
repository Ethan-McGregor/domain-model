//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ethan McGregor on 4/10/17.
//  Copyright © 2016 Ethan McGregor. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}


////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Double
    public var currency : String
    
    public func convert(_ newCur: String) -> Money {
        var newAmount : Double = 0
        let error : String = "Sorry, only converting to USD, GBP, EUR, and CAN is available at this time."
        if(currency == newCur){
            newAmount = amount
        }else{
            
            switch currency {
            case "USD":
                switch newCur {
                case "GBP":
                    newAmount = amount * 0.5
                case "EUR":
                    newAmount = amount * 1.5
                case "CAN":
                    newAmount = amount * 1.25
                default:
                    print(error)
                }
            case "GBP":
                switch newCur {
                case "EUR":
                    newAmount = amount * 1.5
                case "CAN":
                    newAmount = amount * 2.5
                case "USD":
                    newAmount = amount * 2
                default:
                    print(error)
                }
            case "EUR":
                switch newCur {
                case "GBP":
                    newAmount = amount / 3
                case "CAN":
                    newAmount = amount / 6 * 5
                case "USD":
                    newAmount = amount / 1.5
                default:
                    print(error)
                }
            case "CAN":
                switch newCur {
                case "GBP":
                    newAmount = amount * 0.8
                case "EUR":
                    newAmount = amount / 5 * 6
                case "USD":
                    newAmount = amount / 1.25
                default:
                    print(error)
                }
                
            default:
                print(error)
            }
        }
        let newMoney = Money(amount: newAmount, currency: newCur)
        return newMoney
    }
    
    public func add(_ oldMoney: Money) -> Money {
        if (self.currency == oldMoney.currency) {
            return Money(amount: self.amount + oldMoney.amount, currency: self.currency)
        } else {
            return oldMoney.add(self.convert(oldMoney.currency))
        }
    }
    
    
    public func subtract(_ oldMoney: Money) -> Money {
        if (self.currency == oldMoney.currency) {
            return Money(amount: self.amount - oldMoney.amount, currency: self.currency)
        } else {
            return oldMoney.subtract(self.convert(oldMoney.currency))
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let income) : return Int(income * Double(hours))
        case .Salary(let income) : return income
        }
    }
    
    open func raise(_ amount : Double) {
        switch type {
        case .Hourly(let income) : type = JobType.Hourly(income + amount)
        case .Salary(let income) : type = JobType.Salary(Int(Double(income) + amount))
        }
    }
}


////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    
   
    open var job : Job? {
        get { return _job}
        set(value) {
            if (self.age >= 16) {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return _spouse }
        set(value) {
            if (self.age >= 18) {
                _spouse =  value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
        
    }
}


////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    
    open func haveChild(_ child: Person) -> Bool {
        
        for i in members {
            
                        if (i.age > 21) {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        
        var totalIncome : Int = 0
        
        for i in members {
            
            if (i.age >= 16 && i._job != nil) {
                totalIncome += (i._job?.calculateIncome(2000))!
            }
        }
        
        return totalIncome
    }
}
