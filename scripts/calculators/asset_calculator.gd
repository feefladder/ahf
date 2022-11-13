extends EOYCalculator

#dictionaries are shared by reference, so they stay updated throughout
onready var acquired_assets: Dictionary = get_parent().acquired_assets
onready var persistent_assets: Dictionary = get_parent().persistent_assets

func make_summary(event: EventResource):
    summary = AssetSummaryResource.new()
    summary.type = Resource
    summary.dict = get_parent().acquired_assets
    calc_income_from_acquired_assets(event)
    make_acquired_assets_persistent()
    calc_income_from_persistent_assets(event)
    if event is CostEvent:
        summary.dict[event] = event.costs
    return summary

func calc_income_from_acquired_assets(_event):
    for asset in acquired_assets:
        if int(acquired_assets[asset]) > 0:
            # we bought these
            if asset.unit_price > 0:
                summary.expenses[asset] = int(acquired_assets[asset]) * asset.unit_price
            else:
                summary.income[asset] = abs(int(acquired_assets[asset]) * asset.unit_price)
        else:
            # we sold these
            if asset.unit_price < 0:
                summary.expenses[asset] = int(acquired_assets[asset]) * asset.unit_price
            else:
                summary.income[asset] = int(acquired_assets[asset]) * asset.unit_price

func calc_income_from_persistent_assets(_event):
    for asset in persistent_assets:
        if "yearly_revenue" in asset:
            summary.persistent_income[asset] = asset.yearly_revenue
        if "yearly_expenses" in asset:
            summary.persistent_expenses[asset] = asset.yearly_expenses

func make_acquired_assets_persistent():
    for asset in acquired_assets:
        if asset.persistent:
            if asset in persistent_assets:
                persistent_assets[asset] += acquired_assets[asset]
            else:
                persistent_assets[asset] = acquired_assets[asset]
