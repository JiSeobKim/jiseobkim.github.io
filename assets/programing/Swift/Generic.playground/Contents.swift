
struct CreditCard {
    var name: String?
    var creditNumber: String?
}

struct BusinessCard {
    var name: String?
    var hp: String?
    var address: String?
}


// 내가 원하는건 이름
func getName<T>(data:T) -> String{
    var value: String!
    
    
    switch data is CreditCard {
    case true:
        // 신용 카드
        let convert = data as! CreditCard // 캐스팅
        value = convert.name
        
    case false:
        // 명함
        let convert = data as! BusinessCard // 캐스팅
        value = convert.name
    }
    
    
    
    return value
}

func getName2<T>(data:T) -> String{
    var value: String = ""
    
    switch data {
    case is CreditCard:
        let convert = data as! CreditCard
        value = convert.name!
    case is BusinessCard:
        let convert = data as! BusinessCard
        value = convert.name!
    
    default:
        print("asdf")
    }
    
    return value
}



let cCard = CreditCard(name: "홍길동", creditNumber: "0201-0505")
let bCard = BusinessCard(name: "둘리", hp: "010-xxxx-yyyy", address: "221B Baker Street")


getName(data: cCard)
getName(data: bCard)

getName2(data: cCard)
getName2(data: bCard)


// MARK: Enum 사용
enum GetSomething<Value> {
    case credit(Value)
    case business(Value)
}




let something = GetSomething<CreditCard>.business(cCard)


func ttts() -> Self {
    
}







