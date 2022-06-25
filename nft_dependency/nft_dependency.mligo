type token_id = nat
type balance_of_request = [@layout:comb] { owner : address; token_id : token_id; }
type balance_of_response = [@layout:comb] { request : balance_of_request; balance : nat; }
type balance_of_param = [@layout:comb] { requests : balance_of_request list; callback : (balance_of_response list) contract; }


type data =  {location_api:string;weather_api:string;}
type nft_info = {contract_address:address; token_id:nat}
type storage = {
    admin:address;
    nft_info: nft_info option;
    pending_data: (address * data) option;
    data: data;
    
}

type entrypoints = 
| SetData of data
| Initialize of nft_info
| Finalize of balance_of_response list


let main ((e,s) : entrypoints * storage) = 
 match e with 
 | Initialize n -> if Tezos.sender = s.admin && (match s.nft_info with None -> true | _ -> false) then ([]:operation list),{s with nft_info = Some n} else (failwith "Initialization failed" : operation list * storage) 
 | SetData a -> 
    let nft_info = Option.unopt s.nft_info in
    [Tezos.transaction 
        {requests=[{owner=Tezos.sender;token_id= nft_info.token_id}]; callback= (Tezos.self("%finalize") : (balance_of_response list) contract)} 
        0tez
        (Tezos.get_entrypoint "%balance_of" nft_info.contract_address : balance_of_param contract)], {s with pending_data = Some (Tezos.sender, a)}
 | Finalize br ->  
    let pending_data = Option.unopt s.pending_data in  
    let br = Option.unopt (List.head_opt br) in
    if br.request.owner = pending_data.0 then ([]:operation list),{ s with data = pending_data.1; pending_data = (None : (address * data) option);} else (failwith "Could not finalize change." : operation list * storage)

let s = {
    admin=("tz1NCZX5YK8qRNtJzRyYEagRs73d4FSV4Ztp":address);
    nft_info=(None:nft_info option);
    pending_data=(None: (address * data) option);
    data = {location_api = "https://ipwhois.app/json/"; weather_api="https://api.open-meteo.com"}
}