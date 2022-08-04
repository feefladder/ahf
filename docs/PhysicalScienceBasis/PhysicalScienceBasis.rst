.. zotero-setup::
   :style: chicago-author-date

Physical science basis
======================

In order for the game to be relevant and realistic in the context of the Jos
plateau, different causes of land degradation should be incorporated, such that
the player can take measures to combat them. 

Plant growth modelling
----------------------

Plant growth modelling will be as simple as possible, while still yielding
realistic results for the Jos plateau. Initially, crop growth
values will be taken from the Yield Gap Atlas `[@HomeGlobalYield]`, a
global project for estimating yields in different agro-ecological zones. Further
effects of drought and irrigation can be estimated based on the FAO irrigation
and drainage paper :xcite:`[@AllenFAOIrrigationDrainage1998]`.



Erosion modelling
-----------------
Erosion is a big issue in the Jos plateau, and farmers are already taking
measures to combat them :xcite:`@YilaAdoptionAgriculturalLand2008`. 

For modelling erosion, several different models can be used. However, we want a
model that is:

* fast
* easy to implement/based on Python
* based on easily deriveable properties
* using a yearly timestep for making a reference
* using a daily timestep for coupling with plant growth models

Two well knows erosion models are the (Revised) Universal Soil Loss Equation
(R)USLE and the Morgan-Morgan Finley model. 

We choose the MMF model, but only implement it in the back-end modelling
framework, such that the game can remain lightweight.

Influence of erosion on nutrients is determined as follows:
 #. A concentration gradient is determined for concentration of nutrients
 #. readily soluble and soil-bound nutrients are completely leeched from the top layer
 #. good soil structure reduces erosion

Salinity modelling
------------------
text

.. uml::

   @startuml

   class Animal {
      + type: string
      + cost: int
      + revenue: int
      + manure: int
   }

   class Field {
      - size: int
      - crops: [Crop]
   }

   class Crop{
      + type: string
      - image: png file
      + seed_cost: int
      + price: int
      + max_yield: int
      + salinity_sensitivity: float
      calculate_yield()
   }

   Crop --o Field

   @enduml

.. uml::

   @startuml
   skinparam roundcorner 15

   title including a new farm
   
   rectangle inp as "Input polygon of farm dimensions"
   cloud gee as "Google Earth Engine" {
      rectangle catch as "catchments intersecting with farm"
      rectangle soil as "[[https://www.isda-africa.com/i iSDAsoil]]"
      rectangle shyd as "soil hydrological properties"
      rectangle meteo as "[[https://developers.google.com/earth-engine/datasets/catalog/ECMWF_ERA5_DAILY ERA5 meteorological data]]" {
         rectangle P as "precipitation"
         rectangle tmax
         rectangle tmin
         rectangle tmean
      }
      rectangle ETref
      rectangle clip as "clip to farm dimensions"
   }
   database "NetCDF MMF" {
      rectangle MMF as "calculate erosion risk"
   }
   package AquaCrop {
      node y_r as "rain-fed yield"
      node y_i as "irrigated yield"
      node i_r as "irrigation requirement"
   }
   rectangle s as "salinity"
   rectangle l as "leeching requirement"

   inp --> catch #pink
   catch --> soil #green
   soil --> shyd  #green: Pedotransfer functions
   catch --> meteo #green
   tmin --> ETref #green
   tmax --> ETref #green
   tmean --> ETref #green
   P --> MMF #red
   ETref --> MMF #red
   shyd --> MMF #red
   ETref --> clip #green
   P --> clip #green
   shyd --> clip #green
   clip --> y_i #red
   clip --> y_r #red
   y_i --> i_r #red
   i_r --> s: Water salinity
   s --> l: "Susceptibiltiy of crops <$arrow-right>"

   legend
      |= Type|= description|
      |<$arrow-right>|NetCDF|

   endlegend

   @enduml

.. uml::

   @startuml
   title End of year

   start
   partition "Big partition" {
      fork
         partition "Field calculator" {
            :start --> poep;
            :calculate yield;
            :calculate revenue;
         }
      fork again
         :get animals;
         :calculate revenue;
      end merge
      :sum revenue;

      partition "Field calculator" {
         :calculate fertility change;
      }
   }

   @enduml
