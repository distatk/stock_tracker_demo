class Queries {
  static const getSectors = r'''
  query sectors {
  listJittaSectorType {
    name
  }
}
''';
  static const getStockList = r'''
  query stockByRanking($market: String!, $sectors: [String], $page: Int, $limit: Int) {
  jittaRanking(filter: { market: $market, sectors: $sectors, page: $page, limit: $limit }) {
    count
    data {
      id
	    stockId
	    rank
	    symbol
	    exchange
	    title
	    jittaScore
	    nativeName
	    sector {
	      id
	      name
	    }
	    industry
    }
  }
  listJittaSectorType {
    id
    name
  }
}
''';
}
