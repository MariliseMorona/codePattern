enum Office {
    case developer
    case productOwner
    case productManager
    case softwareArchitect
    case softwareEngineer
    case qualityAnalyst
    
    func stringOffice() -> String {
        switch self {
        case .developer:
            return "Developer"
        case .productOwner:
            return "Product Owner"
        case .productManager:
            return "Product Manager"
        case .softwareArchitect:
            return "Software Architect"
        case .softwareEngineer:
            return "Software Engineer"
        case .qualityAnalyst:
            return "Quality Analyst"
        }
    }
}

enum Seniority {
    case junior
    case analyst
    case senior
    
    func stringOffice() -> String {
        switch self {
        case .junior:
            return "Junior"
        case .analyst:
            return "Analyst"
        case .senior:
            return "Senior"
        }
    }
    
    
    func seniority(theOffice office: Office, seniority: Seniority) -> String{
        switch seniority{
        case .analyst:
            return "\(office.stringOffice())"
        default:
            return " \(seniority.stringOffice()) \(office.stringOffice())"
        }
    }
}

struct Employee{
    let name: String
    let register: Int
    let salary: Double
    let office: Office
    let seniority: Seniority
    
    func introduceYourself()-> String{
        let presentation = "Hello. My name is \(name), I`m a \(seniority.seniority(theOffice: office, seniority: seniority))."
        return presentation
    }
}

class Company {
    
    var employees = [Employee]()
    
    init(employees: [Employee]){
        self.employees = employees
    }
    
    func addEmployee(_ employee: Employee) -> String{
        employees.append(employee)
        return "Welcome to our company \(employee.name), your registration number is \(employee.register). Yor are our youngest \(employee.seniority.stringOffice()) \(employee.office.stringOffice()) !! And your remuneration will be R$\(employee.salary)."
        
    }
    
    func removeEmployee(registerEmployee register: Int){
        employees.removeAll{ $0.register == register }
    }
    
    func showTotalPayrollCost() -> Double {
        var cost: Double = 0
        for employee in employees {
            cost += employee.salary
        }
        return cost
    }
    
    func showPayrollCostByOffice(_ office: Office) -> Double {
        var cost: Double = 0
        for employee in employees where employee.office == office {
            cost += employee.salary
        }
        return cost
    }
    
    func showPayrollCostBySeniority(_ seniority: Seniority) -> Double {
        var cost: Double = 0
        for employee in employees where employee.seniority == seniority {
            cost += employee.salary
        }
        return cost
    }
    
    
    func showPayrollCostBySeniorityAndOffice(_ seniority: Seniority, _ office: Office) -> Double {
        var cost: Double = 0
        for employee in employees where employee.office == office && employee.seniority == seniority {
            cost += employee.salary
        }
        return cost
    }
    
    
    func countTotalEmployees() -> Int {
        return employees.count
    }
    
    func countEmployeesByOffice(_ office: Office) -> Int {
        return employees.filter{ $0.office == office }.count
    }
    
    func countEmployeesBySeniority(_ seniority: Seniority) -> Int {
        return employees.filter{ $0.seniority == seniority }.count
    }
    
    func countEmployeesBySeniorityAndOffice(_ seniority: Seniority, _ office: Office) -> Int {
        var newEmployeer = [Employee]()
        for employee in employees where employee.office == office{
            newEmployeer.append(employee)
        }
        return newEmployeer.filter{ $0.seniority == seniority }.count
    }
    
    func listEmployeeNamesInAlphabeticalOrder() -> [String] {
        var listNames = [String]()
        listNames = employees.map{ $0.name }.sorted()
        return listNames
    }
    
    func validateSalary(newEmployee: Employee) -> Bool {
        if showPayrollCostBySeniorityAndOffice(newEmployee.seniority, newEmployee.office) != newEmployee.salary {
            return true
        }
        return false
    }
    
    func validateSeniority(newEmployee: Employee) -> Bool {
        switch newEmployee.seniority {
        case .junior:
            if countEmployeesBySeniorityAndOffice(.junior, newEmployee.office)/countEmployeesBySeniorityAndOffice(.analyst, newEmployee.office) > 2 {
                return true
            }
        case .analyst:
            if countEmployeesBySeniorityAndOffice(.analyst, newEmployee.office)/countEmployeesBySeniorityAndOffice(.senior, newEmployee.office) > 4 {
                return true
            }
            
        case .senior:
            if countEmployeesBySeniorityAndOffice(.analyst, newEmployee.office)/countEmployeesBySeniorityAndOffice(.analyst, newEmployee.office) < 4 {
                return true
            }
        }
        return false
    }
    
    func conditionHiring(newEmployee: Employee) -> String {
        for employeer in employees where employeer.register == newEmployee.register {
            return "There is already an employee with this record. Create a new register."
        }
        
        if validateSeniority(newEmployee: newEmployee) {
            return "Sorry, but we still cannot hire another \(newEmployee.seniority.stringOffice()) \(newEmployee.office.stringOffice())"
        }
        
        if validateSalary(newEmployee: newEmployee) {
            return "The recommended salary for \(newEmployee.seniority.stringOffice()) \(newEmployee.office.stringOffice()) is R$\(showPayrollCostBySeniorityAndOffice(newEmployee.seniority, newEmployee.office))."
        }
        
        return addEmployee(newEmployee)
    }
    
    func conditionDismissal(register: Int) -> String {
        let employer = employees.filter({ $0.register == register })
        if employer.count > 0 {
            
            if !validateSeniority(newEmployee: employer[0]) {
                removeEmployee(registerEmployee: register)
                return "Registration number \(register) has been removed from the records."
            }
            
            if !validateSalary(newEmployee: employer[0]) {
                removeEmployee(registerEmployee: register)
                return "Registration number \(register) has been removed from the records."
            }
            
            removeEmployee(registerEmployee: register)
            return "Registration number \(register) has been removed from the records."
        }
        return "Register not found."
    }
}
