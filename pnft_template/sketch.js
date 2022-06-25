let hexToUtf8 = s => decodeURIComponent(s.replace(/\s+/g, '').replace(/[0-9a-f]{2}/g, '%$&'))

function setup() {
	createCanvas(500,500);
  background('ivory')
  loadJSON(`${tzkt_api}/v1/tokens/balances?token.contract=${contract_address}&token.tokenId=${token_id}&select=account.address`, owners => 
  loadJSON(`${tzkt_api}/v1/contracts/KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS/bigmaps/store.reverse_records/keys?key=${owners[0]}&select=value`, domain_names => 
  loadJSON(`${tzkt_api}/v1/accounts/${owners[0]}/balance`, tez => 
  {
    
    text(`This is token ${token_id}.\nOwner: ${owners[0]}\nOwner Domain: ${hexToUtf8(domain_names[0].name)}\nOwner TEZ holdings: ${tez/1000000} ꜩ`, width/100, height/2)
    
  }
  )))
	
}

