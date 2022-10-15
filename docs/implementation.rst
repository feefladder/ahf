Implementation
==============


For the implementation, two patterns were used: State machines and a
Model-View-Controller (MVC) pattern. The MVC pattern is repeated for several
aspects of the farm, each for a specific part (Crops, Assets, Family, Labour).

in general, it works like the following:

.. uml::

   @startuml
   title generic Model-View-Controller setup

   package Model {
      struct CropResource {
         blocks_placed
      }

      struct CropSummaryResource {
         Dictionary : acquired
         Dictionary : income
         Dictionary : expenses
      }
   }

   package View {
      class FieldBlock {
         bool : has_crop
      }

      class AnnualReview {
      }
   }

   package Controller {
      class CropHandler{
      }

      class AssetManager {
      }

      class YieldCalculator {
      }
   }

.. uml::

   @startuml

   title Planting a crop logic

   Actor Player
   Player -> TabButton: Click
   TabButton -> StateController: Set state to CropHandler

   Player -> FieldBlock: Click
   FieldBlock -> StateController: FieldBlock is clicked
   StateController -> CropHandler: FieldBlock is clicked
   CropHandler -> FieldBlock: Has crop?
   CropHandler -> AssetManager: decrease_assets
   CropHandler -> CropResource: add(FieldBlock) to blocks_placed
   CropHandler -> FieldBlock: plant_crop(CropResource)

   @enduml

.. uml::

   @startuml

   title end of year logic

   Actor Player
   Player -> EndOfYearButton: click

   EndOfYearButton --> YieldCalculator: end_of_year_requested
   create AnnualReview
   EndOfYearButton -> AnnualReview: end_of_year_requested


   create CropSummaryResource
   YieldCalculator -> CropSummaryResource: add data
   YieldCalculator --> AnnualReview: data
   AnnualReview <-> CropSummaryResource: display data


.. uml::

   @startuml

   struct BaseResource {
      string : name
      StreamTexture : image
      Dictionary : tooltip_info
      float : unit_price
      float : unit_labour
   }

   struct CropResource {
      float : sell_price
      float : maximum_yield
      float : f_wlimited_yield
      float : f_actual_yield
   }

   struct AnimalResource {
      float : yearly_revenue
      float : yearly_costs
      float : water_use
      float : manure
   }

   struct MeasureResource {
      float : per_field_maintenance_cost
      float : per_field_maintenance_labour
      float : erosion_influence
      float : salinity_influence
      float : nutrient_influence
   }

   struct FertilizerResource {
      float : n_content
      float : long_term_influence
   }

   BaseResource --|> CropResource
   BaseResource --|> AnimalResource
   BaseResource --|> MeasureResource
   BaseResource --|> FertilizerResource

   class Field {
      FieldBlock[][] : blocks
   }

   class FieldBlock {
      CropResource : crop
   }

   class StateController {
      enum: states
   }

   class AssetManager {
      float : money
      float : labour
      Dictionary<AnimalResource, int>: animals
   }


   class ToggleButton

   class TabButton

   TabButton <|-- ToggleButton


   class BuyMenuItem
   class CropMenuItem
   class MeasuresMenuItem


   BuyMenuItem <|-- ToggleButton
   CropMenuItem <|-- BuyMenuItem
   CropMenuItem "1" *-- CropResource
   MeasuresMenuItem <|-- BuyMenuItem
   MeasuresMenuItem "1" *-- MeasureResource

   class ToggleButtonContainer {
    _connect_children()
   }
   class BuyMenuItemContainer {
    _initialize_children()
   }
   class CropMenuItemContainer
   class MeasuresMenuItemContainer

   BuyMenuItemContainer <|-- ToggleButtonContainer
   CropMenuItemContainer <|-- BuyMenuItemContainer
   MeasuresMenuItemContainer <|-- BuyMenuItemContainer

   class BigMenuCheckboxItem
   class BigMenuIntItem

   class BigMenuItemContainer
   class AnimalMenuItemContainer
   class FamilyMenuItemContainer
   class UpgradeMenuItemContainer

   BigMenuItemContainer --|> AnimalMenuItemContainer
   BigMenuItemContainer --|> FamilyMenuItemContainer
   BigMenuItemContainer --|> UpgradeMenuItemContainer

   class Loader {
      string: crop_resources_path
      string: animal_resources_path
      string: measure_resources_path
      avaiable_crops
      available_animals
      available_measures
   }

   Loader::avaiable_crops "n" *-- CropResource
   Loader::available_animals "n" *-- AnimalResource
   Loader::available_measures "n" *-- MeasureResource

   Field "n" *-- FieldBlock
   FieldBlock *-- "1" CropResource

   Loader::avaiable_crops ..> CropMenuItemContainer
   CropMenuItemContainer ..> CropMenuItem: Initializes
   Loader::available_measures ..> MeasuresMenuItemContainer
   MeasuresMenuItemContainer ..> MeasuresMenuItem: Initializes
   Loader::available_animals ..> AnimalMenuItemContainer
   AnimalMenuItemContainer ..> AnimalMenuItem: Initializes

   @enduml

Data Structures
---------------

.. uml::

   @startuml
   skinparam packageStyle rectangle

   package DataResources {
      struct ItemDataResource {
         string : resource_name
         StreamTexture : image
         float : unit_price
         float : unit_labour
         bool : persistent
      }

      struct CropDataResource {
         float : maximum_yield
         float : f_wlimited_yield
         float : f_actual_yield
      }

      struct AnimalDataResource {
         float : yearly_revenue
         float : yearly_costs
         float : water_use
         float : manure
      }

      struct MeasureDataResource {
         float : erosion_influence
         float : salinity_influence
         float : nutrient_influence
         float : time_required
      }

      struct FertilizerDataResource {
         float : n_content
         float : long_term_influence
      }

      struct AssetDataResource {
         float : money
         float : labour
      }

      struct SchoolResource {
         int : min_age
         int : max_age
         int : years_required
         float : school_fees
      }

      struct ChildResource {
         {field} int : age (or enum)
         int : age_for_work
      }

      struct PersonResource {
         float : labour
         float : money
      }

      note right of PersonResource: add food, a person can and does eat the food they farm
   }

   package UIResources {
      struct UIResource {
         StreamTexture : mouse_idle
         PackedScene : mouse_working
         Dictionary : States
      }
   }

   package SummaryResources {
      struct placeableSummaryResource {
         int : num_implemented
         Dictionary : completed
      }

      struct AssetSummaryResource {
      }
   }

   @enduml

bla



bla

.. uml::

   @startuml

   title state machine galore

      [*] --> ApplyingMeasures: Clicked measure tab

      state ApplyingMeasures {
         [*] --> BuildingTerraces: Clicked Terrace BuyMenuItem

         state BuildingTerraces{
         NoTerracesYet --> Working: Clicked FieldBlock
         Working --> Paused: UnClicked FieldBlock
         Paused --> Working: Clicked FieldBlock
         state c <<choice>>
         Working --> c: timeout
         c --> IncompleteRow: num_build % row_size
         c --> CompletedRow: not num_build % row_size

         IncompleteRow --> Working: clicked FieldBlock
         CompletedRow --> Working: clicked FieldBlock

         c --> CompletedMeasure: num_build == row_size*column_size
         }
      }

   @enduml



.. uml::

   @startuml

   start
   group Loader
      :Get resources;
      :Resources_loaded;
   end group
   split
      group CropsBuyMenu
         :Initialize Items;
      end group
   split again
      group MeasuresMenu
         :Initialize items;
      end group

   @enduml

.. uml::

   @startjson

   title Schema for end-of-year data

   {
      "assets" : {
         "money": 1000,
         "available_animals" : [
             {
                "type": "cow"
             }
         ],
         "current_animals" : {
            "cow" : 1
         }
      },
      "available_measures" : [
         {
           "type" : "terraces",
           "per_field_cost" : 12,
           "per_field_labour" : 100,
           "other_data" : "other_value"
         },
         {
            "type" : "irrigation",
            "per_field_cost" : 20,
            "per_field_labour" : 10,
            "other_data" : "other_value"
         }
      ],
      "measures" : {
         "terraces" : {
            "fields_implemented" : [
                { "x": 0,
                  "y": 1
                }
            ]
         },
         "irrigation" : {
            "fields_implemented" : [
                {
                   "x": 0,
                   "y": 2
                }
            ]
         }
      }
   }

   @endjson
