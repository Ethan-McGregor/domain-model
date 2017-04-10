//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
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
        let error : String = "sorry, only converting to USD, GBP, EUR, and CAN is available at this time."
        switch currency {
        case "USD":
            switch newCur {
            case "GBP":
                newAmount = amount * 0.5
            case "EUR":
                newAmount = amount * 1.5
            case "CAN":
                newAmount = amount * 1.25
            case "USD":
                newAmount = amount
            default:
                print(error)
            }
        case "GBP":
            switch newCur {
            case "GBP":
                newAmount = amount
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
            case "EUR":
                newAmount = amount
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
            case "CAN":
                newAmount = amount
            case "USD":
                newAmount = amount / 1.25
            default:
                print(error)
            }
            
        default:
            print(error)
        }
        
        let newMoney = Money(amount: newAmount, currency: newCur)
        return newMoney
    }
    
    public func add(_ oldMoney: Money) -> Money {
        let money = self.convert(oldMoney.currency)
        let newAmount = money.amount + oldMoney.amount
        let newCurrency = oldMoney.currency
        let newMoney =  Money(amount: newAmount, currency: newCurrency)
        return newMoney
    }
    
    
    public func subtract(_ oldMoney: Money) -> Money {
        let money = self.convert(oldMoney.currency)
        let newAmount = money.amount - oldMoney.amount
        let newCurrency = oldMoney.currency
        let newMoney =  Money(amount: newAmount, currency: newCurrency)
        return newMoney
    }
}


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
    
    // bumps up the salary by the passed amount for the specific job type
    open func raise(_ amt : Double) {
        switch type {
        case .Hourly(let income) : type = JobType.Hourly(income + amt)
        case .Salary(let income) : type = JobType.Salary(Int(Double(income) + amt)) // should this be saved in var type?
        }
    }
}


open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    
    // getters and setters for Job class
    open var job : Job? {
        get { return _job}
        set(value) {
            if (self.age > 15) {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return _spouse }
        set(value) {
            if (self.age > 17) {
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


open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        members.append(spouse1) //add couple to famile array
        members.append(spouse2)
        spouse1.spouse = spouse2 //assign spouse to each other
        spouse2.spouse = spouse1
    }
    
    open func haveChild(_ child: Person) -> Bool {
        child.age = 0
        members.append(child)
        return true
    }
    
    open func householdIncome() -> Int {
        
        var totalIncome : Int = 0
        
        for i in members {
            
            if (i.age > 16 && i._job != nil) {
                // 40 hrs / week * 52 weeks = 2080 hrs per year
                totalIncome += (i._job?.calculateIncome(2000))!
            }
        }
        
        return totalIncome
    }
}
