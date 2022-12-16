using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName="Crop", menuName = "Measure   ")]
public class Measure : PlaceableItem {
    public List<int> RequireDirections;
    public double per_year_fertility_increase;
    public double erosion_reduction;
    // public double;
}