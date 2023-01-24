Making the game spatially explicit
==================================

There are a few impediments to making the game spatially explicit. Within the context of
this thesis, time constraints have been the main one, but this section will outline
possible problems and steps to be taken to overcome them.

Broadly speaking, there are

* Biophysical properties:
 
  * Erosion (MMF)
   
    * DEM
    * Soil data -
    * local management practices -
    * local precipitation - days/weeks/months -> daily mmf: https://doi.org/10.1016/j.jag.2017.09.003

  * Nutrient cycling (FarmDESIGN-ish)

    * N used by plants, animals etc
    * P used by plants, animals etc <-- also check if these
      `rock-eating bacteria <https://doi.org/10.1016/j.geoderma.2020.114827>`_ do
      anything interesting....
    * K used by plants animals etc

  * salinization:

    * salinity of groundwater
    * permeability of soil (also from erosion input data)
    * plant water use (AquaCrop/CropWAT/FAO56/GYGA)

* Socioeconomic properties:

  * practices
  * prices

Where data for Biophysical properties is mostly available, as opposed to socioeconomic
properties, that always require careful consideration on the local context.

Implementing biophysical properties in the game can further be divided into three
phases:

#. obtaining the data for an area of interest
#. unifying the data for this area
#. pre-processing data in well-tested models
#. using the outputs in the game
#. gradually moving preprocessing into the game where needed

Obtaining the data for an area of interest
------------------------------------------

Given that the initial thesis was developed for Nigeria, the

Furthermore, for obtaining erosion data, it is important that the upslope area of a
field is also taken into account.

DEM data
........

DEM data can be obtained either through the Python elevation module, or as

Use a Breadth-First Search and add cells to the queue with the condition:

```
Queue Q
Array2D mask
Array2D dem

for cell in mask:
    if cell == 1:
        Q.push(cell)

while not Q.empty():
    cell = Q.pop()
    mask[cell.x,cell.y] += 1
    for neighbor in cell.neighbors_in_grid():
        if neighbor.z >= cell.z and not neighbor in Q:
            Q.push(neighbor)
```
where :code:`neighbors_in_grid()` returns all neighbor cells (using a D8 connectivity)
that lie within the grid.

Soil data
.........

Soil data can be obtained in 30m resolution by adapting the
`iSDASoil tutorials <https://github.com/iSDA-Africa/isdasoil-tutorial>`_.

Pedotransfer functions
......................


Landuse data
............

This is more difficult. Proper landuse maps are rarely available at high resolution and
then also are not that good.
