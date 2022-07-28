extends Resource
class_name BuyResource

export(String) var name
export(StreamTexture) var image
export(float) var unit_price
export(float) var unit_labour

export(Dictionary) var tooltip_info = {
    "general" : "",
    "short_term_pros" : "",
    "short_term_cons" : "",
    "long_term_pros" : "",
}
