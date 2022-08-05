extends Node
class_name CropIncomeContainer

signal crop_income_calculated(total)

export(PackedScene) var crop_summary_item_packedscene

const calculation = "%.2f x %.2f x %.2f x %.2f ="

var total_income: float = 0.0

func add_crop_summary(field_summary: FieldSummaryResource):
    for crop_key in field_summary.crop_summary:
        var crop_item = crop_summary_item_packedscene.instance()
        crop_item.resource = crop_key
        var crop_summary_data = field_summary.crop_summary[crop_key]
        var unit_yield = crop_summary_data["yield"]
        var area = crop_summary_data["area"]
        var compound_fertility = field_summary.field.fertility.compound_fertility
        crop_item.calculation = calculation % [unit_yield, area, compound_fertility, crop_key.sell_price]
        
        var total = unit_yield * area * compound_fertility * crop_key.sell_price
        crop_item.total = unit_yield * area * compound_fertility * crop_key.sell_price
        
        total_income += total
        
        self.add_child(crop_item)
    
    emit_signal("crop_income_calculated", total_income)
